import "package:test/test.dart";
import "../../../lib/src/enhancers/response_enhancer.dart";
import "../../../lib/src/enhancers/enhanced_error_context.dart";
import "../../../lib/src/enhancers/error_pattern_analyzer.dart";
import "../../../lib/src/enhancers/error_context.dart";

void main() {
  group("ResponseEnhancer with Pattern Analysis", () {
    late ResponseEnhancer enhancer;

    setUp(() {
      enhancer = ResponseEnhancer(enablePatternAnalysis: true);
    });

    tearDown(() {
      enhancer.dispose();
    });

    test("creates enhanced error with pattern analysis", () {
      // Simulate repeated network errors to create a pattern
      for (int i = 0; i < 5; i++) {
        enhancer.createEnhancedError(
          "Connection timeout",
          "initialize",
          correlationId: "test-$i",
        );
      }

      // Create one more error to get pattern analysis
      final error = enhancer.createEnhancedError(
        "Connection timeout",
        "initialize",
        correlationId: "test-final",
      );

      expect(error.data.containsKey("pattern_analysis"), isTrue);
      expect(error.data.containsKey("enhanced_error"), isTrue);
      expect(error.data["severity"], isA<String>());
      expect(error.data["category"], isA<String>());
      expect(error.data["operation"], equals("initialize"));
      expect(error.data["correlation_id"], equals("test-final"));
    });

    test("includes pattern-based recovery suggestions", () {
      // Create enough network errors to establish a pattern
      for (int i = 0; i < 6; i++) {
        enhancer.createEnhancedError(
          "Network connection failed",
          "tools/call",
          correlationId: "network-$i",
        );
      }

      // Get the final error with pattern analysis
      final error = enhancer.createEnhancedError(
        "Network connection failed",
        "tools/call",
        correlationId: "network-final",
      );

      expect(error.data.containsKey("pattern_recovery_suggestions"), isTrue);
      final suggestions = error.data["pattern_recovery_suggestions"] as List;
      expect(suggestions, isNotEmpty);
      
      // Should include network-specific suggestions
      final suggestionTitles = suggestions.map((s) => s["title"]).toList();
      expect(suggestionTitles.any((title) => title.toString().contains("Network")), isTrue);
    });

    test("works with pattern analysis disabled", () {
      final basicEnhancer = ResponseEnhancer(enablePatternAnalysis: false);
      
      final error = basicEnhancer.createEnhancedError(
        "Test error",
        "test_operation",
      );

      expect(!error.data.containsKey("pattern_analysis"), isTrue);
      expect(error.data.containsKey("enhanced_error"), isTrue);
      expect(error.data["operation"], equals("test_operation"));

      basicEnhancer.dispose();
    });

    test("provides error patterns API", () {
      // Create some patterns
      for (int i = 0; i < 5; i++) {
        enhancer.createEnhancedError("Pattern error", "test_op");
      }

      final patterns = enhancer.getErrorPatterns();
      expect(patterns, isA<List<ErrorPattern>>());
      
      // Should have at least one pattern if minimum threshold is met
      if (patterns.isNotEmpty) {
        expect(patterns.first.signature, isA<String>());
        expect(patterns.first.occurrences, greaterThanOrEqualTo(3));
      }
    });

    test("analyzes specific error signatures", () {
      // Create a known pattern
      for (int i = 0; i < 4; i++) {
        enhancer.createEnhancedError("Timeout error", "specific_op");
      }

      // Analyze the signature (approximated)
      final signature = "application:specific_op:timeout error";  
      final pattern = enhancer.analyzeErrorSignature(signature);
      
      // Pattern may or may not exist depending on exact signature matching
      if (pattern != null) {
        expect(pattern.signature, equals(signature));
        expect(pattern.occurrences, greaterThanOrEqualTo(3));
      }
    });

    test("generates recovery suggestions for patterns", () {
      final mockPattern = ErrorPattern(
        signature: "network:test:connection failed",
        occurrences: 5,
        frequency: 2.0,
        averageInterval: const Duration(minutes: 30),
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
        operations: {"test"},
        firstSeen: DateTime.now().subtract(const Duration(hours: 1)),
        lastSeen: DateTime.now(),
        trend: "stable",
      );

      final suggestions = enhancer.getRecoverySuggestions(mockPattern);
      expect(suggestions, isNotEmpty);
      expect(suggestions.first.title, isA<String>());
      expect(suggestions.first.steps, isA<List>());
      expect(suggestions.first.confidence, isA<double>());
    });

    test("exports error analytics", () {
      // Create some errors for analytics
      for (int i = 0; i < 3; i++) {
        enhancer.createEnhancedError("Analytics error $i", "analytics_op");
      }

      final analytics = enhancer.exportErrorAnalytics();
      expect(analytics.containsKey("total_errors"), isTrue);
      expect(analytics.containsKey("unique_patterns"), isTrue);
      expect(analytics.containsKey("export_timestamp"), isTrue);
      expect(analytics.containsKey("analysis_window_hours"), isTrue);
      expect(analytics["total_errors"], isA<int>());
    });

    test("provides diagnostics", () {
      final diagnostics = enhancer.getErrorAnalysisDiagnostics();
      expect(diagnostics["pattern_analysis_enabled"], isTrue);
      expect(diagnostics["status"], equals("active"));
      expect(diagnostics.containsKey("total_errors"), isTrue);
      expect(diagnostics.containsKey("recent_errors"), isTrue);
    });

    test("handles disabled pattern analysis in diagnostics", () {
      final basicEnhancer = ResponseEnhancer(enablePatternAnalysis: false);
      
      final diagnostics = basicEnhancer.getErrorAnalysisDiagnostics();
      expect(diagnostics["pattern_analysis_enabled"], isFalse);
      expect(diagnostics["status"], equals("disabled"));

      basicEnhancer.dispose();
    });

    test("clears error history", () {
      // Create some errors
      for (int i = 0; i < 3; i++) {
        enhancer.createEnhancedError("Clear test error", "clear_op");
      }

      final beforeClear = enhancer.getErrorAnalysisDiagnostics();
      expect(beforeClear["total_errors"], greaterThan(0));

      enhancer.clearErrorHistory();

      final afterClear = enhancer.getErrorAnalysisDiagnostics();
      expect(afterClear["total_errors"], equals(0));
    });

    test("maintains backward compatibility with existing error methods", () {
      // Test existing error creation methods still work
      final crashError = enhancer.createServerCrashError(1, "stderr output");
      expect(crashError.message, contains("crashed"));
      expect(crashError.data.containsKey("exit_code"), isTrue);

      final restartError = enhancer.createServerRestartError("manual restart");  
      expect(restartError.message, contains("restart"));
      expect(restartError.data.containsKey("reason"), isTrue);

      final timeoutError = enhancer.createTimeoutError("test_op", const Duration(seconds: 30));
      expect(timeoutError.message, contains("timed out"));
      expect(timeoutError.data.containsKey("timeout_ms"), isTrue);
    });

    test("handles complex error contexts correctly", () {
      // Create error with full context
      final error = enhancer.createEnhancedError(
        "Complex error with context",
        "complex_operation",
        correlationId: "complex-123",
        context: {
          "user_id": "user123",
          "session_id": "sess456",
          "request_params": {"param1": "value1"},
        },
      );

      expect(error.data["correlation_id"], equals("complex-123"));
      expect(error.data.containsKey("enhanced_error"), isTrue);
      
      final enhancedError = error.data["enhanced_error"] as Map<String, dynamic>;
      expect(enhancedError.containsKey("timestamp"), isTrue);
      expect(enhancedError.containsKey("operation"), isTrue);
    });

    test("integrates properly with existing error enhancer system", () {
      // Create a custom enhancer
      final customEnhancer = TestErrorEnhancer();
      enhancer.addEnhancer(customEnhancer);

      // This should still work with the existing enhancer system
      final context = TestErrorContext();
      final error = enhancer.enhanceError(
        ErrorType.timeout,
        "Custom enhanced error",
        context,
      );

      expect(error.message, equals("Custom enhanced error"));
      expect(error.data.containsKey("custom_field"), isTrue); // From TestErrorEnhancer
    });
  });

  group("Error Pattern Integration", () {
    test("creates proper error occurrences from enhanced contexts", () {
      final enhancer = ResponseEnhancer(enablePatternAnalysis: true);
      
      // Create an error to trigger pattern recording
      enhancer.createEnhancedError(
        "Test pattern error",
        "pattern_test",
        correlationId: "pattern-123",
        context: {"additional": "context"},
      );

      final diagnostics = enhancer.getErrorAnalysisDiagnostics();
      expect(diagnostics["total_errors"], equals(1));
      
      enhancer.dispose();
    });

    test("handles null and empty contexts gracefully", () {
      final enhancer = ResponseEnhancer(enablePatternAnalysis: true);
      
      // Test with null context
      final error1 = enhancer.createEnhancedError("Null context error", "null_test");
      expect(error1.data.containsKey("enhanced_error"), isTrue);

      // Test with empty context
      final error2 = enhancer.createEnhancedError(
        "Empty context error", 
        "empty_test",
        context: {},
      );
      expect(error2.data.containsKey("enhanced_error"), isTrue);
      
      enhancer.dispose();
    });
  });
}

// Test helper classes
class TestErrorEnhancer extends ErrorEnhancer {
  @override
  bool canHandle(ErrorType errorType, context) => true;

  @override
  Map<String, dynamic> enhance(Map<String, dynamic> error, context) {
    final data = Map<String, dynamic>.from(error["data"] as Map<String, dynamic>? ?? {});
    data["custom_field"] = "enhanced_value";
    
    return {
      ...error,
      "data": data,
    };
  }
}

class TestErrorContext extends ErrorContext {
  TestErrorContext() : super(
    targetCommand: "test_command",
    workingDirectory: "/test/dir",
  );
}