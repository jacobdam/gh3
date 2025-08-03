import "dart:async";
import "dart:io";
import "package:logging/logging.dart";
import "package:watcher/watcher.dart";

class FileWatcher {

  FileWatcher({
    required this.filePath,
    this.debounceDelay = const Duration(milliseconds: 500),
  });
  final Logger _logger = Logger("FileWatcher");
  final String filePath;
  final Duration debounceDelay;

  DirectoryWatcher? _watcher;
  StreamSubscription<WatchEvent>? _watcherSubscription;
  Timer? _debounceTimer;
  StreamController<void>? _changeController;

  Stream<void> get onChange =>
      _changeController?.stream ?? const Stream.empty();

  Future<void> start() async {
    if (_watcher != null) return;

    final file = File(filePath);
    final directory = file.parent;
    final fileName = file.uri.pathSegments.last;

    // Check if directory exists before starting watcher
    if (!directory.existsSync()) {
      throw FileSystemException("Directory does not exist", directory.path);
    }

    _logger.info("Starting file watcher for: $filePath");

    _changeController = StreamController<void>.broadcast();
    _watcher = DirectoryWatcher(directory.path);

    _watcherSubscription = _watcher!.events.listen((event) {
      if (event.path.endsWith(fileName) &&
          (event.type == ChangeType.MODIFY || event.type == ChangeType.ADD)) {
        _logger.fine("File change detected: ${event.path} (${event.type})");
        _debounceChange();
      }
    }, onError: (Object error) {
      _logger.warning("File watcher error: $error");
    },);
  }

  void _debounceChange() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDelay, () {
      _logger.info("File change confirmed after debounce: $filePath");
      _changeController?.add(null);
    });
  }

  Future<void> stop() async {
    if (_watcher == null) return;

    _logger.info("Stopping file watcher");

    _debounceTimer?.cancel();
    _debounceTimer = null;

    await _watcherSubscription?.cancel();
    _watcherSubscription = null;

    _watcher = null;

    await _changeController?.close();
    _changeController = null;
  }

  bool get isWatching => _watcher != null;
}
