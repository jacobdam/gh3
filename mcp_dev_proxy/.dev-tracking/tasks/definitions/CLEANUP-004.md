# CLEANUP-004: Delete Redundant Cleanup Logic

## Task Overview
- **ID**: CLEANUP-004
- **Title**: Delete redundant cleanup logic from MCPDevProxy
- **Priority**: P1 (High)
- **Effort**: 2 hours
- **Type**: Deletion/Cleanup
- **Status**: Ready for Development

## Problem Statement
MCPDevProxy contains periodic cleanup logic (_startPeriodicCleanup, _cleanupStaleEntries) that duplicates functionality already provided by ProxyState's built-in TTL cleanup. This violates DRY principles and adds unnecessary complexity with Timer management.

## Current Implementation Issues
1. **Duplicate cleanup logic**: ProxyState already handles TTL-based cleanup internally
2. **Unnecessary Timer management**: Extra Timer instance for redundant functionality
3. **Scattered constants**: _maxRequestAge, _maxToolUseAge defined in MCPDevProxy instead of ProxyState
4. **Extra complexity**: ~50 lines of code that serve no unique purpose

## Deletion Targets

### 1. Constants to Delete (lines ~41-43)
```dart
static const Duration _maxRequestAge = Duration(minutes: 10);
static const Duration _maxToolUseAge = Duration(minutes: 5);
static const Duration _cleanupInterval = Duration(minutes: 1);
```

### 2. Timer Variable to Delete (line ~37)
```dart
Timer? _cleanupTimer; // Timer for periodic cleanup
```

### 3. Methods to Delete
- `_startPeriodicCleanup()` - Called from constructor
- `_stopPeriodicCleanup()` - Called from stop()
- `_cleanupStaleEntries()` - The redundant cleanup logic

### 4. Constructor Call to Remove
- Remove `_startPeriodicCleanup();` from constructor

### 5. Stop Method Call to Remove
- Remove `_stopPeriodicCleanup();` from stop()

## Implementation Steps

### Step 1: Verify ProxyState Cleanup (15 min)
- [ ] Review ProxyState implementation to confirm TTL cleanup is working
- [ ] Check if any unique functionality exists in _cleanupStaleEntries
- [ ] Ensure no other code depends on these methods

### Step 2: Delete Cleanup Code (30 min)
- [ ] Delete the three constant definitions
- [ ] Delete _cleanupTimer variable declaration
- [ ] Delete _startPeriodicCleanup() method
- [ ] Delete _stopPeriodicCleanup() method  
- [ ] Delete _cleanupStaleEntries() method
- [ ] Remove _startPeriodicCleanup() call from constructor
- [ ] Remove _stopPeriodicCleanup() call from stop()

### Step 3: Update Tests (45 min)
- [ ] Remove or update any tests that reference cleanup methods
- [ ] Ensure ProxyState tests cover TTL cleanup scenarios
- [ ] Run full test suite to verify no regressions

### Step 4: Verify Functionality (30 min)
- [ ] Test that requests still timeout properly
- [ ] Verify ProxyState cleanup continues to work
- [ ] Check memory usage doesn't grow over time

## Acceptance Criteria
- [ ] All cleanup-related code removed from MCPDevProxy
- [ ] ProxyState remains the single source of truth for TTL cleanup
- [ ] No Timer instances for cleanup in MCPDevProxy
- [ ] All tests pass (maintaining 100% pass rate)
- [ ] MCPDevProxy reduced by ~50 lines
- [ ] No functional regressions

## Success Metrics
- **Lines Deleted**: ~50 lines
- **Complexity Reduction**: Remove Timer management and duplicate logic
- **Architecture Improvement**: Single responsibility - ProxyState owns all state cleanup

## Testing Strategy
1. Unit tests for ProxyState TTL functionality
2. Integration tests for long-running proxy sessions
3. Manual testing with requests that should expire

## Dependencies
- Depends on: ProxyState implementation (already complete)
- Blocks: Further MCPDevProxy simplification

## Notes
- This is a pure deletion task - no new functionality needed
- ProxyState already handles all cleanup internally
- This continues the "delete-first" architecture improvement pattern