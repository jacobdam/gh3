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

    test("enforces memory bounds for completed cycles", () async {
      // Test that completed cycles list is bounded to prevent memory leaks
      
      // Add more cycles than the maximum allowed (100)
      for (int i = 0; i < 150; i++) {
        final toolCallId = "cycle-$i";
        tracker.startToolCycle(toolCallId, DateTime.now());
        tracker.completeToolCycle(toolCallId);
      }
      
      // Verify completed cycles are bounded to maximum
      final completedCycles = tracker.getCompletedCycles();
      expect(completedCycles.length, equals(100));
      
      // Verify LRU behavior - oldest cycles should be evicted
      final cycleIds = completedCycles.map((c) => c.id).toList();
      expect(cycleIds.contains("cycle-0"), isFalse); // Oldest evicted
      expect(cycleIds.contains("cycle-149"), isTrue); // Newest retained
      expect(cycleIds.contains("cycle-50"), isTrue); // Within bounds retained
    });

    test("maintains memory bounds during interrupted cycles", () async {
      // Test memory bounds work for interrupted cycles too
      
      // Add cycles and interrupt them
      for (int i = 0; i < 120; i++) {
        final toolCallId = "interrupted-cycle-$i";
        tracker.startToolCycle(toolCallId, DateTime.now());
        tracker.markCycleInterrupted(toolCallId, "server restart");
      }
      
      // Verify interrupted cycles are also bounded
      final completedCycles = tracker.getCompletedCycles();
      expect(completedCycles.length, equals(100));
      
      // Verify all retained cycles have interrupted status
      for (final cycle in completedCycles) {
        expect(cycle.status, equals(ToolCycleStatus.interrupted));
        expect(cycle.interruptionReason, equals("server restart"));
      }
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
