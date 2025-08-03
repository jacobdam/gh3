import "package:test/test.dart";

void main() {
  group("Tool Cycle Tracking (T6.1-T6.3)", () {
    late ToolCycleTracker tracker;

    setUp(() {
      tracker = ToolCycleTracker();
    });

    tearDown(() {
      tracker.dispose();
    });

    test("should track tool_use requests (T6.1)", () {
      const toolCallId = "tool-call-123";
      final timestamp = DateTime.now();

      // Start tracking a tool cycle
      tracker.startToolCycle(toolCallId, timestamp);

      // Verify cycle is tracked
      final pendingCycles = tracker.getPendingCycles();
      expect(pendingCycles.length, equals(1));
      expect(pendingCycles.first.id, equals(toolCallId));
      expect(pendingCycles.first.startTime, equals(timestamp));
      expect(pendingCycles.first.status, equals(ToolCycleStatus.pending));
    });

    test("should complete tool cycles when tool_result received (T6.2)", () {
      const toolCallId = "tool-call-456";

      // Start and complete cycle
      tracker.startToolCycle(toolCallId, DateTime.now());
      tracker.completeToolCycle(toolCallId);

      // Verify cycle is completed and removed from pending
      final pendingCycles = tracker.getPendingCycles();
      expect(pendingCycles.length, equals(0));

      final completedCycles = tracker.getCompletedCycles();
      expect(completedCycles.length, equals(1));
      expect(completedCycles.first.id, equals(toolCallId));
      expect(completedCycles.first.status, equals(ToolCycleStatus.completed));
    });

    test("should handle interrupted cycles during restart (T6.3)", () {
      const toolCallId1 = "tool-call-789";
      const toolCallId2 = "tool-call-012";
      final errorResponses = <Map<String, dynamic>>[];

      // Start multiple tool cycles
      tracker.startToolCycle(toolCallId1, DateTime.now());
      tracker.startToolCycle(toolCallId2, DateTime.now());

      // Simulate server restart interruption
      tracker.sendErrorsForPendingCycles(
        "Server restarted during tool execution",
        errorResponses.add,
      );

      // Verify error responses sent for all pending cycles
      expect(errorResponses.length, equals(2));

      for (final response in errorResponses) {
        expect(response["error"], isNotNull);
        expect(response["error"]["message"], contains("interrupted"));
        expect(response["error"]["data"]["problem"], contains("restart"));
        expect(response["error"]["data"]["guidance"], contains("recover"));
        expect(response["error"]["data"]["next_steps"], contains("resume"));
      }

      // Verify all cycles marked as interrupted
      final pendingCycles = tracker.getPendingCycles();
      expect(pendingCycles.length, equals(0));
    });

    test("should generate tool cycle diagnostic report", () {
      const toolCallId1 = "diagnostic-1";
      const toolCallId2 = "diagnostic-2";

      // Create mix of pending and completed cycles
      tracker.startToolCycle(
        toolCallId1,
        DateTime.now().subtract(const Duration(minutes: 5)),
      );
      tracker.startToolCycle(
        toolCallId2,
        DateTime.now().subtract(const Duration(minutes: 2)),
      );
      tracker.completeToolCycle(toolCallId1);

      final report = tracker.getReport();

      expect(report.totalPending, equals(1));
      expect(report.pendingIds, contains(toolCallId2));
      expect(
        report.hasApiRisk,
        isTrue,
        reason: "Pending cycles create API validation risk",
      );
      expect(report.recoveryGuidance, contains("/resume"));
      expect(report.recoveryGuidance, contains("Claude session"));
    });

    test("should detect stale tool cycles", () {
      const staleId = "stale-cycle";
      final staleTime = DateTime.now().subtract(const Duration(minutes: 10));

      tracker.startToolCycle(staleId, staleTime);

      final staleCycles = tracker.getStaleCycles(const Duration(minutes: 5));
      expect(staleCycles.length, equals(1));
      expect(staleCycles.first.id, equals(staleId));

      // Verify stale cycle cleanup
      tracker.cleanupStaleCycles(const Duration(minutes: 5));
      expect(tracker.getPendingCycles().length, equals(0));
    });
  });
}

// Minimal implementation for testing
class ToolCycleTracker {
  final Map<String, ToolCycleInfo> _pendingCycles = {};
  final List<ToolCycleInfo> _completedCycles = [];

  void startToolCycle(String toolCallId, DateTime timestamp) {
    _pendingCycles[toolCallId] = ToolCycleInfo(
      id: toolCallId,
      startTime: timestamp,
      status: ToolCycleStatus.pending,
    );
  }

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

  List<ToolCycleInfo> getPendingCycles() => _pendingCycles.values.toList();
  List<ToolCycleInfo> getCompletedCycles() => _completedCycles;

  void sendErrorsForPendingCycles(
    String reason,
    void Function(Map<String, dynamic>) onError,
  ) {
    for (final cycle in _pendingCycles.values) {
      onError({
        "jsonrpc": "2.0",
        "id": cycle.id,
        "error": {
          "code": -32603,
          "message": "Tool execution interrupted by $reason",
          "data": {
            "problem": "Tool cycle interrupted during server restart",
            "guidance": "Use /resume command to recover Claude session",
            "next_steps": ["resume", "retry_operation"],
            "proxy_tools": ["proxy_status", "proxy_check_tool_cycles"],
          },
        },
      });
    }
    _pendingCycles.clear();
  }

  ToolCycleReport getReport() {
    return ToolCycleReport(
      totalPending: _pendingCycles.length,
      pendingIds: _pendingCycles.keys.toList(),
      hasApiRisk: _pendingCycles.isNotEmpty,
      recoveryGuidance: _pendingCycles.isNotEmpty
          ? "Use /resume command to recover Claude session after incomplete tool cycles"
          : "No pending tool cycles detected",
    );
  }

  List<ToolCycleInfo> getStaleCycles(Duration maxAge) {
    final cutoff = DateTime.now().subtract(maxAge);
    return _pendingCycles.values
        .where((cycle) => cycle.startTime.isBefore(cutoff))
        .toList();
  }

  void cleanupStaleCycles(Duration maxAge) {
    final staleIds = getStaleCycles(maxAge).map((c) => c.id).toList();
    staleIds.forEach(_pendingCycles.remove);
  }

  void dispose() {
    _pendingCycles.clear();
    _completedCycles.clear();
  }
}

class ToolCycleInfo {
  ToolCycleInfo({
    required this.id,
    required this.startTime,
    required this.status,
  });
  final String id;
  final DateTime startTime;
  final ToolCycleStatus status;
}

enum ToolCycleStatus {
  pending,
  completed,
  interrupted,
}

class ToolCycleReport {
  ToolCycleReport({
    required this.totalPending,
    required this.pendingIds,
    required this.hasApiRisk,
    required this.recoveryGuidance,
  });
  final int totalPending;
  final List<String> pendingIds;
  final bool hasApiRisk;
  final String recoveryGuidance;
}
