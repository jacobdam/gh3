import "dart:async";
import "dart:io";

import "package:logging/logging.dart";
import "package:meta/meta.dart";

import "file_watcher.dart";
import "mcp_protocol.dart";
import "process_manager.dart";
import "src/core/proxy_state.dart";
import "src/enhancers/error_context.dart";
import "src/enhancers/response_enhancer.dart";
import "src/managers/timeout_manager.dart";
import "src/routing/proxy_handlers.dart";
import "src/routing/request_router.dart";

class MCPDevProxy {
  MCPDevProxy({
    required this.targetBinary,
    required this.stdinStream,
    required this.stdoutSink,
    this.arguments = const [],
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
  }
  final Logger _logger = Logger("MCPDevProxy");
  final String targetBinary;
  final List<String> arguments;
  final Stream<String> stdinStream;
  final IOSink stdoutSink;

  late ProcessManager _processManager;
  late ResponseEnhancer _responseEnhancer;
  late RequestRouter _requestRouter;
  late ProxyState _proxyState;
  late FileWatcher _fileWatcher;

  StreamSubscription<String>? _stdoutSubscription;
  StreamSubscription<void>? _fileWatchSubscription;
  StreamSubscription<String>? _stdinSubscription;

  Timer? _binaryMonitorTimer;
  late TimeoutManager _timeoutManager;

  @visibleForTesting
  ProcessManager get processManager => _processManager;

  // Getters for proxy handlers
  String? get startupError => _proxyState.startupError;
  Timer? get binaryMonitorTimer => _binaryMonitorTimer;
  Set<String> get pendingToolUses => _proxyState.pendingToolUses;
  ProxyState get proxyState => _proxyState;

  // Process state getters (public interface instead of @visibleForTesting processManager)
  bool get isProcessRunning => _processManager.isRunning;
  bool get isProcessStarting => _processManager.isStarting;

  Future<void> start() async {
    _logger.info("Starting MCP Dev Proxy");
    _logger.info("Target binary: $targetBinary");
    _logger.info("Arguments: ${arguments.join(" ")}");

    // Always start file watcher and stdin listener, even if target process fails
    await _startFileWatcher();
    await _startTargetProcess(); // This now handles missing binary gracefully
    _startStdinListener();

    _logger.info("MCP Dev Proxy started successfully");
    if (_proxyState.startupError != null) {
      _logger.info("Proxy is running but target process is not available");
      _logger.info("Waiting for binary to become available...");
    }
  }

  Future<void> _startFileWatcher() async {
    try {
      await _fileWatcher.start();
      _fileWatchSubscription = _fileWatcher.onChange.listen((_) {
        _logger.info("Target binary changed, scheduling restart");
        _scheduleRestart("binary_updated");
      });
    } on Exception catch (e) {
      _logger.warning("Failed to start file watcher: $e");
      // Don"t fail proxy startup if file watcher fails
      // This allows proxy to continue running and monitoring for binary creation
    }
  }

  Future<void> _startTargetProcess() async {
    _proxyState.clearStartupError(); // Reset startup error

    // Check if binary exists before attempting to start
    final binaryFile = File(targetBinary);
    if (!binaryFile.existsSync()) {
      _proxyState.setStartupError("Binary not found: $targetBinary");
      _logger.warning("Target binary does not exist: $targetBinary");
      _startBinaryMonitoring();
      return;
    }

    try {
      await _processManager.start();

      _stdoutSubscription = _processManager.stdout.listen(
        _handleTargetOutput,
        onError: (Object error) =>
            _logger.warning("Target stdout error: $error"),
        onDone: _handleTargetExit,
      );

      // Monitor process exit
      unawaited(
        _processManager.waitForExit().then((exitCode) {
          if (exitCode != null) {
            _handleProcessCrash(exitCode);
          }
        }),
      );

      _logger.info("Target process started successfully");
      _stopBinaryMonitoring(); // Stop monitoring once successfully started
    } on Exception catch (e) {
      _logger.severe("Failed to start target process: $e");

      // Capture startup error details for better error messages
      if (e is ProcessStartupException) {
        _proxyState.setStartupError(e.message);
      } else {
        _proxyState.setStartupError("Failed to start: $e");
      }

      // Don"t rethrow - let proxy continue running but with startup error set
      _logger.warning(
        "Proxy will continue running but target process failed to start",
      );
    }
  }

  void _startStdinListener() {
    _stdinSubscription = stdinStream.listen(
      handleClientInput,
      onError: (Object error) => _logger.warning("Stdin error: $error"),
      onDone: () {
        _logger.info("Stdin closed, shutting down proxy");
        unawaited(stop());
      },
    );
  }

  @visibleForTesting
  Future<void> handleClientInput(String line) async {
    final message = MCPProtocol.parseMessage(line);
    if (message == null) {
      _logger.warning("Failed to parse client message: $line");
      return;
    }

    _logger.fine("Client -> Proxy: ${message.method ?? "response"}");

    // Track tool_use blocks to detect incomplete cycles
    if (message.method == "tools/call") {
      final toolUseId = message.id?.toString();
      if (toolUseId != null) {
        _proxyState.addPendingToolUse(toolUseId);
        _logger.fine("Tracking tool_use: $toolUseId");
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
    } on Exception catch (e) {
      _logger.warning("Failed to forward message to target: $e");
      if (message.isRequest && message.id != null) {
        final context = ErrorContext(
          targetCommand: targetBinary,
          lastOutput: _proxyState.startupError ?? _processManager.lastStderr,
          workingDirectory: Directory.current.path,
          environment: {
            "binaryExists": File(targetBinary).existsSync().toString(),
          },
        );
        final error = _responseEnhancer.createServerUnavailableError(
          context,
          additionalData: {
            "error": e.toString(),
            "method": message.method,
          },
        );
        _sendErrorToClient(message.id, error);
      }
    }
  }

  void _handleTargetOutput(String line) {
    final message = MCPProtocol.parseMessage(line);
    if (message == null) {
      _logger.warning("Failed to parse target message: $line");
      return;
    }

    _logger.fine("Target -> Proxy: ${message.method ?? "response"}");

    // Remove from pending requests and track tool_result completion
    if (message.isResponse && message.id != null) {
      _proxyState.removePendingRequest(message.id);
      _cancelRequestTimeout(message.id);
      final toolUseId = message.id.toString();
      if (_proxyState.pendingToolUses.contains(toolUseId)) {
        _proxyState.removePendingToolUse(toolUseId);
        _logger.fine("Completed tool_use cycle: $toolUseId");
      }
    }

    // Add proxy metadata and restart notification
    final enhancedMessage = _responseEnhancer.enhanceResponse(
      message,
      proxyEvent: _proxyState.restartPending ? "restarted" : null,
      reason: _proxyState.lastRestartReason,
    );

    if (_proxyState.restartPending) {
      _proxyState.clearRestartPending();
    }

    // Forward to client
    _sendToClient(enhancedMessage);
  }

  void _handleTargetExit() {
    _logger.info("Target process stdout closed");
  }

  void _handleProcessCrash(int exitCode) {
    _logger.warning("Target process crashed with exit code: $exitCode");

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
    _logger.info("Scheduling restart due to: $reason");

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
      _logger.warning("Sending error for incomplete tool_use: $toolUseId");
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
    unawaited(
      _processManager.restart().catchError((Object error) {
        _logger.severe("Failed to restart target process: $error");
      }),
    );
  }

  void _sendErrorToClient(dynamic id, MCPError error) {
    final errorResponse = MCPMessage.createErrorResponse(id, error);
    _sendToClient(errorResponse);
  }

  /// Setup request router with proxy tool handlers
  void _setupRequestRouter() {
    _requestRouter.registerRoute("proxy_status", ProxyStatusHandler(this));
    _requestRouter.registerRoute("proxy_help", ProxyHelpHandler());
    _requestRouter.registerRoute(
      "proxy_check_tool_cycles",
      ProxyToolCycleHandler(this),
    );

    // Register handlers for when target server is unavailable
    _requestRouter.registerRoute("initialize", InitializeHandler(this));
    _requestRouter.registerRoute("tools/list", ToolsListHandler());
  }

  /// Route requests through request router when target is unavailable
  Future<void> _routeRequestWhenUnavailable(MCPMessage message) async {
    final method = message.method;

    if (method != null && _requestRouter.canHandle(method)) {
      try {
        final params =
            message.params as Map<String, dynamic>? ?? <String, dynamic>{};
        final context =
            RequestContext(method, params, message.id?.toString() ?? "");
        final result =
            await _requestRouter.routeRequest(method, params, context);

        final response = MCPMessage(
          jsonrpc: "2.0",
          id: message.id,
          result: result,
        );
        _sendToClient(response);
      } on Exception catch (e) {
        _logger.warning("Failed to route request through RequestRouter: $e");
        final context = ErrorContext(
          targetCommand: targetBinary,
          lastOutput: _proxyState.startupError ?? _processManager.lastStderr,
          workingDirectory: Directory.current.path,
          environment: {
            "binaryExists": File(targetBinary).existsSync().toString(),
          },
        );
        final error = _responseEnhancer.createServerUnavailableError(
          context,
          additionalData: {
            "error": e.toString(),
            "method": method,
          },
        );
        _sendErrorToClient(message.id, error);
      }
    } else if (method == "tools/call") {
      // Handle proxy tool calls
      final params = message.params as Map<String, dynamic>?;
      final toolName = params?["name"] as String?;

      if (toolName == null) {
        _sendErrorToClient(
          message.id,
          MCPError(
            code: -32602,
            message: "Missing tool name in request",
          ),
        );
        return;
      }

      try {
        final safeParams = params ?? <String, dynamic>{};
        final context =
            RequestContext(toolName, safeParams, message.id?.toString() ?? "");
        final result =
            await _requestRouter.routeRequest(toolName, safeParams, context);

        final response = MCPMessage(
          jsonrpc: "2.0",
          id: message.id,
          result: result,
        );
        _sendToClient(response);
      } on Exception catch (e) {
        if (e is RouteNotFoundException) {
          _sendErrorToClient(
            message.id,
            MCPError(
              code: -32601,
              message: "Unknown tool: $toolName",
            ),
          );
        } else {
          _sendErrorToClient(
            message.id,
            MCPError(
              code: -32603,
              message: "Internal error: $e",
            ),
          );
        }
      }
    } else {
      // For unhandled methods, send standard unavailable error
      final context = ErrorContext(
        targetCommand: targetBinary,
        lastOutput: _proxyState.startupError ?? _processManager.lastStderr,
        workingDirectory: Directory.current.path,
        environment: {
          "binaryExists": File(targetBinary).existsSync().toString(),
        },
      );
      final error = _responseEnhancer.createServerUnavailableError(
        context,
        additionalData: {
          "method": method,
          "message": "Target server unavailable for unhandled method",
        },
      );
      _sendErrorToClient(message.id, error);
    }
  }

  void _sendToClient(MCPMessage message) {
    final line = MCPProtocol.formatMessage(message);
    stdoutSink.writeln(line);
  }

  void _startBinaryMonitoring() {
    _stopBinaryMonitoring(); // Stop any existing monitoring

    _logger.info("Starting binary availability monitoring");
    _binaryMonitorTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final binaryFile = File(targetBinary);
      if (binaryFile.existsSync()) {
        _logger
            .info("Binary now available, attempting to start target process");
        _stopBinaryMonitoring();
        unawaited(_startTargetProcess());
      }
    });
  }

