import "dart:async";
import "dart:io";

import "package:logging/logging.dart";

import "../../file_watcher.dart";
import "../../process_manager.dart";
import "../core/proxy_state.dart";
import "../core/tool_cycle_tracker.dart";

/// Manages the lifecycle of all proxy components including process startup,
/// file watching, and coordinated shutdown.
///
/// This class is responsible for:
/// - Starting and stopping the target process
/// - Managing file watching for hot reload
/// - Coordinating component initialization and cleanup
/// - Handling process crashes and restarts
class ProxyLifecycleManager {
  ProxyLifecycleManager({
    required String targetBinary,
    required List<String> arguments,
    required ProcessManager processManager,
    required FileWatcher fileWatcher,
    required ToolCycleTracker toolCycleTracker,
    required ProxyState proxyState,
  })  : _targetBinary = targetBinary,
        _arguments = arguments,
        _processManager = processManager,
        _fileWatcher = fileWatcher,
        _toolCycleTracker = toolCycleTracker,
        _proxyState = proxyState;

  final Logger _logger = Logger("ProxyLifecycleManager");
  final String _targetBinary;
  final List<String> _arguments;
  final ProcessManager _processManager;
  final FileWatcher _fileWatcher;
  final ToolCycleTracker _toolCycleTracker;
  final ProxyState _proxyState;

  StreamSubscription<void>? _fileWatchSubscription;
  void Function(int, String?)? _onProcessCrash;
  void Function(String)? _onScheduleRestart;

  /// Sets callback for process crash handling.
  void setProcessCrashHandler(
    void Function(int exitCode, String? stderr) handler,
  ) {
    _onProcessCrash = handler;
  }

  /// Sets callback for restart scheduling.
  void setRestartHandler(void Function(String reason) handler) {
    _onScheduleRestart = handler;
  }

  /// Starts all proxy lifecycle components.
  Future<void> start() async {
    _logger.info("Starting proxy lifecycle components");
    _logger.info("Target binary: $_targetBinary");
    _logger.info("Arguments: ${_arguments.join(" ")}");

    // Always start file watcher and stdin listener, even if target process fails
    await _startFileWatcher();
    await _startTargetProcess(); // This now handles missing binary gracefully

    _logger.info("Proxy lifecycle started successfully");
    if (_proxyState.startupError != null) {
      _logger.info("Proxy is running but target process is not available");
      _logger.info("Waiting for binary to become available...");
    }
  }

  /// Stops all proxy lifecycle components.
  Future<void> stop() async {
    _logger.info("Stopping proxy lifecycle components");

    // Stop file watcher
    await _fileWatchSubscription?.cancel();
    _fileWatchSubscription = null;
    await _fileWatcher.stop();

    // Stop target process
    await _processManager.stop();

    // Cleanup tool cycle tracker
    _toolCycleTracker.dispose();

    _logger.info("Proxy lifecycle stopped");
  }

  /// Restarts the target process.
  Future<void> restart([String reason = "manual_restart"]) async {
    _logger.info("Restarting target process: $reason");

    _proxyState.markRestartPending(reason);

    // Stop current process
    await _processManager.stop();

    // Start new process
    await _startTargetProcess();

    _logger.info("Target process restart completed");
  }

  /// Gets current lifecycle status.
  Map<String, dynamic> getStatus() {
    return {
      "target_binary": _targetBinary,
      "binary_exists": File(_targetBinary).existsSync(),
      "process_running": _processManager.isRunning,
      "process_starting": _processManager.isStarting,
      "file_watcher_active": _fileWatchSubscription != null,
      "startup_error": _proxyState.startupError,
      "restart_pending": _proxyState.restartPending,
      "last_restart_reason": _proxyState.lastRestartReason,
    };
  }

  Future<void> _startFileWatcher() async {
    try {
      await _fileWatcher.start();
      _fileWatchSubscription = _fileWatcher.onChange.listen((_) {
        _logger.info("Target binary changed, scheduling restart");
        _onScheduleRestart?.call("binary_updated");
      });
    } on Exception catch (e) {
      _logger.warning("Failed to start file watcher: $e");
      // Don't fail proxy startup if file watcher fails
      // This allows proxy to continue running and monitoring for binary creation
    }
  }

  Future<void> _startTargetProcess() async {
    _proxyState.clearStartupError(); // Reset startup error

    // Check if binary exists before attempting to start
    final binaryFile = File(_targetBinary);
    if (!binaryFile.existsSync()) {
      _proxyState.setStartupError("Binary not found: $_targetBinary");
      _logger.warning("Target binary does not exist: $_targetBinary");
      // FileWatcher will detect when binary becomes available and trigger restart
      return;
    }

    try {
      await _processManager.start();

      // Monitor process exit
      unawaited(
        _processManager.waitForExit().then((exitCode) {
          if (exitCode != null) {
            _handleProcessCrash(exitCode);
          }
        }),
      );

      _logger.info("Target process started successfully");
    } on Exception catch (e) {
      _logger.severe("Failed to start target process: $e");

      // Capture startup error details for better error messages
      if (e is ProcessStartupException) {
        _proxyState.setStartupError(e.message);
      } else {
        _proxyState.setStartupError("Failed to start: $e");
      }

      // Don't rethrow - let proxy continue running but with startup error set
      _logger.warning(
        "Proxy will continue running but target process failed to start",
      );
    }
  }

  void _handleProcessCrash(int exitCode) {
    _logger.warning("Target process crashed with exit code: $exitCode");
    // Get stderr from process manager if available
    final stderr = "Process crashed with exit code $exitCode"; // Placeholder
    _onProcessCrash?.call(exitCode, stderr);
  }
}
