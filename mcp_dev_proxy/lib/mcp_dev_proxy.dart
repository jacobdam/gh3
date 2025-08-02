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

    await _startFileWatcher();
    await _startTargetProcess();
    _startStdinListener();

    _logger.info('MCP Dev Proxy started successfully');
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
    }
  }

  Future<void> _startTargetProcess() async {
    _startupError = null; // Reset startup error

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

    // Track requests for error handling
    if (message.isRequest && message.id != null) {
      _pendingRequests[message.id] = message;
    }

    // Forward to target process
    try {
      if (_processManager.isRunning) {
        _processManager.sendMessage(line);
      } else {
        // Process not running, return error with details
        if (message.isRequest && message.id != null) {
          final errorDetails = _buildServerUnavailableDetails();
          _sendErrorToClient(
              message.id, MCPError.serverUnavailable(errorDetails));
        }
      }
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

    // Remove from pending requests
    if (message.isResponse && message.id != null) {
      _pendingRequests.remove(message.id);
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

    // Then restart the process
    _processManager.restart().catchError((error) {
      _logger.severe('Failed to restart target process: $error');
    });
  }

  Map<String, dynamic> _buildServerUnavailableDetails() {
    final details = <String, dynamic>{
      'proxy': 'mcp_dev_proxy',
      'target_binary': targetBinary,
    };

    // Include startup error if we have one
    if (_startupError != null) {
      details['startup_error'] = _startupError;
      details['message'] = 'Target MCP server failed to start: $_startupError';
    } else if (_processManager.isStarting) {
      details['message'] = 'Target MCP server is still starting up';
      details['status'] = 'starting';
    } else {
      details['message'] = 'Target MCP server is not running';
      details['status'] = 'stopped';
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

  void _sendToClient(MCPMessage message) {
    final line = MCPProtocol.formatMessage(message);
    stdoutSink.writeln(line);
  }

  Future<void> stop() async {
    _logger.info('Stopping MCP Dev Proxy');

    await _stdinSubscription?.cancel();
    await _stdoutSubscription?.cancel();
    await _fileWatchSubscription?.cancel();

    await _processManager.stop();
    await _fileWatcher.stop();

    _logger.info('MCP Dev Proxy stopped');
  }
}
