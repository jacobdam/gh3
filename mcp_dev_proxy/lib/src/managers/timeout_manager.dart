import "dart:async";

class TimeoutManager {
  static const Map<String, Duration> _methodTimeouts = {
    "initialize": Duration(seconds: 15),
    "tools/list": Duration(seconds: 10),
    "resources/list": Duration(seconds: 10),
    "prompts/list": Duration(seconds: 10),
    "tools/call": Duration(seconds: 90),
    "_default": Duration(seconds: 30),
  };

  final Map<String, Duration> _customTimeouts = {};
  final Map<String, Timer> _activeTimeouts = {};
  bool _disposed = false;

  Duration getTimeout(String method, Map<String, dynamic>? params) {
    _ensureNotDisposed();

    // Check for custom timeout in params (for long-running operations)
    if (params != null && params.containsKey("timeout_seconds")) {
      final timeoutSeconds = params["timeout_seconds"];
      if (timeoutSeconds is int && timeoutSeconds > 0) {
        return Duration(seconds: timeoutSeconds);
      }
    }

    // Check custom configured timeouts first
    if (_customTimeouts.containsKey(method)) {
      return _customTimeouts[method]!;
    }

    // Use method-specific timeout or default
    return _methodTimeouts[method] ?? _methodTimeouts["_default"]!;
  }

  Timer startTimeout(String requestId, String method, Function onTimeout) {
    _ensureNotDisposed();

    // Cancel any existing timeout for this request
    cancelTimeout(requestId);

    final timeout = getTimeout(method, null);
    final timer = Timer(timeout, () {
      _activeTimeouts.remove(requestId);
      if (!_disposed) {
        onTimeout();
      }
    });

    _activeTimeouts[requestId] = timer;
    return timer;
  }

  void cancelTimeout(String requestId) {
    if (_disposed) return;

    final timer = _activeTimeouts.remove(requestId);
    timer?.cancel();
  }

  bool hasActiveTimeout(String requestId) {
    return _activeTimeouts.containsKey(requestId);
  }

  int getActiveTimeoutCount() {
    return _activeTimeouts.length;
  }

  Map<String, dynamic> createTimeoutError(
    String requestId,
    String method,
    Duration timeout,
    Map<String, dynamic>? operationContext,
  ) {
    final errorData = <String, dynamic>{
      "method": method,
      "timeout_seconds": timeout.inSeconds,
      "suggestion": _getTimeoutSuggestion(method),
    };

    if (operationContext != null) {
      errorData["context"] = operationContext;
    }

    return {
      "jsonrpc": "2.0",
      "id": requestId,
      "error": {
        "code": -32603, // Internal error
        "message": "Request timeout",
        "data": errorData,
      },
    };
  }

  void setCustomTimeout(String method, Duration timeout) {
    _ensureNotDisposed();
    _customTimeouts[method] = timeout;
  }

  void clearCustomTimeout(String method) {
    _customTimeouts.remove(method);
  }

  void clearAllCustomTimeouts() {
    _customTimeouts.clear();
  }

  void dispose() {
    if (_disposed) return;

    _disposed = true;

    // Cancel all active timeouts
    for (final timer in _activeTimeouts.values) {
      timer.cancel();
    }
    _activeTimeouts.clear();
    _customTimeouts.clear();
  }

  String _getTimeoutSuggestion(String method) {
    switch (method) {
      case "tools/call":
        return "Tool execution exceeded timeout. The tool may be stuck in an infinite loop or blocked on I/O.";
      case "initialize":
        return "Server initialization took too long. Check if the server binary is working correctly.";
      case "tools/list":
      case "resources/list":
      case "prompts/list":
        return "List operation exceeded timeout. Server may be unresponsive or overloaded.";
      default:
        return "Request exceeded timeout. Check server health and network connectivity.";
    }
  }

  void _ensureNotDisposed() {
    if (_disposed) {
      throw StateError("TimeoutManager has been disposed");
    }
  }
}
