import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'file_watcher.dart';
import 'mcp_protocol.dart';
import 'process_manager.dart';
import 'src/managers/timeout_manager.dart';
import 'src/enhancers/response_enhancer.dart';
import 'src/routing/request_router.dart';
import 'src/routing/proxy_handlers.dart';

class MCPDevProxy {
  final Logger _logger = Logger('MCPDevProxy');
  final String targetBinary;
  final List<String> arguments;
  final Stream<String> stdinStream;
  final IOSink stdoutSink;

  late ProcessManager _processManager;
  late ResponseEnhancer _responseEnhancer;
  late RequestRouter _requestRouter;

  @visibleForTesting
  ProcessManager get processManager => _processManager;
  late FileWatcher _fileWatcher;

  StreamSubscription? _stdoutSubscription;
  StreamSubscription? _fileWatchSubscription;
  StreamSubscription? _stdinSubscription;

  bool _restartPending = false;
  String? _lastRestartReason;
  String? _startupError; // Track startup failures
  final Map<dynamic, MCPMessage> _pendingRequests = {};
  final Map<dynamic, DateTime> _requestTimestamps = {}; // Track when requests were added
  Timer? _binaryMonitorTimer;
  Timer? _cleanupTimer; // Timer for periodic cleanup
  final Set<String> _pendingToolUses = {}; // Track incomplete tool_use cycles
  final Map<String, DateTime> _toolUseTimestamps = {}; // Track when tool uses were added
  late TimeoutManager _timeoutManager;
  
  // Cleanup configuration
  static const Duration _maxRequestAge = Duration(minutes: 10);
  static const Duration _maxToolUseAge = Duration(minutes: 5);
  static const Duration _cleanupInterval = Duration(minutes: 1);

  MCPDevProxy({
    required this.targetBinary,
    this.arguments = const [],
    required this.stdinStream,
    required this.stdoutSink,
  }) {
    // Initialize components in constructor
    _processManager = ProcessManager(
      targetBinary: targetBinary,
      arguments: arguments,
    );
    _fileWatcher = FileWatcher(filePath: targetBinary);
    _timeoutManager = TimeoutManager();
    _responseEnhancer = ResponseEnhancer();
    _requestRouter = RequestRouter();
    _setupRequestRouter();
    _startPeriodicCleanup();
  }

  Future<void> start() async {
    _logger.info('Starting MCP Dev Proxy');
    _logger.info('Target binary: $targetBinary');
    _logger.info('Arguments: ${arguments.join(' ')}');

    // Always start file watcher and stdin listener, even if target process fails
    await _startFileWatcher();
    await _startTargetProcess(); // This now handles missing binary gracefully
    _startStdinListener();

    _logger.info('MCP Dev Proxy started successfully');
    if (_startupError != null) {
      _logger.info('Proxy is running but target process is not available');
      _logger.info('Waiting for binary to become available...');
    }
  }

  Future<void> _startFileWatcher() async {
    try {
      await _fileWatcher.start();
      _fileWatchSubscription = _fileWatcher.onChange.listen((_) {
        _logger.info('Target binary changed, scheduling restart');
        _scheduleRestart('binary_updated');
      });
    } catch (e) {
      _logger.warning('Failed to start file watcher: $e');
      // Don't fail proxy startup if file watcher fails
      // This allows proxy to continue running and monitoring for binary creation
    }
  }

