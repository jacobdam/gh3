# TASK-003: Extract and implement RequestRouter class

## Objective
Extract request routing logic into a dedicated RequestRouter class following Single Responsibility Principle.

## Background
Currently, request routing and handling logic is embedded in the main proxy class. We need to extract this into a dedicated component that handles all routing-related functionality.

## Requirements
1. Create RequestRouter class with:
   - Method-based request routing
   - Request validation and preprocessing
   - Route matching and handler assignment
   - Support for middleware/interceptors
   - Request context management

2. Integrate with existing MCPDevProxy:
   - Replace inline routing logic
   - Maintain backward compatibility
   - Preserve existing functionality

## Technical Specifications
Reference: `docs/technical-design.md` - Section 4: RequestRouter

```dart
class RequestRouter {
  final Map<String, RequestHandler> _routes = {};
  final List<RequestMiddleware> _middleware = [];
  
  void registerRoute(String method, RequestHandler handler);
  void addMiddleware(RequestMiddleware middleware);
  Future<Map<String, dynamic>> routeRequest(
    String method, 
    Map<String, dynamic> params,
    RequestContext context
  );
  bool canHandle(String method);
  List<String> getSupportedMethods();
}

abstract class RequestHandler {
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context
  );
}

abstract class RequestMiddleware {
  Future<void> beforeRequest(RequestContext context);
  Future<void> afterRequest(RequestContext context);
}
```

## Acceptance Criteria
- [ ] RequestRouter class created in `lib/src/routing/request_router.dart`
- [ ] All routing logic extracted from MCPDevProxy
- [ ] Method-based routing working correctly
- [ ] Middleware support for request preprocessing
- [ ] Request validation and error handling
- [ ] Route registration and discovery
- [ ] Comprehensive unit tests with >90% coverage
- [ ] Integration tests pass with new component
- [ ] No breaking changes to existing functionality

## Implementation Steps
1. Create `lib/src/routing/request_router.dart`
2. Define RequestHandler and RequestMiddleware interfaces
3. Write unit tests first (TDD approach)
4. Implement core routing logic
5. Add middleware support
6. Implement request validation
7. Add route registration system
8. Integrate with MCPDevProxy
9. Run integration tests
10. Update documentation

## Testing Checklist
- [ ] Unit tests for all public methods
- [ ] Edge cases: unknown routes, malformed requests
- [ ] Middleware execution order tests
- [ ] Route registration and discovery tests
- [ ] Integration with request flow
- [ ] Performance benchmarks (routing overhead < 1ms)

## Notes
- Consider using pattern matching for complex routes
- Ensure thread-safe route registration
- Handle route conflicts and duplicates
- Support for dynamic route parameters