# CLEANUP-003: Delete Hardcoded Error Building

## Overview
**Objective**: Remove hardcoded error building methods from MCPDevProxy and use existing ResponseEnhancer + ErrorContext for all error responses.

**Priority**: P1 (High)
**Estimated Time**: 2 hours
**Dependencies**: TASK-002 ✅ (ResponseEnhancer exists and is functional)

## Problem Statement
MCPDevProxy contains 50+ lines of hardcoded error building logic that creates inconsistent error messages and prevents context-aware guidance for AI agents.

### Current Hardcoded Logic:
- `_buildServerUnavailableDetails()` method (lines 388-437) - 50 lines of hardcoded strings
- Hardcoded error details throughout handleClientInput
- No context awareness or structured guidance
- Inconsistent error format across different scenarios

## Acceptance Criteria

### ✅ **DELETION Criteria (Primary Goal)**
- [ ] **DELETE**: `_buildServerUnavailableDetails()` method entirely (50 lines)
- [ ] **DELETE**: All hardcoded error details in handleClientInput()
- [ ] **DELETE**: Manual error response construction throughout MCPDevProxy
- [ ] **RESULT**: All errors use ResponseEnhancer + ErrorContext consistently

### ✅ **REPLACEMENT Criteria (Secondary Goal)**
- [ ] **USE**: ResponseEnhancer for all error responses
- [ ] **CREATE**: ErrorContext objects with proper state information
- [ ] **INTEGRATE**: Context-aware error guidance based on proxy state
- [ ] **PRESERVE**: All error information currently provided

### ✅ **ENHANCEMENT Criteria**
- [ ] **Structured errors** follow requirements.md format
- [ ] **Context-aware guidance** based on process state, binary status, etc.
- [ ] **Actionable next steps** for AI agents
- [ ] **Consistent format** across all error scenarios

## Implementation Plan

### Step 1: Create ErrorContext Factory (30 minutes)
```dart
// Add to ResponseEnhancer or create separate utility
class ErrorContextFactory {
  static ErrorContext createFromProxyState(ProxyState state, String operation) {
    return ErrorContext(
      processState: state.processState,
      binaryPath: state.binaryPath,
      lastError: state.startupError,
      restartCount: state.restartCount,
      fileExists: File(state.binaryPath).existsSync(),
      operationContext: {'operation': operation},
    );
  }
}
```

### Step 2: Delete Hardcoded Methods (1 hour)
- Remove `_buildServerUnavailableDetails()` method entirely
- Remove hardcoded error building in handleClientInput
- Replace with ResponseEnhancer.enhanceError() calls

### Step 3: Use ResponseEnhancer Everywhere (30 minutes)
- Update all error responses to use ResponseEnhancer
- Create appropriate ErrorContext for each scenario
- Verify enhanced errors maintain all information

## Files to Modify

### Primary Target: `lib/mcp_dev_proxy.dart`
- **DELETE**: `_buildServerUnavailableDetails()` method (lines 388-437)
- **REPLACE**: All hardcoded error construction with ResponseEnhancer calls
- **REDUCE**: Total file size by ~50 lines

### Secondary: `lib/src/enhancers/response_enhancer.dart`
- Potentially add ErrorContext factory methods
- Ensure all error types supported

## Current vs Enhanced Error Comparison

### Before (Hardcoded):
```dart
final details = <String, dynamic>{
  'proxy': 'mcp_dev_proxy',
  'target_binary': targetBinary,
  'message': 'MCP server binary not found',
  'action_needed': 'Compile your MCP server binary and I\'ll handle the rest',
  // ... more hardcoded strings
};
```

### After (Context-Aware):
```dart
final context = ErrorContextFactory.createFromProxyState(proxyState, 'server_unavailable');
final enhancedError = responseEnhancer.enhanceError(
  originalError: MCPError.serverUnavailable(),
  context: context
);
```

## Success Metrics

### Code Reduction:
- Delete `_buildServerUnavailableDetails()` method: -50 lines
- Remove hardcoded error construction: -20 lines  
- Total MCPDevProxy reduction: ~70 lines (11% of current size)

### Error Quality Improvement:
- All errors follow structured format from requirements.md
- Context-aware guidance based on actual proxy state
- Consistent error format across all scenarios
- Actionable next steps for AI agents

## Error Scenarios to Migrate

### 1. Server Unavailable Errors
- Binary missing → ErrorType.binaryMissing with compilation guidance
- Process startup failed → ErrorType.processStartFailed with debug info
- Process not running → ErrorType.processCrashed with restart guidance

### 2. Request Handling Errors  
- Invalid requests → ErrorType.protocolError with format guidance
- Timeout errors → Already using TimeoutManager (no change needed)
- Tool call errors → Already routed through RequestRouter

## Risks and Mitigation

### Risk: Losing error information
**Mitigation**: 
- Verify all hardcoded information is captured in ErrorContext
- Compare before/after error responses in tests
- Ensure proxy tools get same diagnostic info

### Risk: ResponseEnhancer not handling all cases
**Mitigation**:
- Review existing ResponseEnhancer capabilities
- Add any missing error types as needed
- Test all error scenarios individually

## Testing Requirements

### Unit Tests:
- All error scenarios use ResponseEnhancer
- ErrorContext contains appropriate state information
- Enhanced errors follow structured format
- No hardcoded strings remain in error responses

### Integration Tests:
- Server unavailable scenarios produce helpful errors
- Error guidance is actionable for AI agents
- Proxy tools get consistent error information
- Error format matches requirements.md specification

## Error Format Validation

All errors must follow this structure from requirements.md:
```json
{
  "error": {
    "code": -32603,
    "message": "Human-readable summary",
    "data": {
      "problem": "Specific issue description",
      "context": "Current system state",
      "guidance": "Step-by-step recovery instructions",
      "next_steps": ["action1", "action2"],
      "proxy_tools": ["proxy_status", "proxy_help"],
      "timestamp": "2024-01-01T00:00:00Z"
    }
  }
}
```

## Definition of Done

- [ ] `_buildServerUnavailableDetails()` method deleted completely
- [ ] All hardcoded error construction removed from MCPDevProxy
- [ ] All error responses use ResponseEnhancer + ErrorContext
- [ ] Error format follows requirements.md specification
- [ ] All existing error information preserved in enhanced format
- [ ] Tests verify consistent error structure across scenarios
- [ ] Sprint tracking updated with completion details