  void _stopBinaryMonitoring() {
    _binaryMonitorTimer?.cancel();
    _binaryMonitorTimer = null;
  }

  void _startRequestTimeout(MCPMessage message) {
    if (message.id == null) return;

    final timeout = _timeoutManager.getTimeout(
      message.method ?? "",
      message.params as Map<String, dynamic>? ?? <String, dynamic>{},
    );

    _timeoutManager.startTimeout(
      message.id.toString(),
      message.method ?? "",
      () => _handleRequestTimeout(message),
    );

    _logger.fine(
      "Started ${timeout.inSeconds}s timeout for ${message.method} (id: ${message.id})",
    );
  }

  void _cancelRequestTimeout(dynamic id) {
    _timeoutManager.cancelTimeout(id.toString());
  }

  void _handleRequestTimeout(MCPMessage originalMessage) {
    final id = originalMessage.id;
    if (id == null) return;

    _logger.warning("Request timeout: ${originalMessage.method} (id: $id)");

    // Remove from pending requests and tool uses
    _proxyState.removePendingRequest(id);
    _proxyState.removePendingToolUse(id.toString());
    _cancelRequestTimeout(id);

    // Create timeout error using TimeoutManager
    final timeout = _timeoutManager.getTimeout(
      originalMessage.method ?? "",
      originalMessage.params as Map<String, dynamic>? ?? <String, dynamic>{},
    );
    final operationContext = {
      "proxy": "mcp_dev_proxy",
      "proxy_capabilities": [
        "crash_recovery",
        "hot_reload",
        "error_buffering",
        "debug_info",
      ],
      "recovery_hint":
          "The target MCP server may be unresponsive. Check server logs or restart the connection.",
    };

    final timeoutErrorData = _timeoutManager.createTimeoutError(
      id.toString(),
      originalMessage.method ?? "",
      timeout,
      operationContext,
    );

    final timeoutError =
        MCPError.fromJson(timeoutErrorData["error"] as Map<String, dynamic>);
    _sendErrorToClient(id, timeoutError);
  }

  Future<void> stop() async {
    _logger.info("Stopping MCP Dev Proxy");

    await _stdinSubscription?.cancel();
    await _stdoutSubscription?.cancel();
    await _fileWatchSubscription?.cancel();
    _stopBinaryMonitoring();

    // Cancel all pending timeouts
    _timeoutManager.dispose();

    await _processManager.stop();
    await _fileWatcher.stop();

    _logger.info("MCP Dev Proxy stopped");
  }

  /// Start periodic cleanup of stale pending requests and tool uses
}
