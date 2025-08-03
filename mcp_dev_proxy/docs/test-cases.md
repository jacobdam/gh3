# MCP Development Proxy - Test Cases

## Introduction

This document defines comprehensive test cases that verify the MCP Development Proxy meets all requirements for enabling autonomous AI agent development. Tests are organized by functional area and include both unit and integration scenarios.

**Testing Philosophy:** Every test should validate that **AI agents never get blocked** and **always receive actionable guidance** for autonomous problem resolution.

**Priority Classification:** Tests are prioritized (P0-P3) based on critical development scenarios, with examples from various MCP server types including flutter-automation.

## Test Categories

### Unit Tests
Focus on individual component behavior with mocked dependencies

### Integration Tests  
Test complete proxy operation with real processes and file system interactions

### Agent Workflow Tests
End-to-end scenarios simulating actual AI agent development workflows

### Performance Tests
Verify timeout accuracy, latency, and resource usage under various conditions

## Test Cases by Functional Area

### 1. Configurable Timeout Management (R1) - P0 Priority

#### T1.1: Operation-Specific Timeout Enforcement

**Unit Test: List Operation Timeout**
```
Test: tools/list request times out after 10 seconds
Setup: Mock target server that never responds
Execute: Send tools/list request
Verify: 
  - Response received at 10.0s ± 0.1s
  - Error code -32603
  - Message includes "timed out after 10 seconds"
  - Guidance includes appropriate troubleshooting steps
  - Context-aware suggestions based on operation type
```

**Unit Test: Long-Running Operation Timeout**
```
Test: Long-running tools/call request (e.g., build) times out appropriately
Setup: Mock server that hangs on long operation
Execute: Send tools/call request for build-like operation
Verify:
  - Response received at configured timeout (e.g., 300s for builds)
  - Error includes operation-specific guidance
  - Suggests checking for common issues (dependencies, infinite loops)
  - Provides appropriate troubleshooting steps
  - Includes partial results if available
```

**Unit Test: Standard Tool Call Timeout**
```
Test: Standard tools/call request times out after 90 seconds  
Setup: Mock server that hangs on tool execution
Execute: Send tools/call request
Verify:
  - Response received at 90.0s ± 0.1s
  - Error includes tool execution guidance
  - Suggests checking for hanging operations
  - Provides debugging recommendations
  - Adapts message to detected server type
```

**Unit Test: Initialize Timeout**
```
Test: initialize request times out after 15 seconds
Setup: Mock target server that hangs during initialization
Execute: Send initialize request
Verify:
  - Response received at 15.0s ± 0.1s
  - Error includes server startup guidance
  - Suggests compilation and binary checks
  - Includes environment validation steps when detectable
  - Provides proxy diagnostic tools
```

#### T1.2: Late Response Filtering

**Integration Test: Late Response Ignored**
```
Test: Responses arriving after timeout are ignored
Setup: Target server configured to respond after 20 seconds
Execute: Send tools/list request (10s timeout)
Wait: For timeout error at 10s
Simulate: Target response at 20s
Verify:
  - Client receives exactly one response (timeout error)
  - Late response logged but not forwarded
  - No duplicate messages sent
  - Operation state remains consistent
```

#### T1.3: Timeout Error Structure

**Unit Test: Actionable Timeout Guidance**
```
Test: Timeout errors include machine-readable guidance
Execute: Trigger timeout for each method type
Verify: All timeout errors include:
  - Specific timeout duration
  - Method-appropriate guidance
  - Next steps array with concrete actions
  - Available proxy tools list
  - Structured format for parsing
```

### 2. Enhanced Error Messages (R2) - P0 Priority

#### T2.1: Missing Binary Error Enhancement

**Integration Test: Missing Binary Guidance**
```
Test: Clear guidance when target binary missing
Setup: Non-existent target binary path
Execute: Send initialize request
Verify: Error response includes:
  - Exact expected binary path
  - Compilation command appropriate to detected language
  - Environment verification steps
  - proxy_status tool recommendation
  - Structured next_steps array
  - Example: For Dart servers, suggests `dart compile exe`
```

#### T2.2: Process Crash Error Enhancement