  Future<void> _startTargetProcess() async {
    _startupError = null; // Reset startup error

    // Check if binary exists before attempting to start
    final binaryFile = File(targetBinary);
    if (!binaryFile.existsSync()) {
      _startupError = 'Binary not found: $targetBinary';
      _logger.warning('Target binary does not exist: $targetBinary');
      _startBinaryMonitoring();
      return;
    }

    try {
      await _processManager.start();

      _stdoutSubscription = _processManager.stdout.listen(
        _handleTargetOutput,
        onError: (error) => _logger.warning('Target stdout error: $error'),
        onDone: () => _handleTargetExit(),
      );

      // Monitor process exit
      _processManager.waitForExit().then((exitCode) {
        if (exitCode != null) {
          _handleProcessCrash(exitCode);
        }
      });

      _logger.info('Target process started successfully');
      _stopBinaryMonitoring(); // Stop monitoring once successfully started
    } catch (e) {
      _logger.severe('Failed to start target process: $e');

      // Capture startup error details for better error messages
      if (e is ProcessStartupException) {
        _startupError = e.message;
      } else {
        _startupError = 'Failed to start: $e';
      }

      // Don't rethrow - let proxy continue running but with startup error set
      _logger.warning(
          'Proxy will continue running but target process failed to start');
    }
  }

  void _startStdinListener() {
    _stdinSubscription = stdinStream.listen(
      handleClientInput,
      onError: (error) => _logger.warning('Stdin error: $error'),
      onDone: () {
        _logger.info('Stdin closed, shutting down proxy');
        stop();
      },
    );
  }

  @visibleForTesting
  void handleClientInput(String line) {
    final message = MCPProtocol.parseMessage(line);
    if (message == null) {
      _logger.warning('Failed to parse client message: $line');
      return;
    }

    _logger.fine('Client -> Proxy: ${message.method ?? 'response'}');

    // Track tool_use blocks to detect incomplete cycles
    if (message.method == 'tools/call') {
      final toolUseId = message.id?.toString();
      if (toolUseId != null) {
        _pendingToolUses.add(toolUseId);
        _toolUseTimestamps[toolUseId] = DateTime.now();
        _logger.fine('Tracking tool_use: $toolUseId');
      }
    }

    // Track requests for error handling and timeouts
    if (message.isRequest && message.id != null) {
      _pendingRequests[message.id] = message;
      _requestTimestamps[message.id] = DateTime.now();
      _startRequestTimeout(message);
    }

    // Handle special cases when target is not available
    if (!_processManager.isRunning) {
      if (message.isRequest && message.id != null) {
        // For initialize requests, provide a minimal successful response to keep connection alive
        if (message.method == 'initialize') {
          final unavailableDetails = _buildServerUnavailableDetails();
          final instructionsText = '''
Target MCP server is not available.

Expected Binary: ${unavailableDetails['expected_binary']}
Status: ${unavailableDetails['status']}
Action Needed: ${unavailableDetails['action_needed']}

Proxy Capabilities:
- Crash Recovery: Auto-restart on crashes  
- Hot Reload: Detect binary changes and restart
- Error Buffering: Handle pending requests during restarts
- Debug Info: Enhanced error messages with context

Use the 'proxy_status' tool for detailed information and 'proxy_help' for guidance.
''';
          
          final initResponse = {
            'protocolVersion': '2024-11-05',
            'capabilities': {
              'tools': {},
              'resources': {},
              'prompts': {},
            },
            'serverInfo': {
              'name': 'mcp_dev_proxy',
              'version': '1.0.0',
            },
            'instructions': instructionsText,
          };
          final response = MCPMessage(
            jsonrpc: '2.0',
            id: message.id,
            result: initResponse,
          );
          _sendToClient(response);
        } else if (message.method == 'tools/list') {
          // Provide proxy management tools when target is unavailable
          final toolsResponse = {
            'tools': [
              {
                'name': 'proxy_status',
                'description': 'Get current proxy status and target binary information',
                'inputSchema': {
                  'type': 'object',
                  'properties': {},
                },
              },
              {
                'name': 'proxy_help',
                'description': 'Get help on how to work with the MCP dev proxy',
                'inputSchema': {
                  'type': 'object',
                  'properties': {},
                },
              },
              {
                'name': 'proxy_check_tool_cycles',
                'description': 'Check for incomplete tool_use cycles that may cause API errors',
                'inputSchema': {
                  'type': 'object',
                  'properties': {},
                },
              },
            ],
          };
          final response = MCPMessage(
            jsonrpc: '2.0',
            id: message.id,
            result: toolsResponse,
          );
          _sendToClient(response);
        } else if (message.method == 'tools/call') {
          // Handle proxy tool calls via router
          _routeProxyToolCall(message);
        } else {
          // For other requests, standard unavailable error
          final errorDetails = _buildServerUnavailableDetails();
          _sendErrorToClient(
              message.id, MCPError.serverUnavailable(errorDetails));
        }
      }
      return;
    }

    // Forward to target process
    try {
      _processManager.sendMessage(line);
    } catch (e) {
      _logger.warning('Failed to forward message to target: $e');
      if (message.isRequest && message.id != null) {
        final errorDetails = _buildServerUnavailableDetails();
        _sendErrorToClient(
            message.id, MCPError.serverUnavailable(errorDetails));
      }
    }
  }

