import "dart:async";
import "dart:io";
import "package:test/test.dart";

import "../../lib/src/enhancers/error_context.dart";
import "../../lib/src/enhancers/enhanced_error_context.dart";

void main() {
  group("ErrorSeverity", () {
    test("should have all required severity levels", () {
      expect(ErrorSeverity.values.length, 4);
      expect(ErrorSeverity.values, contains(ErrorSeverity.critical));
      expect(ErrorSeverity.values, contains(ErrorSeverity.error));
      expect(ErrorSeverity.values, contains(ErrorSeverity.warning));
      expect(ErrorSeverity.values, contains(ErrorSeverity.info));
    });
  });

  group("ErrorCategory", () {
    test("should have all required categories", () {
      expect(ErrorCategory.values.length, 6);
      expect(ErrorCategory.values, contains(ErrorCategory.network));
      expect(ErrorCategory.values, contains(ErrorCategory.protocol));
      expect(ErrorCategory.values, contains(ErrorCategory.application));
      expect(ErrorCategory.values, contains(ErrorCategory.system));
      expect(ErrorCategory.values, contains(ErrorCategory.user));
      expect(ErrorCategory.values, contains(ErrorCategory.unknown));
    });
  });

  group("EnhancedErrorContext", () {
    test("should extend ErrorContext", () {
      final context = EnhancedErrorContext(
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
        operation: "test_operation",
        errorMessage: "Test error",
      );

      expect(context, isA<ErrorContext>());
    });

    test("should have required enhanced properties", () {
      final context = EnhancedErrorContext(
        severity: ErrorSeverity.warning,
        category: ErrorCategory.protocol,
        operation: "parse_response",
        errorMessage: "Invalid JSON",
        correlationId: "req_123",
        debugInfo: {"raw_length": 100},
        recoverySuggestions: ["Check JSON format"],
        stackTrace: "Stack trace here",
      );

      expect(context.severity, ErrorSeverity.warning);
      expect(context.category, ErrorCategory.protocol);
      expect(context.operation, "parse_response");
      expect(context.errorMessage, "Invalid JSON");
      expect(context.correlationId, "req_123");
      expect(context.debugInfo, {"raw_length": 100});
      expect(context.recoverySuggestions, ["Check JSON format"]);
      expect(context.stackTrace, "Stack trace here");
      expect(context.timestamp, isA<DateTime>());
    });

    test("should have default values for optional properties", () {
      final context = EnhancedErrorContext(
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
        operation: "connect",
        errorMessage: "Connection failed",
      );

      expect(context.correlationId, isNull);
      expect(context.debugInfo, isEmpty);
      expect(context.recoverySuggestions, isEmpty);
      expect(context.stackTrace, isNull);
    });

    test("classify should create EnhancedErrorContext from error", () {
      final socketError = const SocketException("Connection refused");
      final context = EnhancedErrorContext.classify(
        socketError,
        "server_connect",
        {"server": "localhost:8080"},
      );

      expect(context.category, ErrorCategory.network);
      expect(context.severity, ErrorSeverity.error);
      expect(context.operation, "server_connect");
      expect(context.debugInfo["server"], "localhost:8080");
      expect(context.recoverySuggestions, isNotEmpty);
    });

    test("toStructuredLog should return proper format", () {
      final context = EnhancedErrorContext(
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
        operation: "connect",
        errorMessage: "Connection refused",
        correlationId: "req_123",
        debugInfo: {"server": "localhost:8080"},
        recoverySuggestions: ["Check server status"],
      );

      final log = context.toStructuredLog();

      expect(log["severity"], "error");
      expect(log["category"], "network");
      expect(log["operation"], "connect");
      expect(log["error_message"], "Connection refused");
      expect(log["correlation_id"], "req_123");
      expect(log["debug_info"], {"server": "localhost:8080"});
      expect(log["recovery_suggestions"], ["Check server status"]);
      expect(log["timestamp"], isA<String>());
      expect(log["is_retryable"], isA<bool>());
    });

    test("isRetryable should return correct values", () {
      final networkError = EnhancedErrorContext(
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
        operation: "connect",
        errorMessage: "Timeout",
      );

      final userError = EnhancedErrorContext(
        severity: ErrorSeverity.error,
        category: ErrorCategory.user,
        operation: "validate",
        errorMessage: "Invalid parameter",
      );

      expect(networkError.isRetryable(), isTrue);
      expect(userError.isRetryable(), isFalse);
    });

    test("getRecommendedRetryDelay should return appropriate delays", () {
      final networkError = EnhancedErrorContext(
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
        operation: "connect",
        errorMessage: "Timeout",
      );

      final userError = EnhancedErrorContext(
        severity: ErrorSeverity.error,
        category: ErrorCategory.user,
        operation: "validate",
        errorMessage: "Invalid parameter",
      );

      expect(networkError.getRecommendedRetryDelay(), isA<Duration>());
      expect(userError.getRecommendedRetryDelay(), isNull);
    });
  });

  group("ErrorClassifier", () {
    test("categorizeError should classify network errors", () {
      expect(
        ErrorClassifier.categorizeError(const SocketException("Connection refused")),
        ErrorCategory.network,
      );
      expect(
        ErrorClassifier.categorizeError(TimeoutException("Timeout", const Duration(seconds: 30))),
        ErrorCategory.network,
      );
      expect(
        ErrorClassifier.categorizeError(const HttpException("HTTP error")),
        ErrorCategory.network,
      );
    });

    test("categorizeError should classify protocol errors", () {
      expect(
        ErrorClassifier.categorizeError(const FormatException("Invalid JSON")),
        ErrorCategory.protocol,
      );
    });

    test("categorizeError should classify system errors", () {
      expect(
        ErrorClassifier.categorizeError(const FileSystemException("File not found")),
        ErrorCategory.system,
      );
      expect(
        ErrorClassifier.categorizeError(const ProcessException("ls", [])),
        ErrorCategory.system,
      );
    });

    test("categorizeError should return unknown for unrecognized errors", () {
      expect(
        ErrorClassifier.categorizeError(Exception("Unknown error")),
        ErrorCategory.unknown,
      );
    });

    test("determineSeverity should assign appropriate severity", () {
      expect(
        ErrorClassifier.determineSeverity(ErrorCategory.network, const SocketException("Connection refused")),
        ErrorSeverity.error,
      );
      expect(
        ErrorClassifier.determineSeverity(ErrorCategory.system, const ProcessException("ls", [])),
        ErrorSeverity.critical,
      );
      expect(
        ErrorClassifier.determineSeverity(ErrorCategory.user, Exception("Invalid input")),
        ErrorSeverity.error,
      );
    });

    test("generateRecoverySuggestions should provide helpful suggestions", () {
      final networkSuggestions = ErrorClassifier.generateRecoverySuggestions(
        ErrorCategory.network,
        const SocketException("Connection refused"),
      );
      expect(networkSuggestions, isNotEmpty);
      expect(networkSuggestions, contains(matches(RegExp(r"server|connection|network", caseSensitive: false))));

      final protocolSuggestions = ErrorClassifier.generateRecoverySuggestions(
        ErrorCategory.protocol,
        const FormatException("Invalid JSON"),
      );
      expect(protocolSuggestions, isNotEmpty);
      expect(protocolSuggestions, contains(matches(RegExp(r"json|format", caseSensitive: false))));
    });
  });

  group("Error Classification Integration", () {
    test("should handle nested exceptions", () {
      final nestedError = Exception("Wrapped: ${const SocketException('Connection refused')}");
      final context = EnhancedErrorContext.classify(nestedError, "connect", {});

      // Should still be able to classify based on nested error information
      expect(context.category, isIn([ErrorCategory.network, ErrorCategory.unknown]));
    });

    test("should handle null errors gracefully", () {
      final context = EnhancedErrorContext.classify(null, "unknown_operation", {});

      expect(context.category, ErrorCategory.unknown);
      expect(context.severity, ErrorSeverity.error);
      expect(context.operation, "unknown_operation");
    });

    test("classification should be consistent", () {
      final error = const SocketException("Connection refused");
      final context1 = EnhancedErrorContext.classify(error, "connect", {});
      final context2 = EnhancedErrorContext.classify(error, "connect", {});

      expect(context1.category, context2.category);
      expect(context1.severity, context2.severity);
    });
  });
}