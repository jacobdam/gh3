/// Centralized state management for MCP Dev Proxy
///
/// Replaces scattered state variables with a unified source of truth.
library;

import "../../mcp_protocol.dart";

/// Unified state management for the MCP Dev Proxy
class ProxyState {
  // Restart state
  bool _restartPending = false;
  String? _lastRestartReason;

  // Startup state
  String? _startupError;

  // Request tracking
  final Map<dynamic, MCPMessage> _pendingRequests = {};
  final Map<dynamic, DateTime> _requestTimestamps = {};

  // Tool cycle tracking
  final Set<String> _pendingToolUses = {};
  final Map<String, DateTime> _toolUseTimestamps = {};

  // Read-only access to restart state
  bool get restartPending => _restartPending;
  String? get lastRestartReason => _lastRestartReason;

  // Read-only access to startup state
  String? get startupError => _startupError;

  // Read-only access to request tracking
  Map<dynamic, MCPMessage> get pendingRequests =>
      Map.unmodifiable(_pendingRequests);
  Map<dynamic, DateTime> get requestTimestamps =>
      Map.unmodifiable(_requestTimestamps);

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
    _pendingRequests[id] = message;
    _requestTimestamps[id] = DateTime.now();
  }

  void removePendingRequest(dynamic id) {
    _pendingRequests.remove(id);
    _requestTimestamps.remove(id);
  }

  void clearAllPendingRequests() {
    _pendingRequests.clear();
    _requestTimestamps.clear();
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

    for (final entry in _requestTimestamps.entries) {
      if (now.difference(entry.value) > maxAge) {
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
    for (final id in staleIds) {
      removePendingRequest(id);
    }
  }

  void removeStaleToolUses(List<String> staleIds) {
    for (final id in staleIds) {
      removePendingToolUse(id);
    }
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