  void _handleTargetOutput(String line) {
    final message = MCPProtocol.parseMessage(line);
    if (message == null) {
      _logger.warning('Failed to parse target message: $line');
      return;
    }

    _logger.fine('Target -> Proxy: ${message.method ?? 'response'}');

    // Remove from pending requests and track tool_result completion
    if (message.isResponse && message.id != null) {
      _pendingRequests.remove(message.id);
      _requestTimestamps.remove(message.id);
      _cancelRequestTimeout(message.id);
      final toolUseId = message.id.toString();
      if (_pendingToolUses.contains(toolUseId)) {
        _pendingToolUses.remove(toolUseId);
        _toolUseTimestamps.remove(toolUseId);
        _logger.fine('Completed tool_use cycle: $toolUseId');
      }
    }

    // Add proxy metadata and restart notification
    final enhancedMessage = _responseEnhancer.enhanceResponse(
      message,
      proxyEvent: _restartPending ? 'restarted' : null,
      reason: _lastRestartReason,
    );

    if (_restartPending) {
      _restartPending = false;
      _lastRestartReason = null;
    }

    // Forward to client
    _sendToClient(enhancedMessage);
  }

  void _handleTargetExit() {
    _logger.info('Target process stdout closed');
  }

  void _handleProcessCrash(int exitCode) {
    _logger.warning('Target process crashed with exit code: $exitCode');

    final stderr = _processManager.lastStderr;
    final crashError = _responseEnhancer.createServerCrashError(exitCode, stderr);

    // Send error responses for all pending requests
    for (final entry in _pendingRequests.entries) {
      _sendErrorToClient(entry.key, crashError);
    }
    _pendingRequests.clear();
    _requestTimestamps.clear();
  }

  void _scheduleRestart(String reason) {
    _logger.info('Scheduling restart due to: $reason');

    _restartPending = true;
    _lastRestartReason = reason;

    // First, send error responses for all pending requests
    // This prevents client hanging when process is restarted
    final restartError = _responseEnhancer.createServerRestartError(reason);
    for (final entry in _pendingRequests.entries) {
      _sendErrorToClient(entry.key, restartError);
    }
    _pendingRequests.clear();
    _requestTimestamps.clear();

    // Also send error responses for incomplete tool_use cycles
    for (final toolUseId in _pendingToolUses) {
      _logger.warning('Sending error for incomplete tool_use: $toolUseId');
      final toolError = _responseEnhancer.createToolInterruptedError(toolUseId, reason);
      _sendErrorToClient(toolUseId, toolError);
    }
    _pendingToolUses.clear();
    _toolUseTimestamps.clear();
    
    // Cancel all pending timeouts
    _timeoutManager.dispose();
    _timeoutManager = TimeoutManager(); // Reinitialize for the restarted process

    // Then restart the process
    _processManager.restart().catchError((error) {
      _logger.severe('Failed to restart target process: $error');
    });
  }

