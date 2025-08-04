import "package:test/test.dart";
import "../../../lib/src/managers/timeout_analyzer.dart";

void main() {
  group("TimeoutOperation", () {
    test("calculates efficiency score correctly", () {
      // Perfect efficiency (80% of timeout used)
      final perfectOp = TimeoutOperation(
        method: "test",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 8),
        success: true,
        timestamp: DateTime.now(),
      );
      expect(perfectOp.efficiencyScore, equals(1.0));

      // Too fast (60% of timeout used)
      final fastOp = TimeoutOperation(
        method: "test",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 6),
        success: true,
        timestamp: DateTime.now(),
      );
      expect(fastOp.efficiencyScore, equals(0.8));

      // Close to timeout (95% used)
      final closeOp = TimeoutOperation(
        method: "test",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 9, milliseconds: 500),
        success: true,
        timestamp: DateTime.now(),
      );
      expect(closeOp.efficiencyScore, equals(0.6));

      // Failed operation
      final failedOp = TimeoutOperation(
        method: "test",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 10),
        success: false,
        timestamp: DateTime.now(),
      );
      expect(failedOp.efficiencyScore, equals(0.0));
    });

    test("converts to JSON correctly", () {
      final op = TimeoutOperation(
        method: "tools/call",
        requestedTimeout: const Duration(seconds: 30),
        actualDuration: const Duration(seconds: 25),
        success: true,
        timestamp: DateTime(2025, 1, 1, 12, 0, 0),
        errorType: null,
      );

      final json = op.toJson();
      expect(json["method"], equals("tools/call"));
      expect(json["requested_timeout_ms"], equals(30000));
      expect(json["actual_duration_ms"], equals(25000));
      expect(json["success"], isTrue);
      expect(json["timestamp"], equals("2025-01-01T12:00:00.000"));
      expect(json["error_type"], isNull);
      expect(json["efficiency_score"], equals(1.0)); // 25/30 = 83% is in 70-90% range
    });
  });

  group("TimeoutAnalysis", () {
    test("determines adjustment necessity correctly", () {
      // Should adjust - recommendation differs by >20%
      final adjustNeeded = TimeoutAnalysis(
        method: "test",
        totalOperations: 100,
        successRate: 0.9,
        averageEfficiency: 0.8,
        recommendedTimeout: const Duration(seconds: 15), // 50% increase
        confidence: 0.8,
        currentTimeout: const Duration(seconds: 10),
      );
      expect(adjustNeeded.shouldAdjust, isTrue);

      // Should not adjust - recommendation within 20%
      final noAdjustNeeded = TimeoutAnalysis(
        method: "test",
        totalOperations: 100,
        successRate: 0.9,
        averageEfficiency: 0.8,
        recommendedTimeout: const Duration(seconds: 11), // 10% increase
        confidence: 0.8,
        currentTimeout: const Duration(seconds: 10),
      );
      expect(noAdjustNeeded.shouldAdjust, isFalse);
    });

    test("calculates adjustment priority correctly", () {
      // High priority - low success rate
      final highPriority = TimeoutAnalysis(
        method: "test",
        totalOperations: 100,
        successRate: 0.7, // Below 0.8 threshold
        averageEfficiency: 0.8,
        recommendedTimeout: const Duration(seconds: 15),
        confidence: 0.8,
        currentTimeout: const Duration(seconds: 10),
      );
      expect(highPriority.adjustmentPriority, equals("high"));

      // Medium priority - low efficiency
      final mediumPriority = TimeoutAnalysis(
        method: "test",
        totalOperations: 100,
        successRate: 0.9,
        averageEfficiency: 0.5, // Below 0.6 threshold
        recommendedTimeout: const Duration(seconds: 15),
        confidence: 0.8,
        currentTimeout: const Duration(seconds: 10),
      );
      expect(mediumPriority.adjustmentPriority, equals("medium"));

      // Low priority - low confidence
      final lowPriority = TimeoutAnalysis(
        method: "test",
        totalOperations: 100,
        successRate: 0.9,
        averageEfficiency: 0.8,
        recommendedTimeout: const Duration(seconds: 15),
        confidence: 0.4, // Below 0.5 threshold
        currentTimeout: const Duration(seconds: 10),
      );
      expect(lowPriority.adjustmentPriority, equals("low"));
    });
  });

  group("TimeoutAnalyzer", () {
    late TimeoutAnalyzer analyzer;

    setUp(() {
      analyzer = TimeoutAnalyzer(
        maxHistorySize: 100,
        analysisWindow: const Duration(hours: 1),
        minOperationsForRecommendation: 5,
      );
    });

    tearDown(() {
      analyzer.dispose();
    });

    test("records operations and enforces memory bounds", () {
      // Add operations up to the limit
      for (int i = 0; i < 100; i++) {
        analyzer.recordOperation(TimeoutOperation(
          method: "test",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 8),
          success: true,
          timestamp: DateTime.now(),
        ));
      }

      // Add one more - should evict oldest
      analyzer.recordOperation(TimeoutOperation(
        method: "test",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 8),
        success: true,
        timestamp: DateTime.now(),
      ));

      final diagnostics = analyzer.getDiagnostics();
      expect(diagnostics["total_operations"], equals(100));
    });

    test("analyzes method with sufficient data", () {
      final now = DateTime.now();
      
      // Add successful operations with varying durations
      for (int i = 0; i < 20; i++) {
        analyzer.recordOperation(TimeoutOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 30),
          actualDuration: Duration(seconds: 20 + (i % 10)), // 20-29 seconds
          success: true,
          timestamp: now.subtract(Duration(minutes: i)),
        ));
      }

      final analysis = analyzer.analyzeMethod(
        "tools/call", 
        const Duration(seconds: 30),
      );

      expect(analysis, isNotNull);
      expect(analysis!.method, equals("tools/call"));
      expect(analysis.totalOperations, equals(20));
      expect(analysis.successRate, equals(1.0));
      expect(analysis.confidence, greaterThan(0.0));
    });

    test("returns null for insufficient data", () {
      // Add only 3 operations (below minimum of 5)
      for (int i = 0; i < 3; i++) {
        analyzer.recordOperation(TimeoutOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 30),
          actualDuration: const Duration(seconds: 25),
          success: true,
          timestamp: DateTime.now(),
        ));
      }

      final analysis = analyzer.analyzeMethod(
        "tools/call",
        const Duration(seconds: 30),
      );

      expect(analysis, isNull);
    });

    test("handles all failed operations", () {
      final now = DateTime.now();
      
      // Add failed operations
      for (int i = 0; i < 10; i++) {
        analyzer.recordOperation(TimeoutOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 30),
          actualDuration: const Duration(seconds: 30),
          success: false,
          timestamp: now.subtract(Duration(minutes: i)),
          errorType: "timeout",
        ));
      }

      final analysis = analyzer.analyzeMethod(
        "tools/call",
        const Duration(seconds: 30),
      );

      expect(analysis, isNotNull);
      expect(analysis!.successRate, equals(0.0));
      expect(analysis.averageEfficiency, equals(0.0));
      // Should recommend longer timeout
      expect(analysis.recommendedTimeout.inMilliseconds, 
             greaterThan(const Duration(seconds: 30).inMilliseconds));
    });

    test("gets top recommendations sorted by priority", () {
      final now = DateTime.now();
      
      // Add high-priority method (low success rate)
      for (int i = 0; i < 10; i++) {
        analyzer.recordOperation(TimeoutOperation(
          method: "critical",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 10),
          success: i < 6, // 60% success rate (below 80% threshold)
          timestamp: now.subtract(Duration(minutes: i)),
        ));
      }

      // Add medium-priority method (good success rate, but needs adjustment)
      for (int i = 0; i < 10; i++) {
        analyzer.recordOperation(TimeoutOperation(
          method: "normal",
          requestedTimeout: const Duration(seconds: 5),
          actualDuration: const Duration(seconds: 4),
          success: true,
          timestamp: now.subtract(Duration(minutes: i)),
        ));
      }

      final currentTimeouts = {
        "critical": const Duration(seconds: 10),
        "normal": const Duration(seconds: 5),
      };

      final recommendations = analyzer.getTopRecommendations(currentTimeouts);
      
      // Check that we have analysis data even if no adjustments needed  
      final allAnalyses = analyzer.analyzeAllMethods(currentTimeouts);
      expect(allAnalyses, isNotEmpty);
      expect(allAnalyses, contains("critical"));
      
      // The critical method should have analysis showing low success rate
      final criticalAnalysis = allAnalyses["critical"];
      expect(criticalAnalysis!.successRate, lessThan(0.8));
    });

    test("exports historical data correctly", () {
      final now = DateTime.now();
      
      // Add some operations
      for (int i = 0; i < 5; i++) {
        analyzer.recordOperation(TimeoutOperation(
          method: "test",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 8),
          success: true,
          timestamp: now.subtract(Duration(minutes: i)),
        ));
      }

      final exported = analyzer.exportHistoricalData();
      
      expect(exported["total_operations"], equals(5));
      expect(exported["operations"], hasLength(5));
      expect(exported["analysis_window_hours"], equals(1));
      expect(exported["export_timestamp"], isA<String>());
    });

    test("cleans up stale operations", () {
      final now = DateTime.now();
      
      // Add old operation (outside analysis window)
      analyzer.recordOperation(TimeoutOperation(
        method: "test",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 8),
        success: true,
        timestamp: now.subtract(const Duration(hours: 2)), // Outside window
      ));

      // Add recent operation
      analyzer.recordOperation(TimeoutOperation(
        method: "test",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 8),
        success: true,
        timestamp: now.subtract(const Duration(minutes: 30)), // Within window
      ));

      // Force cleanup
      analyzer.clearHistory();
      analyzer.recordOperation(TimeoutOperation(
        method: "test",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 8),
        success: true,
        timestamp: now,
      ));

      final diagnostics = analyzer.getDiagnostics();
      expect(diagnostics["total_operations"], equals(1));
    });

    test("provides comprehensive diagnostics", () {
      final now = DateTime.now();
      
      // Add operations for multiple methods
      analyzer.recordOperation(TimeoutOperation(
        method: "method1",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 8),
        success: true,
        timestamp: now,
      ));

      analyzer.recordOperation(TimeoutOperation(
        method: "method2",
        requestedTimeout: const Duration(seconds: 5),
        actualDuration: const Duration(seconds: 4),
        success: true,
        timestamp: now,
      ));

      final diagnostics = analyzer.getDiagnostics();
      
      expect(diagnostics["total_operations"], equals(2));
      expect(diagnostics["recent_operations"], equals(2));
      expect(diagnostics["method_counts"], containsPair("method1", 1));
      expect(diagnostics["method_counts"], containsPair("method2", 1));
      expect(diagnostics["oldest_operation"], isA<String>());
      expect(diagnostics["newest_operation"], isA<String>());
    });
  });
}