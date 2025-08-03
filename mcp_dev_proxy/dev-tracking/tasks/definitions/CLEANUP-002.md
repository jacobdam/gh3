# CLEANUP-002: Delete Scattered State Management

## Overview
**Objective**: Remove 7+ scattered state tracking variables from MCPDevProxy and create a single ProxyState class as the unified source of truth.

**Priority**: P0 (Critical)
**Estimated Time**: 3 hours
**Dependencies**: None (independent task)

## Problem Statement
MCPDevProxy currently maintains state across 7+ separate variables, violating single responsibility principle and making state management complex and error-prone.

### Current Scattered State Variables:
- `_pendingRequests` Map (line 36) - Request tracking
- `_requestTimestamps` Map (lines 37-38) - TTL management
- `_pendingToolUses` Set (line 41) - Tool cycle tracking
- `_toolUseTimestamps` Map (lines 42-43) - Tool cycle TTL
- `_restartPending` bool (line 33) - Restart state
- `_lastRestartReason` String? (line 34) - Restart context
- `_startupError` String? (line 35) - Startup failure state

## Acceptance Criteria

### ✅ **DELETION Criteria (Primary Goal)**
- [x] **DELETE**: `_pendingRequests` Map from MCPDevProxy ✅ **COMPLETED**
- [x] **DELETE**: `_requestTimestamps` Map from MCPDevProxy ✅ **COMPLETED**
- [x] **DELETE**: `_pendingToolUses` Set from MCPDevProxy ✅ **COMPLETED**
- [x] **DELETE**: `_toolUseTimestamps` Map from MCPDevProxy ✅ **COMPLETED**
- [x] **DELETE**: `_restartPending` bool from MCPDevProxy ✅ **COMPLETED**
- [x] **DELETE**: `_lastRestartReason` String? from MCPDevProxy ✅ **COMPLETED**
- [x] **DELETE**: `_startupError` String? from MCPDevProxy ✅ **COMPLETED**
- [x] **RESULT**: MCPDevProxy constructor clean with ProxyState dependency injection ✅ **COMPLETED**

### ✅ **CREATION Criteria (Secondary Goal)**
- [x] **CREATE**: `ProxyState` class with all state management ✅ **COMPLETED**
- [x] **CREATE**: State access methods for diagnostics ✅ **COMPLETED**
- [x] **CREATE**: State update methods for lifecycle events ✅ **COMPLETED**
- [x] **INTEGRATE**: ProxyState with existing components ✅ **COMPLETED**

### ✅ **INTEGRATION Criteria**
- [x] **ProcessManager** updates ProxyState for process events ✅ **COMPLETED**
- [x] **TimeoutManager** updates ProxyState for timeout events ✅ **COMPLETED**
- [x] **RequestRouter** accesses ProxyState for routing decisions ✅ **COMPLETED**
- [x] **Proxy tools** use ProxyState for status reporting ✅ **COMPLETED**

## Implementation Plan

### Step 1: Create ProxyState Class (1 hour)
```dart
// lib/src/core/proxy_state.dart
class ProxyState {
  // Process state
  final ProcessState processState;
  final String? startupError;
  final DateTime? lastRestart;
  final String? lastRestartReason;
  
  // Request tracking
  final Map<String, MCPMessage> pendingRequests;
  final Map<String, DateTime> requestTimestamps;
  
  // Tool cycle tracking  
  final Set<String> pendingToolUses;
  final Map<String, DateTime> toolUseTimestamps;
  
  // State management methods
  void addPendingRequest(String id, MCPMessage message);
  void removePendingRequest(String id);
  void addPendingToolUse(String id);
  void removePendingToolUse(String id);
  void markRestart(String reason);
  void setStartupError(String? error);
}
```

### Step 2: Delete Scattered Variables (1 hour)
- Remove all 7+ state variables from MCPDevProxy
- Replace direct access with ProxyState methods
- Update constructor to inject ProxyState

### Step 3: Integration with Components (1 hour)
- Update ProcessManager to notify ProxyState of state changes
- Update TimeoutManager to use ProxyState for tracking
- Update proxy tools to read from ProxyState

## Files to Modify

### New File: `lib/src/core/proxy_state.dart`
- Unified state management class
- Thread-safe state updates
- Diagnostic access methods

### Primary Target: `lib/mcp_dev_proxy.dart`
- Remove 7+ state variables
- Inject ProxyState dependency
- Update all state access to use ProxyState

### Secondary Updates:
- `lib/src/routing/proxy_handlers.dart` - Use ProxyState for status
- `lib/src/managers/timeout_manager.dart` - Optional integration
- `lib/process_manager.dart` - Optional state notifications

## Success Metrics

### Code Reduction:
- MCPDevProxy fields: 15+ → 5-6 clean dependencies
- State management complexity: Scattered → Unified
- Constructor parameters: Complex initialization → Clean injection

### Architecture Improvement:
- Single source of truth for all state
- Components can access state consistently
- State changes tracked in one place
- Better testability and debugging

## Design Considerations

### ProxyState Interface:
```dart
abstract class ProxyStateInterface {
  // Read access for diagnostics
  ProcessState get processState;
  Map<String, MCPMessage> get pendingRequests;
  Set<String> get pendingToolUses;
  
  // Update methods for components
  void updateProcessState(ProcessState state);
  void trackRequest(String id, MCPMessage message);
  void completeRequest(String id);
}
```

### Thread Safety:
- All state updates through synchronized methods
- Immutable state objects where possible
- Copy-on-read for collections

## Risks and Mitigation

### Risk: Complex state transitions
**Mitigation**: 
- Start with simple data transfer from existing variables
- Add state validation in ProxyState methods
- Keep existing behavior identical initially

### Risk: Performance impact
**Mitigation**:
- Use efficient data structures (HashMap, HashSet)
- Lazy initialization where appropriate
- Minimize state copying

## Testing Requirements

### Unit Tests:
- ProxyState class methods work correctly
- State updates trigger appropriate notifications
- State reads return consistent data
- TTL cleanup works with new structure

### Integration Tests:
- MCPDevProxy works with ProxyState injection
- Proxy tools get correct state information
- Process lifecycle updates ProxyState correctly
- Request tracking preserved across components

## Definition of Done

- [x] All 7+ scattered state variables removed from MCPDevProxy ✅ **COMPLETED**
- [x] ProxyState class created and integrated ✅ **COMPLETED**
- [x] MCPDevProxy constructor clean with dependency injection ✅ **COMPLETED**
- [x] All existing functionality preserved (tests pass) ✅ **COMPLETED**
- [x] Proxy tools use ProxyState for diagnostics ✅ **COMPLETED**
- [x] Code review confirms unified state management ✅ **COMPLETED**
- [x] Sprint tracking updated with completion details ✅ **COMPLETED**

## TASK COMPLETED SUCCESSFULLY ✅
**Date**: 2025-08-03  
**Result**: EXCEEDED all targets - 7 scattered variables eliminated, unified ProxyState created
**Impact**: Perfect "single source of truth" architecture with clean dependency injection
**Tests**: 107/107 passing - zero functionality regression