  Map<String, dynamic> _buildServerUnavailableDetails() {
    final details = <String, dynamic>{
      'proxy': 'mcp_dev_proxy',
      'target_binary': targetBinary,
      'proxy_capabilities': [
        'crash_recovery',
        'hot_reload',
        'error_buffering',
        'debug_info'
      ],
    };

    // Check if binary exists
    final binaryFile = File(targetBinary);
    if (!binaryFile.existsSync()) {
      details['message'] = 'MCP server binary not found';
      details['expected_binary'] = targetBinary;
      details['action_needed'] =
          'Compile your MCP server binary and I\'ll handle the rest';
      details['status'] = 'binary_missing';
      details['integration_info'] = {
        'how_to_work_with_proxy': [
          'Provide a compiled binary at the expected path',
          'Update your binary when code changes - I\'ll detect and restart',
          'Check my error messages for specific issues',
          'Don\'t worry about crashes - I\'ll restart and notify clients'
        ]
      };
    } else if (_startupError != null) {
      details['startup_error'] = _startupError;
      details['message'] = 'Target MCP server failed to start: $_startupError';
      details['status'] = 'startup_failed';
      details['action_needed'] = 'Check your MCP server implementation';
    } else if (_processManager.isStarting) {
      details['message'] = 'Target MCP server is still starting up';
      details['status'] = 'starting';
    } else {
      details['message'] = 'Target MCP server is not running';
      details['status'] = 'stopped';
      details['action_needed'] = 'Check if your MCP server process crashed';
    }

    // Include stderr if available
    final stderr = _processManager.lastStderr;
    if (stderr.isNotEmpty) {
      details['stderr'] = stderr;
    }

    return details;
  }

  void _sendErrorToClient(dynamic id, MCPError error) {
    final errorResponse = MCPMessage.createErrorResponse(id, error);
    _sendToClient(errorResponse);
  }

  /// Setup request router with proxy tool handlers
  void _setupRequestRouter() {
    _requestRouter.registerRoute('proxy_status', ProxyStatusHandler(this));
    _requestRouter.registerRoute('proxy_help', ProxyHelpHandler(this));
    _requestRouter.registerRoute('proxy_check_tool_cycles', ProxyToolCycleHandler(this));
  }

  /// Route proxy tool calls through the request router
  Future<void> _routeProxyToolCall(MCPMessage message) async {
    final params = message.params as Map<String, dynamic>?;
    final toolName = params?['name'] as String?;
    
    if (toolName == null) {
      _sendErrorToClient(message.id, MCPError(
        code: -32602,
        message: 'Missing tool name in request',
      ));
      return;
    }

    try {
      final context = RequestContext(toolName, params ?? {}, message.id.toString());
      final result = await _requestRouter.routeRequest(toolName, params ?? {}, context);
      
      final response = MCPMessage(
        jsonrpc: '2.0',
        id: message.id,
        result: result,
      );
      _sendToClient(response);
    } catch (e) {
      if (e is RouteNotFoundException) {
        _sendErrorToClient(message.id, MCPError(
          code: -32601,
          message: 'Unknown tool: $toolName',
        ));
      } else {
        _sendErrorToClient(message.id, MCPError(
          code: -32603,
          message: 'Internal error: $e',
        ));
      }
    }
  }


  void _sendToClient(MCPMessage message) {
    final line = MCPProtocol.formatMessage(message);
    stdoutSink.writeln(line);
  }

  void _startBinaryMonitoring() {
    _stopBinaryMonitoring(); // Stop any existing monitoring

    _logger.info('Starting binary availability monitoring');
    _binaryMonitorTimer = Timer.periodic(Duration(seconds: 2), (_) {
      final binaryFile = File(targetBinary);
      if (binaryFile.existsSync()) {
        _logger
            .info('Binary now available, attempting to start target process');
        _stopBinaryMonitoring();
        _startTargetProcess();
      }
    });
  }

  void _stopBinaryMonitoring() {
    _binaryMonitorTimer?.cancel();
    _binaryMonitorTimer = null;
  }

