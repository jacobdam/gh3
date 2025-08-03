# TASK-006: Implement ToolCycleTracker Class

## Task Overview
- **ID**: TASK-006
- **Title**: Implement ToolCycleTracker class for comprehensive tool cycle management
- **Priority**: P1 (High)
- **Effort**: 3 hours
- **Type**: Implementation
- **Status**: Ready for Development

## Problem Statement
Tests exist for ToolCycleTracker functionality but the actual implementation class is missing. The current system has manual tool cycle tracking scattered throughout MCPDevProxy, preventing proper detection of incomplete tool_use → tool_result cycles that can break Claude sessions.

## Current Implementation Issues
1. **Missing implementation**: Tests reference ToolCycleTracker class that doesn't exist
2. **Scattered manual tracking**: Tool cycle logic embedded in MCPDevProxy
3. **No cycle interruption detection**: No recovery guidance for interrupted cycles
4. **No structured reporting**: Can't provide cycle status to diagnostic tools

## Implementation Requirements

### 1. Create ToolCycleTracker Class (lib/src/core/tool_cycle_tracker.dart)
```dart
class ToolCycleTracker {
  final Map<String, ToolCycleInfo> _pendingCycles = {};
  Timer? _cleanupTimer;
  static const Duration staleThreshold = Duration(minutes: 5);
  
  // Core cycle management
  void startToolCycle(String toolCallId, DateTime timestamp);
  void completeToolCycle(String toolCallId);
  void markCycleInterrupted(String toolCallId, String reason);
  
  // Diagnostic reporting
  ToolCycleReport getReport();
  List<String> getPendingCycleIds();
  bool hasActiveCycles();
  
  // Cleanup and recovery
  void sendErrorsForPendingCycles(String reason);
  void clearAllCycles();
  void dispose();
}
```

### 2. Supporting Data Classes
```dart
class ToolCycleInfo {
  final String id;
  final DateTime startTime;
  final ToolCycleStatus status;
  final String? interruptionReason;
  
  ToolCycleInfo({
    required this.id,
    required this.startTime,
    required this.status,
    this.interruptionReason,
  });
}

enum ToolCycleStatus {
  pending,
  completed,
  interrupted,
  stale
}

class ToolCycleReport {
  final int totalPending;
  final List<String> pendingIds;
  final String recoveryGuidance;
  final bool hasApiRisk;
  final Duration longestPendingDuration;
  
  ToolCycleReport({
    required this.totalPending,
    required this.pendingIds,
    required this.recoveryGuidance,
    required this.hasApiRisk,
    required this.longestPendingDuration,
  });
}
```

## Implementation Steps

### Step 1: Create Base Implementation (60 min)
- [ ] Create lib/src/core/tool_cycle_tracker.dart file
- [ ] Implement ToolCycleInfo, ToolCycleStatus, ToolCycleReport classes
- [ ] Implement core ToolCycleTracker class with basic functionality
- [ ] Add startToolCycle() and completeToolCycle() methods
- [ ] Implement _pendingCycles Map management

### Step 2: Add Diagnostic Features (45 min)
- [ ] Implement getReport() method with structured reporting
- [ ] Add getPendingCycleIds() and hasActiveCycles() methods
- [ ] Implement recovery guidance generation based on cycle state
- [ ] Add duration tracking for stale cycle detection

### Step 3: Add Cleanup and Recovery (45 min)
- [ ] Implement markCycleInterrupted() for restart scenarios
- [ ] Add sendErrorsForPendingCycles() for cleanup during restart
- [ ] Implement clearAllCycles() for complete reset
- [ ] Add periodic cleanup timer for stale cycles
- [ ] Implement dispose() method for proper cleanup

### Step 4: Integration Points (30 min)
- [ ] Add ToolCycleTracker to MCPDevProxy constructor
- [ ] Export ToolCycleTracker from main library
- [ ] Ensure tests pass with real implementation
- [ ] Verify integration with ProxyState for status reporting

## Acceptance Criteria
- [x] ToolCycleTracker class fully implemented in lib/src/core/ ✅
- [x] All existing tests pass (test/unit/tool_cycle_tracking_test.dart) ✅
- [x] Proper cycle state management (pending → completed/interrupted) ✅
- [x] Structured reporting for diagnostic tools ✅
- [x] Recovery guidance generation for interrupted cycles ✅
- [x] Memory management with stale cycle cleanup ✅
- [x] Integration ready for RequestRouter and MCPDevProxy ✅

## Success Metrics
- **Test Coverage**: 100% of existing tests passing
- **Memory Safety**: Automatic cleanup of stale cycles after 5 minutes
- **Recovery Guidance**: Actionable recovery instructions for interrupted cycles
- **Integration Ready**: Can be injected into MCPDevProxy and RequestRouter

## Testing Strategy
1. Run existing unit tests to verify implementation correctness
2. Test cycle state transitions (pending → completed/interrupted)
3. Verify cleanup timer functionality for stale cycles
4. Test recovery guidance generation for various scenarios
5. Integration test with MCPDevProxy constructor

## Dependencies
- Depends on: Dart Timer for cleanup scheduling
- Blocks: CLEANUP-004 (tool cycle cleanup in MCPDevProxy)
- Enables: Proper tool cycle tracking in RequestRouter

## Notes
- This implements a component that already has comprehensive tests
- Focus on making tests pass rather than extensive design
- Keep implementation aligned with technical-design.md specifications
- Consider tool cycle interruption during process restarts