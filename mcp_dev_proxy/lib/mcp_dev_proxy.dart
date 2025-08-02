import 'dart:async';
import 'dart:convert';
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
  final Map<dynamic, MCPMessage> _pendingRequests = {};

  MCPDevProxy({
    required this.targetBinary,
    this.arguments = const [],
    Stream<String>? stdinStream,
    IOSink? stdoutSink,
  })  : stdinStream = stdinStream ?? _createDefaultStdinStream(),
        stdoutSink = stdoutSink ?? stdout;

  static Stream<String> _createDefaultStdinStream() {
    try {
      return stdin.transform(utf8.decoder).transform(const LineSplitter());
    } catch (e) {
      // In test environments or when stdin is unavailable, return empty stream
      return const Stream.empty();
    }
  }

  Future<void> start() async {
    _logger.info('Starting MCP Dev Proxy');
    _logger.info('Target binary: $targetBinary');
    _logger.info('Arguments: ${arguments.join(' ')}');

    _processManager = ProcessManager(
      targetBinary: targetBinary,
      arguments: arguments,
    );

    _fileWatcher = FileWatcher(filePath: targetBinary);

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
    } catch (e) {
      _logger.severe('Failed to start target process: $e');
      rethrow;
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
        // Process not running, return error
        if (message.isRequest && message.id != null) {
          _sendErrorToClient(message.id, MCPError.serverUnavailable());
        }
      }
    } catch (e) {
      _logger.warning('Failed to forward message to target: $e');
      if (message.isRequest && message.id != null) {
        _sendErrorToClient(message.id, MCPError.serverUnavailable());
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