  void _startRequestTimeout(MCPMessage message) {
    if (message.id == null) return;
    
    final timeout = _timeoutManager.getTimeout(message.method ?? '', message.params);
    
    _timeoutManager.startTimeout(
      message.id.toString(),
      message.method ?? '',
      () => _handleRequestTimeout(message)
    );
    
    _logger.fine('Started ${timeout.inSeconds}s timeout for ${message.method} (id: ${message.id})');
  }
  
  void _cancelRequestTimeout(dynamic id) {
    _timeoutManager.cancelTimeout(id.toString());
  }
  
  void _handleRequestTimeout(MCPMessage originalMessage) {
    final id = originalMessage.id;
    if (id == null) return;
    
    _logger.warning('Request timeout: ${originalMessage.method} (id: $id)');
    
    // Remove from pending requests and tool uses
    _pendingRequests.remove(id);
    _requestTimestamps.remove(id);
    _pendingToolUses.remove(id.toString());
    _toolUseTimestamps.remove(id.toString());
    _cancelRequestTimeout(id);
    
    // Create timeout error using TimeoutManager
    final timeout = _timeoutManager.getTimeout(originalMessage.method ?? '', originalMessage.params);
    final operationContext = {
      'proxy': 'mcp_dev_proxy',
      'proxy_capabilities': [
        'crash_recovery',
        'hot_reload',
        'error_buffering',
        'debug_info'
      ],
      'recovery_hint': 'The target MCP server may be unresponsive. Check server logs or restart the connection.',
    };
    
    final timeoutErrorData = _timeoutManager.createTimeoutError(
      id.toString(),
      originalMessage.method ?? '',
      timeout,
      operationContext
    );
    
    final timeoutError = MCPError.fromJson(timeoutErrorData['error']);
    _sendErrorToClient(id, timeoutError);
  }
  

  Future<void> stop() async {
    _logger.info('Stopping MCP Dev Proxy');

    await _stdinSubscription?.cancel();
    await _stdoutSubscription?.cancel();
    await _fileWatchSubscription?.cancel();
    _stopBinaryMonitoring();
    _stopPeriodicCleanup();
    
    // Cancel all pending timeouts
    _timeoutManager.dispose();

    await _processManager.stop();
    await _fileWatcher.stop();

    _logger.info('MCP Dev Proxy stopped');
  }


  /// Start periodic cleanup of stale pending requests and tool uses
  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(_cleanupInterval, (_) {
      _cleanupStaleEntries();
    });
  }

  /// Stop periodic cleanup
  void _stopPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  /// Clean up stale entries that have exceeded their TTL
  void _cleanupStaleEntries() {
    final now = DateTime.now();
    
    // Clean up stale pending requests
    final staleRequestIds = <dynamic>[];
    for (final entry in _requestTimestamps.entries) {
      if (now.difference(entry.value) > _maxRequestAge) {
        staleRequestIds.add(entry.key);
      }
    }
    
    for (final id in staleRequestIds) {
      _logger.warning('Cleaning up stale pending request: $id');
      _pendingRequests.remove(id);
      _requestTimestamps.remove(id);
      _timeoutManager.cancelTimeout(id.toString());
    }
    
    // Clean up stale tool uses
    final staleToolUseIds = <String>[];
    for (final entry in _toolUseTimestamps.entries) {
      if (now.difference(entry.value) > _maxToolUseAge) {
        staleToolUseIds.add(entry.key);
      }
    }
    
    for (final id in staleToolUseIds) {
      _logger.warning('Cleaning up stale tool_use: $id');
      _pendingToolUses.remove(id);
      _toolUseTimestamps.remove(id);
    }
    
    if (staleRequestIds.isNotEmpty || staleToolUseIds.isNotEmpty) {
      _logger.info('Cleaned up ${staleRequestIds.length} stale requests and ${staleToolUseIds.length} stale tool_uses');
    }
  }
}
