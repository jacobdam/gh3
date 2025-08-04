import "dart:async";
import "dart:io";

import "package:logging/logging.dart";
import "package:meta/meta.dart";

import "file_watcher.dart";
import "mcp_protocol.dart";
import "process_manager.dart";
import "src/core/proxy_state.dart";
import "src/core/tool_cycle_tracker.dart";
import "src/enhancers/response_enhancer.dart";
import "src/managers/configurable_timeout_manager.dart";
import "src/orchestration/error_coordinator.dart";
import "src/orchestration/message_orchestrator.dart";
import "src/orchestration/proxy_lifecycle_manager.dart";
import "src/routing/proxy_handlers.dart";
import "src/routing/request_router.dart";

class MCPDevProxy {
  MCPDevProxy({
    required this.targetBinary,
    required this.stdinStream,
    required this.stdoutSink,
    this.arguments = const [],
  }) {
    // Initialize core components
    _processManager = ProcessManager(
      targetBinary: targetBinary,
      arguments: arguments,
    );
    _fileWatcher = FileWatcher(filePath: targetBinary);
    _timeoutManager = ConfigurableTimeoutManager();
    _responseEnhancer = ResponseEnhancer();
    _requestRouter = RequestRouter();
    _proxyState = ProxyState();
    _toolCycleTracker = ToolCycleTracker();

    // Initialize orchestration components
    _lifecycleManager = ProxyLifecycleManager(
      targetBinary: targetBinary,
      arguments: arguments,
      processManager: _processManager,
      fileWatcher: _fileWatcher,
      toolCycleTracker: _toolCycleTracker,
      proxyState: _proxyState,
    );

    _errorCoordinator = ErrorCoordinator(
      responseEnhancer: _responseEnhancer,
      timeoutManager: _timeoutManager,
      proxyState: _proxyState,
      toolCycleTracker: _toolCycleTracker,
      stdoutSink: stdoutSink,
      targetBinary: targetBinary,
    );

    _messageOrchestrator = MessageOrchestrator(
      requestRouter: _requestRouter,
      proxyState: _proxyState,
      processManager: _processManager,
      errorCoordinator: _errorCoordinator,
    );

    _setupRequestRouter();
    _setupHandlers();
  }
  final Logger _logger = Logger("MCPDevProxy");
  final String targetBinary;
  final List<String> arguments;
  final Stream<String> stdinStream;
  final IOSink stdoutSink;

  // Core components
  late ProcessManager _processManager;
  late ResponseEnhancer _responseEnhancer;
  late RequestRouter _requestRouter;
  late ProxyState _proxyState;
  late FileWatcher _fileWatcher;
  late ToolCycleTracker _toolCycleTracker;
  late ConfigurableTimeoutManager _timeoutManager;

  // Orchestration components
  late ProxyLifecycleManager _lifecycleManager;
  late ErrorCoordinator _errorCoordinator;
  late MessageOrchestrator _messageOrchestrator;

  StreamSubscription<String>? _stdoutSubscription;
  StreamSubscription<String>? _stdinSubscription;

  @visibleForTesting
  ProcessManager get processManager => _processManager;

  // Getters for proxy handlers
  String? get startupError => _proxyState.startupError;
  Set<String> get pendingToolUses => _proxyState.pendingToolUses;
  ProxyState get proxyState => _proxyState;
  ToolCycleTracker get toolCycleTracker => _toolCycleTracker;

  // Process state getters (public interface instead of @visibleForTesting processManager)
  bool get isProcessRunning => _processManager.isRunning;
  bool get isProcessStarting => _processManager.isStarting;

  Future<void> start() async {
    _logger.info("Starting MCP Dev Proxy");

    // Delegate to lifecycle manager
    await _lifecycleManager.start();
    _startStdinListener();

    _logger.info("MCP Dev Proxy started successfully");
  }

  void _setupHandlers() {
    // Setup lifecycle manager handlers
    _lifecycleManager
        .setProcessCrashHandler(_errorCoordinator.handleProcessCrash);
    _lifecycleManager.setRestartHandler(_errorCoordinator.handleRestart);

    // Setup stdout subscription
    _stdoutSubscription = _processManager.stdout.listen(
      _handleTargetOutput,
      onError: (Object error) => _logger.warning("Target stdout error: $error"),
      onDone: _handleTargetExit,
    );
  }

  void _startStdinListener() {
    _stdinSubscription = stdinStream.listen(
      _messageOrchestrator.handleClientInput,
      onError: (Object error) => _logger.warning("Stdin error: $error"),
      onDone: () {
        _logger.info("Stdin closed, shutting down proxy");
        unawaited(stop());
      },
    );
  }

  @visibleForTesting
  Future<void> handleClientInput(String line) async {
    // Delegate to message orchestrator
    await _messageOrchestrator.handleClientInput(line);
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
      _timeoutManager.cancelTimeout(message.id.toString());
      final toolUseId = message.id.toString();
      if (_proxyState.pendingToolUses.contains(toolUseId)) {
        _proxyState.removePendingToolUse(toolUseId);
        _toolCycleTracker.completeToolCycle(toolUseId);
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

  void _sendToClient(MCPMessage message) {
    _errorCoordinator.sendToClient(message);
  }

  Future<void> stop() async {
    _logger.info("Stopping MCP Dev Proxy");

    await _stdinSubscription?.cancel();
    await _stdoutSubscription?.cancel();

    // Delegate to lifecycle manager
    await _lifecycleManager.stop();

    // Cancel all pending timeouts
    _timeoutManager.dispose();

    _logger.info("MCP Dev Proxy stopped");
  }

  /// Start periodic cleanup of stale pending requests and tool uses
}