**Integration Test: Process Crash Details**
```
Test: Crash errors include detailed context
Setup: Target server that crashes with exit code 42
Execute: Send request to trigger crash
Verify: Error response includes:
  - Exit code (42)
  - Full stderr content
  - Crash recovery guidance
  - Debugging recommendations appropriate to server type
  - Environment validation steps when relevant
  - Process restart instructions
```

#### T2.3: Permission Error Enhancement

**Integration Test: Permission Denied Guidance**
```
Test: Permission errors provide specific solutions
Setup: Non-executable file at target binary path
Execute: Send initialize request
Verify: Error distinguishes permission from missing:
  - "Permission denied" vs "File not found"
  - chmod command with correct path
  - File permission diagnostic steps
  - Alternative troubleshooting options
```

#### T2.4: Contextual Error Enhancement

**Unit Test: State-Based Error Guidance**
```
Test: Error messages adapt to current system state
Test Cases:
  1. Missing binary → compilation guidance
  2. Starting process → startup patience guidance  
  3. Crashed process → debugging guidance
  4. Hung process → restart guidance
Verify: Each state provides appropriate context and actions
```

### 3. Process Management (R3) - P0 Priority

#### T3.1: Process Lifecycle Management

**Integration Test: Complete Process Lifecycle**
```
Test: Start, monitor, crash, and restart cycle
Execute:
  1. Start proxy with valid binary
  2. Verify process starts successfully
  3. Send request to confirm operation
  4. Kill target process externally
  5. Send request to trigger crash detection
  6. Verify automatic restart attempt
Verify:
  - All state transitions logged correctly
  - Crash details captured (exit code, stderr)
  - Restart attempt occurs automatically
  - Process state accurately reflects reality
  - Operation context preserved when possible
```

#### T3.2: Startup Failure Detection

**Integration Test: Startup Error Classification**
```
Test: Different startup failures provide different guidance
Test Cases:
  1. Binary not found → compilation guidance
  2. Binary not executable → permission guidance
  3. Binary crashes on startup → stderr analysis
  4. Binary hangs on startup → timeout guidance
Verify: Each failure type provides specific, actionable guidance
```

#### T3.3: Health Monitoring

**Unit Test: Process Health Checks**
```
Test: Process health status detection
Test Cases:
  1. Running normally → healthy status
  2. Process killed → crashed status detection
  3. Process hung → unresponsive detection
  4. Process consuming high CPU → monitoring alerts
Verify: Health status accurately reflects process condition
```

### 4. Hot Reload and Development Workflow (R4) - P0 Priority

#### T4.1: File Change Detection

**Integration Test: Binary Modification Restart**
```
Test: Binary modification triggers automatic restart
Setup: Proxy with running target server
Execute:
  1. Send request to verify normal operation
  2. Modify target binary file (touch/overwrite)
  3. Wait for restart trigger
  4. Send request to verify restart occurred
Verify:
  - File change detected within 2 seconds
  - Restart triggered automatically
  - Pending requests receive restart errors
  - Next response includes restart notification
  - Server state handled appropriately
```

#### T4.2: Debounced Restart Behavior

**Integration Test: Rapid Change Debouncing**
```
Test: Rapid file changes don't cause excessive restarts
Execute:
  1. Make 5 rapid file modifications within 1 second
  2. Monitor restart triggers over 10 seconds
Verify:
  - Fewer restart triggers than file modifications
  - Debouncing prevents restart storm
  - Final restart uses latest binary version
```

#### T4.3: Missing Binary Monitoring

**Integration Test: Binary Creation Detection**
```
Test: Missing binary creation triggers connection attempt
Setup: Proxy with non-existent target binary
Execute:
  1. Verify proxy reports binary missing
  2. Create binary file at expected path
  3. Wait for detection
Verify:
  - Binary creation detected within 2 seconds
  - Automatic connection attempt
  - Status changes from "missing" to "starting"
```

### 5. Diagnostic Tools (R5) - P1 Priority

#### T5.1: Proxy Status Tool

**Unit Test: Comprehensive Status Reporting**
```
Test: proxy_status provides complete system state
Test Cases:
  1. Missing binary state
  2. Starting process state  
  3. Running normally state
  4. Crashed process state
Execute: Call proxy_status in each state
Verify: Response includes:
  - Binary path and existence status
  - Process state and uptime
  - Runtime environment information when detectable
  - Last error details
  - Restart count
  - Monitoring status
  - Context-appropriate recommended next steps
```

#### T5.2: Proxy Help Tool

