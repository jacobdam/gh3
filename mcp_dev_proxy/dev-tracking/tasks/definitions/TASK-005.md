# TASK-005: Create ErrorContext and classification system

## Objective
Enhance the existing ResponseEnhancer with comprehensive error classification system and structured ErrorContext for better debugging and monitoring.

## Background
Building on TASK-002 (ResponseEnhancer), we need to expand error handling capabilities with structured error classification, contextual information, and enhanced debugging support.

## Requirements
1. Enhance ErrorContext class with:
   - Error severity levels
   - Error category classification
   - Stacktrace and debugging information
   - Context correlation for multi-step operations
   - Error recovery suggestions

2. Error classification system:
   - Network errors (connectivity, timeouts)
   - Protocol errors (JSON-RPC malformed, version mismatch)
   - Application errors (method not found, validation)
   - System errors (resource exhaustion, permissions)
   - User errors (invalid parameters, authentication)

## Technical Specifications
Reference: `docs/technical-design.md` - Section 5: Error Classification

```dart
enum ErrorSeverity {
  critical,   // System cannot continue
  error,      // Operation failed but system stable
  warning,    // Potential issue detected
  info        // Informational error context
}

enum ErrorCategory {
  network,     // Connection, timeout, DNS issues
  protocol,    // JSON-RPC, formatting, version issues
  application, // Business logic, method not found
  system,      // Resource, permission, OS issues
  user,        // Invalid input, authentication
  unknown      // Unclassified errors
}

class EnhancedErrorContext extends ErrorContext {
  final ErrorSeverity severity;
  final ErrorCategory category;
  final String? correlationId;
  final Map<String, dynamic> debugInfo;
  final List<String> recoverySuggestions;
  final DateTime timestamp;
  final String? stackTrace;
  
  static EnhancedErrorContext classify(
    dynamic error,
    String operation,
    Map<String, dynamic>? context
  );
  
  Map<String, dynamic> toStructuredLog();
  bool isRetryable();
  Duration? getRecommendedRetryDelay();
}

class ErrorClassifier {
  static ErrorCategory categorizeError(dynamic error);
  static ErrorSeverity determineSeverity(ErrorCategory category, dynamic error);
  static List<String> generateRecoverySuggestions(
    ErrorCategory category,
    dynamic error
  );
}
```

## Error Classification Rules
```dart
// Network Errors
- SocketException -> network/error
- TimeoutException -> network/warning (if < 3 retries)
- HttpException -> network/error

// Protocol Errors  
- FormatException (JSON) -> protocol/error
- Invalid JSON-RPC -> protocol/error
- Version mismatch -> protocol/warning

// Application Errors
- Method not found -> application/error
- Invalid parameters -> user/error
- Business logic errors -> application/error

// System Errors
- FileSystemException -> system/error
- ProcessException -> system/critical
- OutOfMemoryError -> system/critical
```

## Acceptance Criteria
- [ ] EnhancedErrorContext extends existing ErrorContext
- [ ] Error classification system with 5 categories
- [ ] Severity levels with appropriate defaults
- [ ] Automatic error categorization based on error type
- [ ] Recovery suggestion generation
- [ ] Correlation ID support for operation tracking
- [ ] Structured logging output format
- [ ] Retry recommendation system
- [ ] Integration with existing ResponseEnhancer
- [ ] Comprehensive unit tests with >90% coverage
- [ ] Integration tests covering all error categories
- [ ] No breaking changes to existing functionality

## Implementation Steps
1. Extend ErrorContext to EnhancedErrorContext
2. Write unit tests for error classification (TDD approach)
3. Implement ErrorClassifier with categorization rules
4. Add severity determination logic
5. Implement recovery suggestion generation
6. Add correlation ID and tracking support
7. Implement structured logging format
8. Add retry recommendation system
9. Integrate with ResponseEnhancer
10. Run integration tests with various error scenarios
11. Update documentation and examples

## Testing Checklist
- [ ] Unit tests for all error categories
- [ ] Edge cases: unknown errors, nested exceptions, null errors
- [ ] Classification accuracy tests
- [ ] Severity assignment tests
- [ ] Recovery suggestion generation tests
- [ ] Correlation ID tracking tests
- [ ] Structured logging format tests
- [ ] Integration with ResponseEnhancer
- [ ] Performance impact tests (classification overhead < 1ms)

## Error Examples and Classifications
```dart
// Network Error Example
try {
  await socket.connect();
} catch (e) {
  var context = EnhancedErrorContext.classify(e, "server_connect", {
    "server": "localhost:8080",
    "attempt": 2
  });
  // Result: network/error with retry suggestions
}

// Protocol Error Example  
try {
  var response = jsonDecode(rawResponse);
} catch (e) {
  var context = EnhancedErrorContext.classify(e, "parse_response", {
    "raw_length": rawResponse.length
  });
  // Result: protocol/error with formatting suggestions
}
```

## Structured Log Format
```json
{
  "timestamp": "2025-08-03T10:30:00Z",
  "severity": "error",
  "category": "network", 
  "operation": "server_connect",
  "correlation_id": "req_123",
  "error_message": "Connection refused",
  "debug_info": {
    "server": "localhost:8080",
    "attempt": 2,
    "timeout": "30s"
  },
  "recovery_suggestions": [
    "Check if server is running",
    "Verify network connectivity",
    "Try increasing timeout"
  ],
  "is_retryable": true,
  "retry_delay": "5s"
}
```

## Notes
- Ensure classification rules are easily extensible
- Handle nested and wrapped exceptions properly
- Consider machine learning for error pattern detection
- Support custom error categories for specific domains
- Maintain performance with efficient classification algorithms