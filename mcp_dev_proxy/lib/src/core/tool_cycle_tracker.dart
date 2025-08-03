import 'dart:async';

/// Tracks tool_use → tool_result cycles to prevent incomplete API interactions
/// that can break Claude sessions. Provides diagnostic reporting and recovery
/// guidance for interrupted cycles during server restarts.
class ToolCycleTracker {
  final Map<String, ToolCycleInfo> _pendingCycles = {};
  final List<ToolCycleInfo> _completedCycles = [];
  Timer? _cleanupTimer;
  
  /// Default threshold for considering cycles stale
  static const Duration staleThreshold = Duration(minutes: 5);
  
  /// Start tracking a tool cycle when tool_use message is received
  void startToolCycle(String toolCallId, DateTime timestamp) {
    _pendingCycles[toolCallId] = ToolCycleInfo(
      id: toolCallId,
      startTime: timestamp,
      status: ToolCycleStatus.pending,
    );
  }
  
  /// Complete a tool cycle when tool_result message is sent
  void completeToolCycle(String toolCallId) {
    final cycle = _pendingCycles.remove(toolCallId);
    if (cycle != null) {
      _completedCycles.add(
        ToolCycleInfo(
          id: cycle.id,
          startTime: cycle.startTime,
          status: ToolCycleStatus.completed,
        ),
      );
    }
  }
  
  /// Mark a cycle as interrupted with reason (used during restart scenarios)
  void markCycleInterrupted(String toolCallId, String reason) {
    final cycle = _pendingCycles.remove(toolCallId);
    if (cycle != null) {
      _completedCycles.add(
        ToolCycleInfo(
          id: cycle.id,
          startTime: cycle.startTime,
          status: ToolCycleStatus.interrupted,
          interruptionReason: reason,
        ),
      );
    }
  }
  
  /// Get all currently pending tool cycles
  List<ToolCycleInfo> getPendingCycles() => _pendingCycles.values.toList();
  
  /// Get all completed tool cycles (for diagnostic purposes)
  List<ToolCycleInfo> getCompletedCycles() => _completedCycles;
  
  /// Get list of pending cycle IDs
  List<String> getPendingCycleIds() => _pendingCycles.keys.toList();
  
  /// Check if there are any active tool cycles
  bool hasActiveCycles() => _pendingCycles.isNotEmpty;
  
  /// Send error responses for all pending cycles and clear them
  /// Used during server restart to notify Claude of interrupted cycles
  void sendErrorsForPendingCycles(
    String reason,
    void Function(Map<String, dynamic>) onError,
  ) {
    // Create a copy of pending cycles to avoid concurrent modification
    final pendingCycles = List<ToolCycleInfo>.from(_pendingCycles.values);
    
    for (final cycle in pendingCycles) {
      onError({
        'jsonrpc': '2.0',
        'id': cycle.id,
        'error': {
          'code': -32603,
          'message': 'Tool execution interrupted by $reason',
          'data': {
            'problem': 'Tool cycle interrupted during server restart',
            'guidance': 'Use /resume command to recover Claude session',
            'next_steps': ['resume', 'retry_operation'],
            'proxy_tools': ['proxy_status', 'proxy_check_tool_cycles'],
          },
        },
      });
    }
    
    // Mark all as interrupted and clear pending
    for (final cycle in pendingCycles) {
      markCycleInterrupted(cycle.id, reason);
    }
    _pendingCycles.clear();
  }
  
  /// Get comprehensive diagnostic report about tool cycle state
  ToolCycleReport getReport() {
    final pending = _pendingCycles.values.toList();
    final longestPending = pending.isEmpty 
        ? Duration.zero
        : pending
            .map((c) => DateTime.now().difference(c.startTime))
            .reduce((a, b) => a > b ? a : b);
    
    return ToolCycleReport(
      totalPending: pending.length,
      pendingIds: _pendingCycles.keys.toList(),
      hasApiRisk: pending.isNotEmpty,
      longestPendingDuration: longestPending,
      recoveryGuidance: pending.isNotEmpty
          ? 'Use /resume command to recover Claude session after incomplete tool cycles'
          : 'No pending tool cycles detected',
    );
  }
  
  /// Get cycles that have been pending longer than the specified duration
  List<ToolCycleInfo> getStaleCycles(Duration maxAge) {
    final cutoff = DateTime.now().subtract(maxAge);
    return _pendingCycles.values
        .where((cycle) => cycle.startTime.isBefore(cutoff))
        .toList();
  }
  
  /// Remove stale cycles that have been pending too long
  void cleanupStaleCycles(Duration maxAge) {
    final staleIds = getStaleCycles(maxAge).map((c) => c.id).toList();
    for (final id in staleIds) {
      _pendingCycles.remove(id);
    }
  }
  
  /// Clear all tracked cycles (used for testing or complete reset)
  void clearAllCycles() {
    _pendingCycles.clear();
    _completedCycles.clear();
  }
  
  /// Start periodic cleanup of stale cycles
  void startPeriodicCleanup({Duration interval = const Duration(minutes: 2)}) {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(interval, (_) {
      cleanupStaleCycles(staleThreshold);
    });
  }
  
  /// Stop periodic cleanup
  void stopPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }
  
  /// Dispose of the tracker and clean up resources
  void dispose() {
    stopPeriodicCleanup();
    _pendingCycles.clear();
    _completedCycles.clear();
  }
}

/// Information about a single tool cycle
class ToolCycleInfo {
  const ToolCycleInfo({
    required this.id,
    required this.startTime,
    required this.status,
    this.interruptionReason,
  });
  
  final String id;
  final DateTime startTime;
  final ToolCycleStatus status;
  final String? interruptionReason;
  
  /// Duration since the cycle started
  Duration get age => DateTime.now().difference(startTime);
  
  /// Whether this cycle is stale (older than threshold)
  bool get isStale => age > ToolCycleTracker.staleThreshold;
}

/// Status of a tool cycle
enum ToolCycleStatus {
  /// Cycle started, waiting for tool_result
  pending,
  /// Cycle completed successfully
  completed,
  /// Cycle interrupted by server restart or error
  interrupted,
  /// Cycle is stale and should be cleaned up
  stale,
}

/// Comprehensive report about tool cycle state
class ToolCycleReport {
  const ToolCycleReport({
    required this.totalPending,
    required this.pendingIds,
    required this.hasApiRisk,
    required this.longestPendingDuration,
    required this.recoveryGuidance,
  });
  
  final int totalPending;
  final List<String> pendingIds;
  final bool hasApiRisk;
  final Duration longestPendingDuration;
  final String recoveryGuidance;
  
  /// Whether immediate action is needed
  bool get needsAttention => hasApiRisk || longestPendingDuration > ToolCycleTracker.staleThreshold;
  
  /// Severity level based on pending cycles
  String get severity {
    if (totalPending == 0) return 'info';
    if (totalPending >= 3 || longestPendingDuration > Duration(minutes: 10)) return 'critical';
    if (totalPending >= 2 || longestPendingDuration > Duration(minutes: 5)) return 'warning';
    return 'info';
  }
}