**Unit Test: Usage Guidance Generation**
```
Test: proxy_help provides comprehensive guidance
Execute: Call proxy_help tool
Verify: Response includes:
  - Integration instructions
  - Configuration examples
  - Troubleshooting guide
  - Available proxy tools
  - Common error solutions
```

#### T5.3: Tool Cycle Diagnostics

**Integration Test: Tool Cycle Analysis**
```
Test: proxy_check_tool_cycles detects incomplete cycles
Setup: Create scenario with incomplete tool_use cycles
Execute:
  1. Send tools/call request without waiting for result
  2. Trigger server restart
  3. Call proxy_check_tool_cycles
Verify: Report includes:
  - Count of incomplete cycles
  - Specific tool call IDs
  - Timestamps and duration
  - Recovery guidance with /resume command
  - API validation error explanation
```

### 6. Session Recovery and Tool Cycle Management (R6) - P0 Priority

#### T6.1: Tool Use Tracking

**Unit Test: Tool Call Registration**
```
Test: tools/call requests tracked as pending
Execute:
  1. Send tools/call request with specific ID
  2. Call proxy_check_tool_cycles immediately
Verify:
  - Tool call ID appears in pending cycles
  - Timestamp recorded accurately
  - Cycle marked as incomplete
  - Operation context tracked when available
```

#### T6.2: Tool Result Completion

**Integration Test: Cycle Completion Detection**
```
Test: tool_result responses complete cycles
Setup: Working target server
Execute:
  1. Send tools/call request
  2. Wait for tool_result response
  3. Call proxy_check_tool_cycles
Verify:
  - Cycle marked as completed
  - Removed from pending list
  - Clean status reported
```

#### T6.3: Restart Cycle Cleanup

**Integration Test: Interrupted Cycle Handling**
```
Test: Server restart sends errors for incomplete cycles
Execute:
  1. Send tools/call request
  2. Trigger server restart before response
  3. Verify error response sent
Verify:
  - Error response includes "interrupted by restart"
  - Interrupted cycle removed from tracking
  - Recovery guidance provided
```

### 7. Graceful Degradation (R7) - P1 Priority

#### T7.1: Always-Available Proxy

**Integration Test: Proxy Operation Without Target**
```
Test: Proxy remains functional when target completely unavailable
Setup: Missing target binary
Execute:
  1. Send initialize request
  2. Send tools/list request
  3. Call proxy diagnostic tools
Verify:
  - Initialize succeeds with proxy server info
  - tools/list returns proxy tools
  - Diagnostic tools function normally
  - Helpful guidance provided in all responses
  - Environment information included when available
```

#### T7.2: Progressive Enhancement

**Integration Test: Target Availability Transition**
```
Test: Seamless transition between available/unavailable states
Execute:
  1. Start proxy with missing binary (unavailable state)
  2. Create binary and verify transition to available
  3. Remove binary and verify transition back
Verify:
  - Appropriate tools/capabilities exposed in each state
  - Clear indication of current operational mode
  - No errors during state transitions
```

### 8. MCP Protocol Compliance (R8) - P2 Priority

#### T8.1: Transparent Request Forwarding

**Integration Test: Protocol Compliance**
```
Test: Normal requests forwarded without modification
Setup: Working target server
Execute:
  1. Send standard MCP requests (initialize, tools/list, tools/call)
  2. Verify responses match target server exactly
Verify:
  - Request IDs preserved
  - Response format unchanged (except proxy metadata)
  - MCP error codes used correctly
  - JSON-RPC 2.0 compliance maintained
```

#### T8.2: Error Code Compliance

**Unit Test: MCP Error Code Usage**
```
Test: All proxy errors use appropriate MCP error codes
Test Cases:
  - Server unavailable: -32603 (Internal Error)
  - Invalid request: -32600 (Invalid Request)
  - Method not found: -32601 (Method Not Found)
  - Timeout: -32603 (Internal Error)
Verify: Correct error codes used for each scenario
```

## Agent Workflow Integration Tests

### AW1: Complete Development Cycle - P0 Priority

