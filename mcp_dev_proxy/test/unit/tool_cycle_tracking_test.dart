import "package:mcp_dev_proxy/src/core/tool_cycle_tracker.dart";
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
