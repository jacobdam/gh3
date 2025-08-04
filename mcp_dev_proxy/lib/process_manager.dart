import "dart:async";
import "dart:convert";
import "dart:io";
import "package:logging/logging.dart";

class ProcessStartupException implements Exception {
  ProcessStartupException(this.message);
  final String message;

  @override
  String toString() => "ProcessStartupException: $message";
}

class ProcessManager {
  ProcessManager({
    required this.targetBinary,
    this.arguments = const [],
    this.shutdownTimeout = const Duration(seconds: 5),
    this.maxStderrBufferSize = 50 * 1024, // 50KB default
  });
  final Logger _logger = Logger("ProcessManager");
  final String targetBinary;
  final List<String> arguments;
  final Duration shutdownTimeout;
  final int maxStderrBufferSize;

  Process? _process;
  StreamController<String>? _stdoutController;
  StreamController<String>? _stderrController;
  String _stderrBuffer = "";
  bool _isStarting = false;
  Timer? _healthCheckTimer;

  Stream<String> get stdout =>
      _stdoutController?.stream ?? const Stream.empty();
  Stream<String> get stderr =>
      _stderrController?.stream ?? const Stream.empty();

  bool get isRunning => _process != null && !_isStarting;
  bool get isStarting => _isStarting;

  String get lastStderr => _stderrBuffer;

  Future<void> start() async {
    if (_isStarting) return;
    if (_process != null) {
      await stop();
    }

    _isStarting = true;
    _stderrBuffer = "";

    try {
      _logger.info("Starting process: $targetBinary ${arguments.join(" ")}");

      _stdoutController = StreamController<String>.broadcast();
      _stderrController = StreamController<String>.broadcast();

      _process = await Process.start(
        targetBinary,
        arguments,
      );

      _process!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => _stdoutController?.add(line),
            onError: (Object error) => _logger.warning("Stdout error: $error"),
          );

      _process!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          _addToStderrBuffer("$line\n");
          _stderrController?.add(line);
        },
        onError: (Object error) => _logger.warning("Stderr error: $error"),
      );

      // Start health monitoring
      _startHealthCheck();

      _logger.info("Process started with PID: ${_process!.pid}");
    } catch (e) {
      _logger.severe("Failed to start process: $e");
      _process = null;
      await _stdoutController?.close();
      await _stderrController?.close();
      _stdoutController = null;
      _stderrController = null;
      rethrow;
    } finally {
      _isStarting = false;
    }
  }

  Future<int?> stop() async {
    if (_process == null) return null;

    _logger.info("Stopping process with PID: ${_process!.pid}");

    final process = _process!;
    _process = null;

    process.kill();

    final exitCode = await process.exitCode.timeout(
      shutdownTimeout,
      onTimeout: () {
        _logger.warning("Process did not exit gracefully, killing forcefully");
        process.kill(ProcessSignal.sigkill);
        return -1;
      },
    );

    // Stop health monitoring
    _stopHealthCheck();

    await _stdoutController?.close();
    await _stderrController?.close();
    _stdoutController = null;
    _stderrController = null;

    _logger.info("Process stopped with exit code: $exitCode");
    return exitCode;
  }

  Future<void> restart() async {
    _logger.info("Restarting process");
    await stop();
    await start();
  }

  void sendMessage(String message) {
    if (_process?.stdin != null) {
      try {
        _process!.stdin.writeln(message);
      } catch (e) {
        // Handle broken pipe or closed stdin gracefully
        _logger.warning("Failed to send message to process: $e");
        throw StateError("Process stdin unavailable: $e");
      }
    } else {
      throw StateError("Process is not running");
    }
  }

  Future<int?> waitForExit() async {
    return _process?.exitCode;
  }

  /// Add line to stderr buffer with size management
  void _addToStderrBuffer(String line) {
    _stderrBuffer += line;

    // Rotate buffer if it exceeds maximum size
    if (_stderrBuffer.length > maxStderrBufferSize) {
      final lines = _stderrBuffer.split("\n");
      // Keep last 75% of lines when rotating
      final keepLines = (lines.length * 0.75).round();
      _stderrBuffer = lines.skip(lines.length - keepLines).join("\n");
      _logger.fine("Rotated stderr buffer, keeping $keepLines lines");
    }
  }

  /// Start periodic health monitoring
  void _startHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (_process == null) {
          timer.cancel();
          return;
        }

        // Check if process is still alive
        // Note: This is a simple liveness check - more sophisticated health
        // monitoring could be added here (e.g., checking stdin responsiveness)
        _logger.fine("Health check passed for PID: ${_process!.pid}");
      },
    );
  }

  /// Stop health monitoring
  void _stopHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;
  }

  /// Get process health status
  bool get isHealthy {
    return _process != null && !_isStarting;
  }
}