**Integration Test: End-to-End Agent Workflow**
```
Test: AI agent can develop MCP server autonomously
Scenario:
  1. Agent starts with missing binary
  2. Receives compilation guidance
  3. Creates binary and proxy auto-connects
  4. Agent tests functionality
  5. Binary crashes, agent receives error guidance
  6. Agent modifies code, recompiles
  7. Proxy auto-restarts, agent continues development
Verify:
  - No hanging operations throughout cycle
  - Actionable guidance at every failure point
  - Autonomous recovery without human intervention
  - Development context preserved through failures

Example: Flutter-automation MCP development
  - Compilation: `dart compile exe`
  - Long operations: widget tests, builds
  - Environment: Flutter SDK validation
```

### AW2: Session Recovery Workflow - P0 Priority

**Integration Test: Claude Session Recovery**
```
Test: Agent recovers from interrupted tool cycles
Scenario:
  1. Agent starts tool_use cycle
  2. Server crashes before tool_result
  3. Agent receives interruption error
  4. Agent calls proxy_check_tool_cycles
  5. Agent follows recovery guidance (use /resume)
  6. Agent successfully continues development
Verify:
  - Tool cycle interruption detected
  - Clear recovery instructions provided
  - Session continuity restored
  - No API validation errors
  - Operation context preserved when possible
```

### AW3: Autonomous Troubleshooting - P1 Priority

**Integration Test: Independent Problem Resolution**
```
Test: Agent diagnoses and fixes issues without human help
Scenario:
  1. Agent encounters hanging operation
  2. Receives timeout with diagnostic tool suggestions
  3. Agent calls proxy_status to understand problem
  4. Agent follows guidance to resolve issue
  5. Agent resumes normal development
Verify:
  - Agent receives specific, actionable guidance
  - Diagnostic tools provide sufficient information
  - Agent can execute recommended solutions
  - Problem resolution achieved autonomously
  - Environment issues resolved when possible
```

## Performance Tests

### P1: Latency Benchmarks

**Performance Test: Request Forwarding Overhead**
```
Test: Proxy adds minimal latency to normal operations
Execute: 1000 requests through proxy vs direct to server
Measure: Response time difference
Verify: Proxy overhead < 1ms average, < 5ms 95th percentile
```

### P2: Timeout Accuracy

**Performance Test: Timeout Precision**
```
Test: Timeouts accurate under various load conditions
Execute: Timeout scenarios with 1, 10, 100 concurrent requests
Measure: Actual timeout vs expected timeout
Verify: Accuracy within ±100ms for all load levels
```

### P3: Memory Usage

**Performance Test: Resource Consumption**
```
Test: Proxy memory usage remains bounded
Execute: 24-hour test with continuous operation
Monitor: Memory usage, file handles, CPU
Verify: No memory leaks, stable resource usage < 50MB
```

### P4: File Watching Efficiency

**Performance Test: File Change Detection Performance**
```
Test: File watching scales with rapid changes
Execute: Generate file changes at various rates
Measure: Detection latency and CPU usage
Verify: Changes detected within 2s, CPU usage < 5%
```

## Use Case Examples

### Example 1: Flutter-Automation MCP Server
- **Long operations**: Widget tests (2min), builds (5min)
- **Environment**: Flutter SDK, Dart runtime
- **Error patterns**: Flutter doctor diagnostics, SDK version issues
- **Compilation**: `dart compile exe`

### Example 2: Python Analysis MCP Server
- **Long operations**: Code analysis, dependency scanning
- **Environment**: Python interpreter, pip packages
- **Error patterns**: Import errors, version conflicts
- **Compilation**: Not applicable (interpreted)

### Example 3: Simple Node.js Tool Server
- **Quick operations**: File operations, simple queries
- **Environment**: Node.js runtime
- **Error patterns**: Module not found, syntax errors
- **Compilation**: Not applicable (interpreted)

## Test Execution Strategy

### Continuous Integration
- **Unit tests** run on every commit
- **Integration tests** run on pull requests
- **Performance tests** run nightly
- **Agent workflow tests** run weekly

### Test Environment
- **Mock servers** for controlled failure scenarios  
- **Real processes** for integration testing
- **Load generators** for performance testing
- **File system simulators** for edge case testing

### Success Criteria
- **100% unit test coverage** for core components
- **Zero hanging operations** in any test scenario
- **All errors include actionable guidance**
- **Agent workflow tests pass end-to-end**
- **Performance requirements met** under load

### Quality Gates
- **No failing tests** before merge
- **Performance regression detection** 
- **Agent workflow validation** before release
- **Error message quality verification**