# CLEANUP-001: Delete Inline Request Handling from MCPDevProxy

## Overview
**Objective**: Remove 130+ lines of inline request handling logic from MCPDevProxy and route ALL requests through the existing RequestRouter component.

**Priority**: P0 (Critical)
**Estimated Time**: 4 hours
**Dependencies**: TASK-003 ✅ (RequestRouter exists and is functional)

## Problem Statement
Currently MCPDevProxy.handleClientInput() contains 130+ lines of inline request handling logic that duplicates functionality already provided by RequestRouter. This violates SRP and makes the code untestable.

### Current Issues:
- Lines 194-230: Inline `initialize` request handling
- Lines 231-268: Inline `tools/list` handling  
- Lines 269-272: Inline `tools/call` routing
- Lines 273-277: Inline server unavailable logic
- Hardcoded error responses scattered throughout

## Acceptance Criteria

### ✅ **DELETION Criteria (Primary Goal)**
- [ ] **DELETE**: All inline request handling logic from handleClientInput() (lines 194-277)
- [ ] **DELETE**: Hardcoded initialize response building (lines 212-224)
- [ ] **DELETE**: Hardcoded tools/list response building (lines 233-262)
- [ ] **DELETE**: Inline server unavailable checks in handleClientInput()
- [ ] **RESULT**: handleClientInput() reduces from 130 lines to ~20 lines

### ✅ **REPLACEMENT Criteria (Secondary Goal)**
- [ ] **Route initialize requests** through RequestRouter with proper handler
- [ ] **Route tools/list requests** through RequestRouter with proper handler
- [ ] **Route tools/call requests** through RequestRouter (already exists)
- [ ] **Route server unavailable scenarios** through RequestRouter
- [ ] **Preserve all existing functionality** - no behavior changes for users

### ✅ **INTEGRATION Criteria**
- [ ] **RequestRouter handles ALL request types** (initialize, tools/list, tools/call, errors)
- [ ] **MCPDevProxy becomes pure coordinator** - only message parsing and delegation
- [ ] **All error responses** use ResponseEnhancer (no hardcoded strings)
- [ ] **Tool cycle tracking** integrated with RequestRouter

## Implementation Plan

### Step 1: Extend RequestRouter (1 hour)
```dart
// Add to RequestRouter
Future<void> handleInitializeRequest(MCPMessage message);
Future<void> handleToolsListRequest(MCPMessage message);
Future<void> handleServerUnavailable(MCPMessage message);
```

### Step 2: Delete Inline Logic (2 hours)
- Remove lines 194-230 (initialize handling)
- Remove lines 231-268 (tools/list handling)
- Remove lines 273-277 (server unavailable logic)
- Keep only: message parsing + RequestRouter.routeRequest()

### Step 3: Verify Integration (1 hour)
- Test all request types route through RequestRouter
- Verify identical behavior to current implementation
- Ensure tool cycle tracking still works

## Files to Modify

### Primary Target: `lib/mcp_dev_proxy.dart`
- **BEFORE**: 644 lines with 130-line handleClientInput method
- **AFTER**: ~550 lines with ~20-line handleClientInput method

### Secondary: `lib/src/routing/request_router.dart`
- Add handlers for initialize and tools/list requests
- Integrate server unavailable scenarios

## Success Metrics

### Code Reduction:
- MCPDevProxy.handleClientInput(): 130 lines → ~20 lines (85% reduction)
- Total MCPDevProxy class: 644 lines → ~550 lines (15% reduction)
- Zero inline request handling logic remaining

### Functionality Preservation:
- All test cases pass (integration and unit tests)
- Proxy tools still work when target unavailable
- Initialize requests receive proper responses
- Tools/list requests include proxy tools

## Risks and Mitigation

### Risk: Breaking existing functionality
**Mitigation**: 
- Implement RequestRouter handlers before deleting MCPDevProxy logic
- Test each request type individually
- Keep integration tests running throughout

### Risk: RequestRouter becoming too complex
**Mitigation**:
- RequestRouter is designed for this - it's already handling tools/call
- Each request type gets its own handler method
- Use existing proxy handlers from TASK-003

## Testing Requirements

### Unit Tests:
- RequestRouter handles initialize requests correctly
- RequestRouter handles tools/list requests correctly  
- RequestRouter handles server unavailable scenarios
- MCPDevProxy delegates all requests to RequestRouter

### Integration Tests:
- End-to-end request flows still work
- Proxy tools available when target server down
- Tool cycle tracking preserved
- Error responses maintain structure

## Definition of Done

- [ ] handleClientInput() contains only message parsing + RequestRouter.routeRequest() call
- [ ] No inline request handling logic remains in MCPDevProxy
- [ ] All request types route through RequestRouter
- [ ] All existing functionality preserved (tests pass)
- [ ] Code review confirms clean separation of concerns
- [ ] Sprint tracking updated with completion details