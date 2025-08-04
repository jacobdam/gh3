import "package:mcp_dev_proxy/src/core/tool_cycle_tracker.dart";
import "package:test/test.dart";

void main() {
  group("Tool Cycle Detection Tests", () {
    late ToolCycleTracker tracker;

    setUp(() {
      tracker = ToolCycleTracker();
    });

    tearDown(() {
      tracker.dispose();
    });

    test("detects incomplete tool_use cycles", () async {
      const toolCallId = "incomplete-cycle-123";
      final timestamp = DateTime.now();

      // Start a cycle but don't complete it
      tracker.startToolCycle(toolCallId, timestamp);

      // Verify cycle is detected as pending
      final pendingCycles = tracker.getPendingCycles();
      expect(pendingCycles.length, equals(1));
      expect(pendingCycles.first.id, equals(toolCallId));
      expect(pendingCycles.first.status, equals(ToolCycleStatus.pending));
      expect(tracker.hasActiveCycles(), isTrue);
    });

    test("reports clean state when no incomplete cycles", () async {
      const toolCallId = "complete-cycle-456";

      // Start and complete a cycle
      tracker.startToolCycle(toolCallId, DateTime.now());
      tracker.completeToolCycle(toolCallId);

      // Verify no pending cycles remain
      final pendingCycles = tracker.getPendingCycles();
      expect(pendingCycles.length, equals(0));
      expect(tracker.hasActiveCycles(), isFalse);

      // Generate report and verify clean state
      final report = tracker.getReport();
      expect(report.totalPending, equals(0));
      expect(report.hasApiRisk, isFalse);
    });

    test("completes tool cycles when target responds", () async {
      const toolCallId = "responding-cycle-789";
      final timestamp = DateTime.now();

      // Start cycle
      tracker.startToolCycle(toolCallId, timestamp);
      expect(tracker.hasActiveCycles(), isTrue);

      // Complete cycle (simulating target response)
      tracker.completeToolCycle(toolCallId);

      // Verify cycle is properly completed
      final pendingCycles = tracker.getPendingCycles();
      expect(pendingCycles.length, equals(0));

      final completedCycles = tracker.getCompletedCycles();
      expect(completedCycles.length, equals(1));
      expect(completedCycles.first.id, equals(toolCallId));
      expect(completedCycles.first.status, equals(ToolCycleStatus.completed));
    });
  });
}
