# TASK-001: Extract and implement TimeoutManager class

## Objective
Extract timeout management logic into a dedicated TimeoutManager class following Single Responsibility Principle.

## Background
Currently, timeout logic is embedded in the main proxy class. We need to extract this into a dedicated component that handles all timeout-related functionality.

## Requirements
1. Create TimeoutManager class with:
   - Method-specific timeout configuration
   - Configurable timeouts for long-running operations
   - Timeout tracking and cancellation
   - Late response filtering
   - Context-aware timeout error generation

2. Integrate with existing MCPDevProxy:
   - Replace inline timeout logic
   - Maintain backward compatibility
   - Preserve existing functionality

## Technical Specifications
Reference: `docs/technical-design.md` - Section 3: TimeoutManager

```dart
class TimeoutManager {
  static const Map<String, Duration> methodTimeouts = {
    'initialize': Duration(seconds: 15),
    'tools/list': Duration(seconds: 10),
    'resources/list': Duration(seconds: 10),
    'prompts/list': Duration(seconds: 10),
    'tools/call': Duration(seconds: 90),
    '_default': Duration(seconds: 30),
  };
  
  Map<String, Duration> customTimeouts = {};
  
  Duration getTimeout(String method, Map<String, dynamic>? params);
  Timer startTimeout(String requestId, String method, Function onTimeout);
  void cancelTimeout(String requestId);
  Map<String, dynamic> createTimeoutError(
    String requestId,
    String method,
    Duration timeout,
    Map<String, dynamic>? operationContext
  );
}
```

## Acceptance Criteria
- [ ] TimeoutManager class created in `lib/src/managers/timeout_manager.dart`
- [ ] All timeout-related logic extracted from MCPDevProxy
- [ ] Method-specific timeouts working correctly
- [ ] Configurable timeout support for long operations (5+ minutes)
- [ ] Late response filtering prevents duplicate responses
- [ ] Timeout accuracy within ±100ms
- [ ] Comprehensive unit tests with >90% coverage
- [ ] Integration tests pass with new component
- [ ] No breaking changes to existing functionality

## Implementation Steps
1. Create `lib/src/managers/timeout_manager.dart`
2. Write unit tests first (TDD approach)
3. Implement core timeout tracking logic
4. Add method-specific timeout configuration
5. Implement configurable timeout support
6. Add timeout error generation with context
7. Integrate with MCPDevProxy
8. Run integration tests
9. Update documentation

## Testing Checklist
- [ ] Unit tests for all public methods
- [ ] Edge cases: concurrent timeouts, immediate cancellation
- [ ] Timeout accuracy tests with mock timers
- [ ] Integration with request flow
- [ ] Performance benchmarks (overhead < 1ms)

## Notes
- Consider using Timer.periodic for accuracy monitoring
- Handle platform differences in timer precision
- Ensure thread-safe timeout tracking
- Clean up timers on proxy shutdown