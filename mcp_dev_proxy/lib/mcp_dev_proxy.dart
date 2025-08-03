import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'file_watcher.dart';
import 'mcp_protocol.dart';
import 'process_manager.dart';

class MCPDevProxy {
  final Logger _logger = Logger('MCPDevProxy');
  final String targetBinary;
  final List<String> arguments;
  final Stream<String> stdinStream;
  final IOSink stdoutSink;

  late ProcessManager _processManager;

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
  Timer? _binaryMonitorTimer;
  final Set<String> _pendingToolUses = {}; // Track incomplete tool_use cycles
  final Map<dynamic, Timer> _requestTimeouts = {}; // Track request timeouts
  
  // Timeout durations for different request types
  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const Duration _toolCallTimeout = Duration(seconds: 120); // Tools can be complex
  static const Duration _listTimeout = Duration(seconds: 10); // Lists should be fast
  static const Duration _initializeTimeout = Duration(seconds: 15);

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
        _logger.fine('Tracking tool_use: $toolUseId');
      }
    }

    // Track requests for error handling and timeouts
    if (message.isRequest && message.id != null) {
      _pendingRequests[message.id] = message;
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
          // Handle proxy tool calls - always respond even when target is unavailable
          _handleProxyToolCall(message);
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
      _cancelRequestTimeout(message.id);
      final toolUseId = message.id.toString();
      if (_pendingToolUses.contains(toolUseId)) {
        _pendingToolUses.remove(toolUseId);
        _logger.fine('Completed tool_use cycle: $toolUseId');
      }
    }

    // Add proxy metadata and restart notification
    final enhancedMessage = message.withProxyMetadata(
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
    final crashError = MCPError.serverCrash(exitCode, stderr);

    // Send error responses for all pending requests
    for (final entry in _pendingRequests.entries) {
      _sendErrorToClient(entry.key, crashError);
    }
    _pendingRequests.clear();
  }

  void _scheduleRestart(String reason) {
    _logger.info('Scheduling restart due to: $reason');

    _restartPending = true;
    _lastRestartReason = reason;

    // First, send error responses for all pending requests
    // This prevents client hanging when process is restarted
    final restartError = MCPError.serverRestart(reason);
    for (final entry in _pendingRequests.entries) {
      _sendErrorToClient(entry.key, restartError);
    }
    _pendingRequests.clear();

    // Also send error responses for incomplete tool_use cycles
    for (final toolUseId in _pendingToolUses) {
      _logger.warning('Sending error for incomplete tool_use: $toolUseId');
      final toolError = MCPError(
        code: -32603,
        message: 'Tool execution interrupted by server restart',
        data: {
          'tool_use_id': toolUseId,
          'reason': reason,
          'proxy': 'mcp_dev_proxy',
          'recovery_hint': 'Use /resume command to start a fresh session without incomplete tool cycles',
        },
      );
      _sendErrorToClient(toolUseId, toolError);
    }
    _pendingToolUses.clear();
    
    // Cancel all pending timeouts
    for (final timer in _requestTimeouts.values) {
      timer.cancel();
    }
    _requestTimeouts.clear();

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

  void _handleProxyToolCall(MCPMessage message) {
    final params = message.params as Map<String, dynamic>?;
    final toolName = params?['name'] as String?;
    
    Map<String, dynamic> result;
    
    switch (toolName) {
      case 'proxy_status':
        result = {
          'content': [
            {
              'type': 'text',
              'text': _buildProxyStatusReport(),
            }
          ]
        };
        break;
      case 'proxy_help':
        result = {
          'content': [
            {
              'type': 'text', 
              'text': _buildProxyHelpText(),
            }
          ]
        };
        break;
      case 'proxy_check_tool_cycles':
        result = {
          'content': [
            {
              'type': 'text',
              'text': _buildToolCycleReport(),
            }
          ]
        };
        break;
      default:
        _sendErrorToClient(message.id, MCPError(
          code: -32601,
          message: 'Unknown tool: $toolName',
        ));
        return;
    }
    
    final response = MCPMessage(
      jsonrpc: '2.0',
      id: message.id,
      result: result,
    );
    _sendToClient(response);
  }

  String _buildProxyStatusReport() {
    final binaryExists = File(targetBinary).existsSync();
    final status = binaryExists ? 'Binary exists but process failed to start' : 'Binary not found';
    
    return '''
# MCP Dev Proxy Status

**Target Binary:** `$targetBinary`
**Status:** $status
**Process Running:** ${_processManager.isRunning}
**Monitoring Active:** ${_binaryMonitorTimer != null}

## Current State
${_startupError != null ? '⚠️ Startup Error: $_startupError' : '✅ Proxy running normally'}

## Next Steps
${binaryExists ? 
  'Binary exists but failed to start. Check if it\'s executable and implements MCP protocol.' :
  'Compile your MCP server binary: `dart compile exe bin/your_server.dart -o ${targetBinary.split('/').last}`'
}

## Proxy Capabilities
- 🔄 Crash Recovery: Auto-restart on crashes
- 🔥 Hot Reload: Detect binary changes and restart  
- 📦 Error Buffering: Handle pending requests during restarts
- 🔍 Debug Info: Enhanced error messages with context
''';
  }

  String _buildProxyHelpText() {
    return '''
# MCP Development Proxy Help

## What This Proxy Does
The MCP Dev Proxy sits between MCP clients and your MCP server, providing development-focused enhancements:

- **Crash Recovery:** Automatically restarts your server when it crashes
- **Hot Reload:** Detects when you recompile your binary and restarts
- **Error Buffering:** Handles requests gracefully during server restarts
- **Debug Information:** Provides detailed error context and guidance

## How to Work With the Proxy

### 1. Compile Your MCP Server
```bash
dart compile exe bin/your_mcp_server.dart -o ${targetBinary.split('/').last}
```

### 2. Update Your Binary
When you make code changes, just recompile. The proxy will:
- Detect the binary change
- Restart your server automatically
- Handle any pending requests gracefully

### 3. Handle Crashes
If your server crashes, the proxy will:
- Capture the crash details (exit code, stderr)
- Automatically restart the process
- Provide error context to help with debugging

### 4. Monitor Status
Use the `proxy_status` tool to check:
- Current binary status
- Process state
- Error details
- Next steps

## Integration Tips
- Point your MCP client to this proxy instead of directly to your server
- The proxy handles all MCP protocol forwarding transparently
- Your server gets automatic resilience without any code changes
- Check error messages for specific guidance when issues occur

## Current Configuration
- **Target Binary:** `$targetBinary`
- **Arguments:** ${arguments.isEmpty ? 'None' : arguments.join(' ')}
- **Monitoring:** Active (checks every 2 seconds)
''';
  }

  String _buildToolCycleReport() {
    final incompleteCount = _pendingToolUses.length;
    
    if (incompleteCount == 0) {
      return '''
# Tool Cycle Status: ✅ Clean

No incomplete tool_use cycles detected. All tool calls have proper tool_result responses.

This is the healthy state - no API errors should occur from incomplete tool cycles.
''';
    }
    
    return '''
# Tool Cycle Status: ⚠️ Issues Detected

**Incomplete tool_use cycles found: $incompleteCount**

## What This Means
You have tool_use blocks that were sent but never received corresponding tool_result responses. This typically happens when:

1. **Server Crash:** The MCP server crashed after receiving tool_use but before sending tool_result
2. **Connection Lost:** Network/process interruption during tool execution
3. **Session Resume:** Previous session was interrupted mid-tool-call

## Why This Causes API Errors
Claude expects every tool_use to have a matching tool_result. When this doesn't happen, you get:
```
API Error: 400 - tool_use ids were found without tool_result blocks
```

## How to Fix This
**Option 1: Resume Session (Recommended)**
Use `/resume` command to start a fresh conversation without incomplete tool cycles.

**Option 2: Wait for Auto-Recovery**
If your MCP server comes online, the proxy will attempt to complete pending tool calls.

## Incomplete Tool IDs
${_pendingToolUses.map((id) => '- $id').join('\n')}

## Prevention
The proxy now tracks tool cycles and will:
- Send error responses for incomplete tools during restarts
- Provide this diagnostic tool to detect issues
- Guide you on recovery steps

Use `proxy_status` for overall server health and `proxy_help` for general guidance.
''';
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
    
    // Determine appropriate timeout based on request type
    Duration timeout;
    if (message.method == 'initialize') {
      timeout = _initializeTimeout;
    } else if (message.method == 'tools/call') {
      timeout = _toolCallTimeout;
    } else if (message.method?.endsWith('/list') == true) {
      // All list operations (tools/list, resources/list, prompts/list)
      timeout = _listTimeout;
    } else {
      timeout = _defaultTimeout;
    }
    
    _cancelRequestTimeout(message.id); // Cancel any existing timeout
    
    _requestTimeouts[message.id] = Timer(timeout, () {
      _handleRequestTimeout(message);
    });
    
    _logger.fine('Started ${timeout.inSeconds}s timeout for ${message.method} (id: ${message.id})');
  }
  
  void _cancelRequestTimeout(dynamic id) {
    final timer = _requestTimeouts.remove(id);
    timer?.cancel();
  }
  
  void _handleRequestTimeout(MCPMessage originalMessage) {
    final id = originalMessage.id;
    if (id == null) return;
    
    _logger.warning('Request timeout: ${originalMessage.method} (id: $id)');
    
    // Remove from pending requests and tool uses
    _pendingRequests.remove(id);
    _pendingToolUses.remove(id.toString());
    _cancelRequestTimeout(id);
    
    // Create timeout error with helpful guidance
    final timeoutError = MCPError(
      code: -32603,
      message: 'Request timeout',
      data: {
        'method': originalMessage.method,
        'timeout_seconds': _getTimeoutForMethod(originalMessage.method).inSeconds,
        'proxy': 'mcp_dev_proxy',
        'proxy_capabilities': [
          'crash_recovery',
          'hot_reload',
          'error_buffering',
          'debug_info'
        ],
        'guidance': _buildTimeoutGuidance(originalMessage.method),
        'recovery_hint': 'The target MCP server may be unresponsive. Check server logs or restart the connection.',
      },
    );
    
    _sendErrorToClient(id, timeoutError);
  }
  
  Duration _getTimeoutForMethod(String? method) {
    if (method == 'initialize') {
      return _initializeTimeout;
    } else if (method == 'tools/call') {
      return _toolCallTimeout;
    } else if (method?.endsWith('/list') == true) {
      return _listTimeout;
    } else {
      return _defaultTimeout;
    }
  }
  
  String _buildTimeoutGuidance(String? method) {
    switch (method) {
      case 'initialize':
        return 'Server took too long to initialize. Check if the binary is working correctly.';
      case 'tools/call':
        return 'Tool execution exceeded timeout. The tool may be stuck in an infinite loop or blocked on I/O.';
      case 'tools/list':
        return 'Server took too long to list available tools. Check server implementation.';
      case 'resources/list':
        return 'Server took too long to list resources. Check server implementation.';
      case 'prompts/list':
        return 'Server took too long to list prompts. Check server implementation.';
      default:
        return 'Request took longer than expected. The target server may be unresponsive.';
    }
  }

  Future<void> stop() async {
    _logger.info('Stopping MCP Dev Proxy');

    await _stdinSubscription?.cancel();
    await _stdoutSubscription?.cancel();
    await _fileWatchSubscription?.cancel();
    _stopBinaryMonitoring();
    
    // Cancel all pending timeouts
    for (final timer in _requestTimeouts.values) {
      timer.cancel();
    }
    _requestTimeouts.clear();

    await _processManager.stop();
    await _fileWatcher.stop();

    _logger.info('MCP Dev Proxy stopped');
  }
}
