/// Centralized state management for MCP Dev Proxy
///
/// Replaces scattered state variables with a unified source of truth.
library;

import "../../mcp_protocol.dart";

/// Information about a pending request
class RequestInfo {
  const RequestInfo({
    required this.message,
    required this.timestamp,
  });

  final MCPMessage message;
  final DateTime timestamp;
  
  String? get method => message.method;
}

/// Unified state management for the MCP Dev Proxy
class ProxyState {
  // Restart state
  bool _restartPending = false;
  String? _lastRestartReason;

  // Startup state
  String? _startupError;

  // Request tracking
  final Map<dynamic, RequestInfo> _pendingRequests = {};

  // Tool cycle tracking
  final Set<String> _pendingToolUses = {};
  final Map<String, DateTime> _toolUseTimestamps = {};

  // Read-only access to restart state
  bool get restartPending => _restartPending;
  String? get lastRestartReason => _lastRestartReason;

  // Read-only access to startup state
  String? get startupError => _startupError;

  // Read-only access to request tracking
  Set<dynamic> get pendingRequests => Set.from(_pendingRequests.keys);
  Map<dynamic, RequestInfo> get pendingRequestsInfo =>
      Map.unmodifiable(_pendingRequests);
  Map<dynamic, DateTime> get requestTimestamps =>
      Map.fromEntries(_pendingRequests.entries.map((e) => 
          MapEntry(e.key, e.value.timestamp)));

  // Read-only access to tool cycle tracking
  Set<String> get pendingToolUses => Set.unmodifiable(_pendingToolUses);
  Map<String, DateTime> get toolUseTimestamps =>
      Map.unmodifiable(_toolUseTimestamps);

  // Restart state management
  void markRestartPending(String reason) {
    _restartPending = true;
    _lastRestartReason = reason;
  }

  void clearRestartPending() {
    _restartPending = false;
    _lastRestartReason = null;
  }

  // Startup state management
  void setStartupError(String? error) {
    _startupError = error;
  }

  void clearStartupError() {
    _startupError = null;
  }

  // Request tracking management
  void addPendingRequest(dynamic id, MCPMessage message) {
    _pendingRequests[id] = RequestInfo(
      message: message,
      timestamp: DateTime.now(),
    );
  }

  RequestInfo? removePendingRequest(dynamic id) {
    return _pendingRequests.remove(id);
  }

  void clearAllPendingRequests() {
    _pendingRequests.clear();
  }

  // Tool cycle tracking management
  void addPendingToolUse(String id) {
    _pendingToolUses.add(id);
    _toolUseTimestamps[id] = DateTime.now();
  }

  void removePendingToolUse(String id) {
    _pendingToolUses.remove(id);
    _toolUseTimestamps.remove(id);
  }

  void clearAllPendingToolUses() {
    _pendingToolUses.clear();
    _toolUseTimestamps.clear();
  }

  // Cleanup methods for TTL management
  List<dynamic> getStaleRequestIds(Duration maxAge) {
    final now = DateTime.now();
    final staleIds = <dynamic>[];

    for (final entry in _pendingRequests.entries) {
      if (now.difference(entry.value.timestamp) > maxAge) {
        staleIds.add(entry.key);
      }
    }

    return staleIds;
  }

  List<String> getStaleToolUseIds(Duration maxAge) {
    final now = DateTime.now();
    final staleIds = <String>[];

    for (final entry in _toolUseTimestamps.entries) {
      if (now.difference(entry.value) > maxAge) {
        staleIds.add(entry.key);
      }
    }

    return staleIds;
  }

  void removeStaleRequests(List<dynamic> staleIds) {
    staleIds.forEach(removePendingRequest);
  }

  void removeStaleToolUses(List<String> staleIds) {
    staleIds.forEach(removePendingToolUse);
  }

  // Diagnostic information
  Map<String, dynamic> getDiagnosticInfo() {
    return {
      "restart_pending": _restartPending,
      "last_restart_reason": _lastRestartReason,
      "startup_error": _startupError,
      "pending_requests_count": _pendingRequests.length,
      "pending_tool_uses_count": _pendingToolUses.length,
      "pending_request_ids": _pendingRequests.keys.toList(),
      "pending_tool_use_ids": _pendingToolUses.toList(),
    };
  }
}
