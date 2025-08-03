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
import 'src/core/proxy_state.dart';

class MCPDevProxy {
  final Logger _logger = Logger('MCPDevProxy');
  final String targetBinary;
  final List<String> arguments;
  final Stream<String> stdinStream;
  final IOSink stdoutSink;

  late ProcessManager _processManager;
  late ResponseEnhancer _responseEnhancer;
  late RequestRouter _requestRouter;
  late ProxyState _proxyState;

  @visibleForTesting
  ProcessManager get processManager => _processManager;
  late FileWatcher _fileWatcher;

  StreamSubscription? _stdoutSubscription;
  StreamSubscription? _fileWatchSubscription;
  StreamSubscription? _stdinSubscription;

  Timer? _binaryMonitorTimer;
  Timer? _cleanupTimer; // Timer for periodic cleanup
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
    _proxyState = ProxyState();
    _setupRequestRouter();
    _startPeriodicCleanup();
  }

  // Getters for proxy handlers
  String? get startupError => _proxyState.startupError;
  Timer? get binaryMonitorTimer => _binaryMonitorTimer;
  Set<String> get pendingToolUses => _proxyState.pendingToolUses;

  Future<void> start() async {
    _logger.info('Starting MCP Dev Proxy');
    _logger.info('Target binary: $targetBinary');
    _logger.info('Arguments: ${arguments.join(' ')}');

    // Always start file watcher and stdin listener, even if target process fails
    await _startFileWatcher();
    await _startTargetProcess(); // This now handles missing binary gracefully
    _startStdinListener();

    _logger.info('MCP Dev Proxy started successfully');
    if (_proxyState.startupError != null) {
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
    _proxyState.clearStartupError(); // Reset startup error

    // Check if binary exists before attempting to start
    final binaryFile = File(targetBinary);
    if (!binaryFile.existsSync()) {
      _proxyState.setStartupError('Binary not found: $targetBinary');
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
        _proxyState.setStartupError(e.message);
      } else {
        _proxyState.setStartupError('Failed to start: $e');
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
  Future<void> handleClientInput(String line) async {
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
        _proxyState.addPendingToolUse(toolUseId);
        _logger.fine('Tracking tool_use: $toolUseId');
      }
    }

    // Track requests for error handling and timeouts
    if (message.isRequest && message.id != null) {
      _proxyState.addPendingRequest(message.id, message);
      _startRequestTimeout(message);
    }

    // Handle special cases when target is not available
    if (!_processManager.isRunning) {
      if (message.isRequest && message.id != null) {
        await _routeRequestWhenUnavailable(message);
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
      _proxyState.removePendingRequest(message.id);
      _cancelRequestTimeout(message.id);
      final toolUseId = message.id.toString();
      if (_proxyState.pendingToolUses.contains(toolUseId)) {
        _proxyState.removePendingToolUse(toolUseId);
        _logger.fine('Completed tool_use cycle: $toolUseId');
      }
    }

    // Add proxy metadata and restart notification
    final enhancedMessage = _responseEnhancer.enhanceResponse(
      message,
      proxyEvent: _proxyState.restartPending ? 'restarted' : null,
      reason: _proxyState.lastRestartReason,
    );

    if (_proxyState.restartPending) {
      _proxyState.clearRestartPending();
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
    final crashError =
        _responseEnhancer.createServerCrashError(exitCode, stderr);

    // Send error responses for all pending requests
    for (final entry in _proxyState.pendingRequests.entries) {
      _sendErrorToClient(entry.key, crashError);
    }
    _proxyState.clearAllPendingRequests();
  }

  void _scheduleRestart(String reason) {
    _logger.info('Scheduling restart due to: $reason');

    _proxyState.markRestartPending(reason);

    // First, send error responses for all pending requests
    // This prevents client hanging when process is restarted
    final restartError = _responseEnhancer.createServerRestartError(reason);
    for (final entry in _proxyState.pendingRequests.entries) {
      _sendErrorToClient(entry.key, restartError);
    }
    _proxyState.clearAllPendingRequests();

    // Also send error responses for incomplete tool_use cycles
    for (final toolUseId in _proxyState.pendingToolUses) {
      _logger.warning('Sending error for incomplete tool_use: $toolUseId');
      final toolError =
          _responseEnhancer.createToolInterruptedError(toolUseId, reason);
      _sendErrorToClient(toolUseId, toolError);
    }
    _proxyState.clearAllPendingToolUses();

    // Cancel all pending timeouts
    _timeoutManager.dispose();
    _timeoutManager =
        TimeoutManager(); // Reinitialize for the restarted process

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
    } else if (_proxyState.startupError != null) {
      details['startup_error'] = _proxyState.startupError;
      details['message'] = 'Target MCP server failed to start: ${_proxyState.startupError}';
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
    _requestRouter.registerRoute(
        'proxy_check_tool_cycles', ProxyToolCycleHandler(this));
    
    // Register handlers for when target server is unavailable
    _requestRouter.registerRoute('initialize', InitializeHandler(this));
    _requestRouter.registerRoute('tools/list', ToolsListHandler(this));
  }

  /// Route requests through request router when target is unavailable
  Future<void> _routeRequestWhenUnavailable(MCPMessage message) async {
    final method = message.method;
    
    if (method != null && _requestRouter.canHandle(method)) {
      try {
        final context = RequestContext(method, message.params ?? {}, message.id?.toString() ?? '');
        final result = await _requestRouter.routeRequest(method, message.params ?? {}, context);
        
        final response = MCPMessage(
          jsonrpc: '2.0',
          id: message.id,
          result: result,
        );
        _sendToClient(response);
      } catch (e) {
        _logger.warning('Failed to route request through RequestRouter: $e');
        final errorDetails = _buildServerUnavailableDetails();
        _sendErrorToClient(message.id, MCPError.serverUnavailable(errorDetails));
      }
    } else if (method == 'tools/call') {
      // Handle proxy tool calls 
      final params = message.params as Map<String, dynamic>?;
      final toolName = params?['name'] as String?;

      if (toolName == null) {
        _sendErrorToClient(
            message.id,
            MCPError(
              code: -32602,
              message: 'Missing tool name in request',
            ));
        return;
      }

      try {
        final context = RequestContext(toolName, params ?? {}, message.id?.toString() ?? '');
        final result = await _requestRouter.routeRequest(toolName, params ?? {}, context);

        final response = MCPMessage(
          jsonrpc: '2.0',
          id: message.id,
          result: result,
        );
        _sendToClient(response);
      } catch (e) {
        if (e is RouteNotFoundException) {
          _sendErrorToClient(
              message.id,
              MCPError(
                code: -32601,
                message: 'Unknown tool: $toolName',
              ));
        } else {
          _sendErrorToClient(
              message.id,
              MCPError(
                code: -32603,
                message: 'Internal error: $e',
              ));
        }
      }
    } else {
      // For unhandled methods, send standard unavailable error
      final errorDetails = _buildServerUnavailableDetails();
      _sendErrorToClient(message.id, MCPError.serverUnavailable(errorDetails));
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

    final timeout =
        _timeoutManager.getTimeout(message.method ?? '', message.params);

    _timeoutManager.startTimeout(message.id.toString(), message.method ?? '',
        () => _handleRequestTimeout(message));

    _logger.fine(
        'Started ${timeout.inSeconds}s timeout for ${message.method} (id: ${message.id})');
  }

  void _cancelRequestTimeout(dynamic id) {
    _timeoutManager.cancelTimeout(id.toString());
  }

  void _handleRequestTimeout(MCPMessage originalMessage) {
    final id = originalMessage.id;
    if (id == null) return;

    _logger.warning('Request timeout: ${originalMessage.method} (id: $id)');

    // Remove from pending requests and tool uses
    _proxyState.removePendingRequest(id);
    _proxyState.removePendingToolUse(id.toString());
    _cancelRequestTimeout(id);

    // Create timeout error using TimeoutManager
    final timeout = _timeoutManager.getTimeout(
        originalMessage.method ?? '', originalMessage.params);
    final operationContext = {
      'proxy': 'mcp_dev_proxy',
      'proxy_capabilities': [
        'crash_recovery',
        'hot_reload',
        'error_buffering',
        'debug_info'
      ],
      'recovery_hint':
          'The target MCP server may be unresponsive. Check server logs or restart the connection.',
    };

    final timeoutErrorData = _timeoutManager.createTimeoutError(
        id.toString(), originalMessage.method ?? '', timeout, operationContext);

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
    // Clean up stale pending requests
    final staleRequestIds = _proxyState.getStaleRequestIds(_maxRequestAge);
    for (final id in staleRequestIds) {
      _logger.warning('Cleaning up stale pending request: $id');
      _timeoutManager.cancelTimeout(id.toString());
    }
    _proxyState.removeStaleRequests(staleRequestIds);

    // Clean up stale tool uses
    final staleToolUseIds = _proxyState.getStaleToolUseIds(_maxToolUseAge);
    for (final id in staleToolUseIds) {
      _logger.warning('Cleaning up stale tool_use: $id');
    }
    _proxyState.removeStaleToolUses(staleToolUseIds);

    if (staleRequestIds.isNotEmpty || staleToolUseIds.isNotEmpty) {
      _logger.info(
          'Cleaned up ${staleRequestIds.length} stale requests and ${staleToolUseIds.length} stale tool_uses');
    }
  }
}
