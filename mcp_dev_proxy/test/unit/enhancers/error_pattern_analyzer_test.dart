import "package:test/test.dart";
import "../../../lib/src/enhancers/error_pattern_analyzer.dart";
import "../../../lib/src/enhancers/enhanced_error_context.dart";

void main() {
  group("ErrorOccurrence", () {
    test("generates consistent signatures for similar errors", () {
      final error1 = ErrorOccurrence(
        timestamp: DateTime.now(),
        errorType: "timeout",
        message: "Operation timed out after 30000ms",
        operation: "tools/call",
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
      );

      final error2 = ErrorOccurrence(
        timestamp: DateTime.now(),
        errorType: "timeout", 
        message: "Operation timed out after 45000ms",
        operation: "tools/call",
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
      );

      expect(error1.signature, equals(error2.signature));
      // Both should have the same normalized signature  
      expect(error1.signature, contains("timeout:tools/call:operation timed out after <num>ms"));
    });

    test("normalizes error messages for pattern matching", () {
      final error = ErrorOccurrence(
        timestamp: DateTime.now(),
        errorType: "file_error",
        message: "Cannot read file /path/to/file.txt with ID abc123def456",
        operation: "file/read",
        severity: ErrorSeverity.error,
        category: ErrorCategory.system,
      );

      expect(error.signature, equals("file_error:file/read:cannot read file <path> with id <id>"));
    });

    test("converts to JSON correctly", () {
      final error = ErrorOccurrence(
        timestamp: DateTime(2025, 1, 1, 12, 0, 0),
        errorType: "network",
        message: "Connection failed",
        operation: "initialize",
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
        correlationId: "test-123",
        additionalContext: {"retry_count": 2},
      );

      final json = error.toJson();
      expect(json["timestamp"], equals("2025-01-01T12:00:00.000"));
      expect(json["error_type"], equals("network"));
      expect(json["message"], equals("Connection failed"));
      expect(json["operation"], equals("initialize"));
      expect(json["severity"], equals("error"));
      expect(json["category"], equals("network"));
      expect(json["correlation_id"], equals("test-123"));
      expect(json["additional_context"], equals({"retry_count": 2}));
      expect(json["signature"], equals("network:initialize:connection failed"));
    });
  });

  group("ErrorPattern", () {
    test("calculates priority correctly", () {
      // Critical severity = critical priority
      final criticalPattern = ErrorPattern(
        signature: "test",
        occurrences: 1,
        frequency: 1.0,
        averageInterval: const Duration(minutes: 30),
        severity: ErrorSeverity.critical,
        category: ErrorCategory.system,
        operations: {"test"},
        firstSeen: DateTime.now(),
        lastSeen: DateTime.now(),
        trend: "stable",
      );
      expect(criticalPattern.priority, equals("critical"));

      // High frequency + increasing trend = high priority
      final highPattern = ErrorPattern(
        signature: "test",
        occurrences: 20,
        frequency: 15.0,
        averageInterval: const Duration(minutes: 5),
        severity: ErrorSeverity.error,
        category: ErrorCategory.network,
        operations: {"test"},
        firstSeen: DateTime.now(),
        lastSeen: DateTime.now(),
        trend: "increasing",
      );
      expect(highPattern.priority, equals("high"));

      // Moderate frequency = medium priority
      final mediumPattern = ErrorPattern(
        signature: "test",
        occurrences: 10,
        frequency: 8.0,
        averageInterval: const Duration(minutes: 15),
        severity: ErrorSeverity.error,
        category: ErrorCategory.application,
        operations: {"test"},
        firstSeen: DateTime.now(),
        lastSeen: DateTime.now(),
        trend: "stable",
      );
      expect(mediumPattern.priority, equals("medium"));

      // Low frequency = low priority
      final lowPattern = ErrorPattern(
        signature: "test",
        occurrences: 3,
        frequency: 2.0,
        averageInterval: const Duration(hours: 1),
        severity: ErrorSeverity.warning,
        category: ErrorCategory.user,
        operations: {"test"},
        firstSeen: DateTime.now(),
        lastSeen: DateTime.now(),
        trend: "decreasing",
      );
      expect(lowPattern.priority, equals("low"));
    });

    test("identifies systemic issues correctly", () {
      // Systemic: many occurrences with short intervals
      final systemicPattern = ErrorPattern(
        signature: "test",
        occurrences: 10,
        frequency: 20.0,
        averageInterval: const Duration(minutes: 30),
        severity: ErrorSeverity.error,
        category: ErrorCategory.system,
        operations: {"test"},
        firstSeen: DateTime.now(),
        lastSeen: DateTime.now(),
        trend: "increasing",
      );
      expect(systemicPattern.isSystemic, isTrue);

      // Not systemic: few occurrences or long intervals
      final nonSystemicPattern = ErrorPattern(
        signature: "test",
        occurrences: 3,
        frequency: 1.0,
        averageInterval: const Duration(hours: 2),
        severity: ErrorSeverity.warning,
        category: ErrorCategory.user,
        operations: {"test"},
        firstSeen: DateTime.now(),
        lastSeen: DateTime.now(),
        trend: "stable",
      );
      expect(nonSystemicPattern.isSystemic, isFalse);
    });
  });

  group("RecoverySuggestion", () {
    test("converts to JSON correctly", () {
      const suggestion = RecoverySuggestion(
        title: "Test Recovery",
        description: "Test description",
        steps: ["Step 1", "Step 2"],
        confidence: 0.8,
        estimatedTime: "2-3 minutes",
        requiresRestart: true,
      );

      final json = suggestion.toJson();
      expect(json["title"], equals("Test Recovery"));
      expect(json["description"], equals("Test description"));
      expect(json["steps"], equals(["Step 1", "Step 2"]));
      expect(json["confidence"], equals(0.8));
      expect(json["estimated_time"], equals("2-3 minutes"));
      expect(json["requires_restart"], isTrue);
    });
  });

  group("ErrorPatternAnalyzer", () {
    late ErrorPatternAnalyzer analyzer;

    setUp(() {
      analyzer = ErrorPatternAnalyzer(
        maxHistorySize: 50,
        analysisWindow: const Duration(hours: 1),
        minOccurrencesForPattern: 3,
      );
    });

    tearDown(() {
      analyzer.dispose();
    });

    test("records errors and enforces memory bounds", () {
      // Add errors up to the limit
      for (int i = 0; i < 50; i++) {
        analyzer.recordError(ErrorOccurrence(
          timestamp: DateTime.now(),
          errorType: "test",
          message: "Test error $i",
          operation: "test",
          severity: ErrorSeverity.error,
          category: ErrorCategory.application,
        ));
      }

      // Add one more - should evict oldest
      analyzer.recordError(ErrorOccurrence(
        timestamp: DateTime.now(),
        errorType: "test",
        message: "Test error 50",
        operation: "test",
        severity: ErrorSeverity.error,
        category: ErrorCategory.application,
      ));

      final diagnostics = analyzer.getDiagnostics();
      expect(diagnostics["total_errors"], equals(50));
    });

    test("analyzes error patterns with sufficient data", () {
      final now = DateTime.now();
      
      // Add errors with the same signature
      for (int i = 0; i < 5; i++) {
        analyzer.recordError(ErrorOccurrence(
          timestamp: now.subtract(Duration(minutes: i * 10)),
          errorType: "timeout",
          message: "Operation timed out after ${30000 + i * 1000}ms",
          operation: "tools/call",
          severity: ErrorSeverity.error,
          category: ErrorCategory.network,
        ));
      }

      final pattern = analyzer.analyzeSignature("timeout:tools/call:operation timed out after <num>ms");
      expect(pattern, isNotNull);
      expect(pattern!.signature, equals("timeout:tools/call:operation timed out after <num>ms"));
      expect(pattern.occurrences, equals(5));
      expect(pattern.severity, equals(ErrorSeverity.error));
      expect(pattern.category, equals(ErrorCategory.network));
      expect(pattern.operations, contains("tools/call"));
    });

    test("returns null for insufficient data", () {
      // Add only 2 errors (below minimum of 3)
      for (int i = 0; i < 2; i++) {
        analyzer.recordError(ErrorOccurrence(
          timestamp: DateTime.now(),
          errorType: "test",
          message: "Test error",
          operation: "test",
          severity: ErrorSeverity.error,
          category: ErrorCategory.application,
        ));
      }

      final pattern = analyzer.analyzeSignature("test:test:test error");
      expect(pattern, isNull);
    });

    test("calculates trend correctly", () {
      final now = DateTime.now();
      
      // Add errors with clear increasing pattern - more errors in recent half
      final baseTime = now.subtract(const Duration(hours: 1));
      
      // Add 2 errors in first half (older)
      for (int i = 0; i < 2; i++) {
        analyzer.recordError(ErrorOccurrence(
          timestamp: baseTime.add(Duration(minutes: i * 10)),
          errorType: "increasing",
          message: "Error increasing",
          operation: "test",
          severity: ErrorSeverity.error,  
          category: ErrorCategory.network,
        ));
      }
      
      // Add 6 errors in second half (recent) - should trigger "increasing"
      for (int i = 0; i < 6; i++) {
        analyzer.recordError(ErrorOccurrence(
          timestamp: baseTime.add(Duration(minutes: 30 + i * 4)), // Recent half
          errorType: "increasing",
          message: "Error increasing",
          operation: "test",
          severity: ErrorSeverity.error,
          category: ErrorCategory.network,
        ));
      }

      final pattern = analyzer.analyzeSignature("increasing:test:error increasing");
      expect(pattern, isNotNull);
      expect(pattern!.trend, equals("increasing"));
    });

    test("gets all patterns sorted by priority", () {
      final now = DateTime.now();
      
      // Add critical errors
      for (int i = 0; i < 4; i++) {
        analyzer.recordError(ErrorOccurrence(
          timestamp: now.subtract(Duration(minutes: i * 5)),
          errorType: "critical",
          message: "Critical system error",
          operation: "system",
          severity: ErrorSeverity.critical,
          category: ErrorCategory.system,
        ));
      }

      // Add normal errors
      for (int i = 0; i < 5; i++) {
        analyzer.recordError(ErrorOccurrence(
          timestamp: now.subtract(Duration(minutes: i * 10)),
          errorType: "normal",
          message: "Normal error",
          operation: "app",
          severity: ErrorSeverity.error,
          category: ErrorCategory.application,
        ));
      }

      final patterns = analyzer.getAllPatterns();
      expect(patterns, hasLength(2));
      
      // Critical should come first
      expect(patterns.first.priority, equals("critical"));
      expect(patterns.last.priority, anyOf(equals("medium"), equals("low")));
    });

    test("generates network recovery suggestions", () {
      final pattern = ErrorPattern(
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

      final suggestions = analyzer.generateRecoverySuggestions(pattern);
      expect(suggestions, isNotEmpty);
      expect(suggestions.any((s) => s.title.contains("Network")), isTrue);
    });

    test("generates systemic issue suggestions for frequent errors", () {
      final systemicPattern = ErrorPattern(
        signature: "system:test:frequent error",
        occurrences: 15,
        frequency: 30.0,
        averageInterval: const Duration(minutes: 2),
        severity: ErrorSeverity.error,
        category: ErrorCategory.system,
        operations: {"test"},
        firstSeen: DateTime.now().subtract(const Duration(hours: 1)),
        lastSeen: DateTime.now(),
        trend: "increasing",
      );

      final suggestions = analyzer.generateRecoverySuggestions(systemicPattern);
      expect(suggestions, isNotEmpty);
      expect(suggestions.any((s) => s.title.contains("Systemic")), isTrue);
    });

    test("exports analytics data correctly", () {
      final now = DateTime.now();
      
      // Add some test errors
      for (int i = 0; i < 10; i++) {
        analyzer.recordError(ErrorOccurrence(
          timestamp: now.subtract(Duration(minutes: i * 5)),
          errorType: "test",
          message: "Test error",
          operation: "test_op",
          severity: ErrorSeverity.error,
          category: ErrorCategory.application,
        ));
      }

      final analytics = analyzer.exportAnalytics();
      expect(analytics["total_errors"], equals(10));
      expect(analytics["unique_patterns"], greaterThanOrEqualTo(0));
      expect(analytics["error_distribution"], isA<Map>());
      expect(analytics["export_timestamp"], isA<String>());
      expect(analytics["analysis_window_hours"], equals(1));
    });

    test("provides comprehensive diagnostics", () {
      // Add some test data
      analyzer.recordError(ErrorOccurrence(
        timestamp: DateTime.now(),
        errorType: "test",
        message: "Test error",
        operation: "test",
        severity: ErrorSeverity.error,
        category: ErrorCategory.application,
      ));

      final diagnostics = analyzer.getDiagnostics();
      expect(diagnostics["total_errors"], equals(1));
      expect(diagnostics["recent_errors"], equals(1));
      expect(diagnostics["analysis_window_hours"], equals(1));
      expect(diagnostics["min_occurrences_for_pattern"], equals(3));
      expect(diagnostics["identified_patterns"], equals(0)); // Below threshold
      expect(diagnostics["cache_size"], isA<int>());
      expect(diagnostics["high_priority_patterns"], isA<int>());
    });

    test("clears history correctly", () {
      // Add some errors
      for (int i = 0; i < 5; i++) {
        analyzer.recordError(ErrorOccurrence(
          timestamp: DateTime.now(),
          errorType: "test",
          message: "Test error",
          operation: "test",
          severity: ErrorSeverity.error,
          category: ErrorCategory.application,
        ));
      }

      expect(analyzer.getDiagnostics()["total_errors"], equals(5));

      analyzer.clearHistory();

      expect(analyzer.getDiagnostics()["total_errors"], equals(0));
    });

    test("handles edge cases gracefully", () {
      // Test with no errors
      expect(analyzer.getAllPatterns(), isEmpty);
      expect(analyzer.analyzeSignature("nonexistent"), isNull);
      
      final emptyAnalytics = analyzer.exportAnalytics();
      expect(emptyAnalytics["total_errors"], equals(0));
      expect(emptyAnalytics["unique_patterns"], equals(0));

      // Test with errors outside analysis window  
      analyzer.recordError(ErrorOccurrence(
        timestamp: DateTime.now().subtract(const Duration(hours: 2)), // Outside window
        errorType: "old",
        message: "Old error",
        operation: "test",
        severity: ErrorSeverity.error,
        category: ErrorCategory.application,
      ));

      // Should be filtered out in recent analysis
      final patterns = analyzer.getAllPatterns();
      expect(patterns, isEmpty);
    });
  });
}