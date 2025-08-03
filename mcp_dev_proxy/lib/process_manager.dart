import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';

class ProcessStartupException implements Exception {
  final String message;
  ProcessStartupException(this.message);

  @override
  String toString() => 'ProcessStartupException: $message';
}

class ProcessManager {
  final Logger _logger = Logger('ProcessManager');
  final String targetBinary;
  final List<String> arguments;

  Process? _process;
  StreamController<String>? _stdoutController;
  StreamController<String>? _stderrController;
  String _stderrBuffer = '';
  bool _isStarting = false;

  ProcessManager({
    required this.targetBinary,
    this.arguments = const [],
  });

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
    _stderrBuffer = '';

    try {
      _logger.info('Starting process: $targetBinary ${arguments.join(' ')}');

      _stdoutController = StreamController<String>.broadcast();
      _stderrController = StreamController<String>.broadcast();

      _process = await Process.start(
        targetBinary,
        arguments,
        mode: ProcessStartMode.normal,
      );

      _process!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => _stdoutController?.add(line),
            onError: (Object error) => _logger.warning('Stdout error: $error'),
          );

      _process!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          _stderrBuffer += '$line\n';
          _stderrController?.add(line);
        },
        onError: (Object error) => _logger.warning('Stderr error: $error'),
      );

      _logger.info('Process started with PID: ${_process!.pid}');
    } catch (e) {
      _logger.severe('Failed to start process: $e');
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

    _logger.info('Stopping process with PID: ${_process!.pid}');

    final process = _process!;
    _process = null;

    process.kill(ProcessSignal.sigterm);

    final exitCode = await process.exitCode.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        _logger.warning('Process did not exit gracefully, killing forcefully');
        process.kill(ProcessSignal.sigkill);
        return -1;
      },
    );

    await _stdoutController?.close();
    await _stderrController?.close();
    _stdoutController = null;
    _stderrController = null;

    _logger.info('Process stopped with exit code: $exitCode');
    return exitCode;
  }

  Future<void> restart() async {
    _logger.info('Restarting process');
    await stop();
    await start();
  }

  void sendMessage(String message) {
    if (_process?.stdin != null) {
      try {
        _process!.stdin.writeln(message);
      } catch (e) {
        // Handle broken pipe or closed stdin gracefully
        _logger.warning('Failed to send message to process: $e');
        throw StateError('Process stdin unavailable: $e');
      }
    } else {
      throw StateError('Process is not running');
    }
  }

  Future<int?> waitForExit() async {
    return _process?.exitCode;
  }
}
