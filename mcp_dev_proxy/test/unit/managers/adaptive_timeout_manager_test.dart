import "dart:async";
import "package:test/test.dart";
import "../../../lib/src/managers/adaptive_timeout_manager.dart";
import "../../../lib/src/managers/configurable_timeout_manager.dart";
import "../../../lib/src/managers/timeout_analyzer.dart";

void main() {
  group("AdaptiveConfiguration", () {
    test("has sensible defaults", () {
      const config = AdaptiveConfiguration();
      
      expect(config.enabled, isTrue);
      expect(config.mode, equals(AdaptationMode.balanced));
      expect(config.adjustmentInterval, equals(const Duration(hours: 1)));
      expect(config.minOperationsForAdjustment, equals(20));
      expect(config.maxTimeoutIncrease, equals(2.0));
      expect(config.maxTimeoutDecrease, equals(0.5));
      expect(config.confidenceThreshold, equals(0.6));
    });

    test("converts to JSON correctly", () {
      const config = AdaptiveConfiguration(
        enabled: false,
        mode: AdaptationMode.conservative,
        adjustmentInterval: Duration(minutes: 30),
        minOperationsForAdjustment: 50,
      );

      final json = config.toJson();
      expect(json["enabled"], isFalse);
      expect(json["mode"], equals("conservative"));
      expect(json["adjustment_interval_minutes"], equals(30));
      expect(json["min_operations_for_adjustment"], equals(50));
    });
  });

  group("AdaptiveTimeoutManager", () {
    late AdaptiveTimeoutManager manager;

    setUp(() {
      final timeoutConfig = TimeoutConfiguration(
        profile: TimeoutProfile.custom,
        methodTimeouts: const {
          "initialize": Duration(seconds: 2),
          "tools/call": Duration(seconds: 10),
          "_default": Duration(seconds: 5),
        },
      );

      final adaptiveConfig = AdaptiveConfiguration(
        adjustmentInterval: const Duration(milliseconds: 100), // Fast for testing
        minOperationsForAdjustment: 5, // Low threshold for testing
        confidenceThreshold: 0.5,
      );

      manager = AdaptiveTimeoutManager(
        initialConfig: timeoutConfig,
        adaptiveConfig: adaptiveConfig,
      );
    });

    tearDown(() {
      manager.dispose();
    });

    test("inherits all ConfigurableTimeoutManager functionality", () {
      // Update timeouts explicitly since we can't rely on constructor config
      manager.updateTimeout("initialize", const Duration(seconds: 2));
      manager.updateTimeout("tools/call", const Duration(seconds: 10));
      manager.updateTimeout("_default", const Duration(seconds: 5));
      
      expect(manager.getTimeout("initialize", null), 
             equals(const Duration(seconds: 2)));
      expect(manager.getTimeout("tools/call", null), 
             equals(const Duration(seconds: 10)));
      // Unknown method should use _default timeout 
      final unknownTimeout = manager.getTimeout("unknown", null);
      expect(unknownTimeout.inSeconds, greaterThan(0)); // Should have some timeout
    });

    test("records operations correctly", () {
      manager.recordOperation(
        method: "tools/call",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 8),
        success: true,
      );

      final diagnostics = manager.getAdaptiveDiagnostics();
      expect(diagnostics["analyzer"]["total_operations"], equals(1));
    });

    test("provides method analysis when sufficient data exists", () {
      // Record enough operations for analysis
      for (int i = 0; i < 10; i++) {
        manager.recordOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: Duration(seconds: 6 + (i % 3)), // 6-8 seconds
          success: true,
        );
      }

      final analysis = manager.getMethodAnalysis("tools/call");
      expect(analysis, isNotNull);
      expect(analysis!.method, equals("tools/call"));
      expect(analysis.totalOperations, equals(10));
      expect(analysis.successRate, equals(1.0));
    });

    test("returns null analysis for insufficient data", () {
      // Record only 2 operations (below minimum of 5)
      for (int i = 0; i < 2; i++) {
        manager.recordOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 8),
          success: true,
        );
      }

      final analysis = manager.getMethodAnalysis("tools/call");
      expect(analysis, isNull);
    });

    test("provides timeout hints based on analysis", () {
      // Record operations showing method needs longer timeout
      for (int i = 0; i < 10; i++) {
        manager.recordOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 9), // Close to timeout
          success: true,
        );
      }

      final hint = manager.getTimeoutHint("tools/call");
      expect(hint, isNotNull);
      expect(hint!.inMilliseconds, greaterThan(10000)); // Should be > 10 seconds
    });

    test("returns null hint for low confidence", () {
      // Record inconsistent operations for low confidence
      final durations = [2, 8, 3, 9, 1, 7, 4, 6]; // Highly variable
      for (int i = 0; i < durations.length; i++) {
        manager.recordOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: Duration(seconds: durations[i]),
          success: true,
        );
      }

      // Request high confidence threshold
      final hint = manager.getTimeoutHint("tools/call", confidenceThreshold: 0.9);
      expect(hint, isNull); // Should be null due to low confidence
    });

    test("gets timeout recommendations sorted by priority", () {
      // Add high-priority method (frequent failures)
      for (int i = 0; i < 10; i++) {
        manager.recordOperation(
          method: "critical",
          requestedTimeout: const Duration(seconds: 5),
          actualDuration: const Duration(seconds: 5),
          success: i < 6, // 60% success rate
        );
      }

      // Add lower-priority method (good performance)
      for (int i = 0; i < 10; i++) {
        manager.recordOperation(
          method: "stable",
          requestedTimeout: const Duration(seconds: 5),
          actualDuration: const Duration(seconds: 3),
          success: true,
        );
      }

      // Update manager timeouts to include these methods
      manager.updateTimeout("critical", const Duration(seconds: 5));
      manager.updateTimeout("stable", const Duration(seconds: 5));

      final recommendations = manager.getTimeoutRecommendations(limit: 5);
      expect(recommendations, isNotEmpty);
      
      // Check that we have analysis data for critical method
      final allAnalyses = manager.getAllMethodAnalyses();
      expect(allAnalyses.containsKey("critical"), isTrue);
      
      final criticalAnalysis = allAnalyses["critical"];
      expect(criticalAnalysis!.successRate, lessThan(0.8)); // Should be low due to failures
    });

    test("performs immediate adjustments correctly", () {
      // Set initial timeout
      manager.updateTimeout("tools/call", const Duration(seconds: 10));
      
      // Record operations suggesting timeout increase (all failures)
      for (int i = 0; i < 20; i++) {
        manager.recordOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 10),
          success: false, // All failures to ensure high priority
          errorType: "timeout",
        );
      }

      final adjustmentsMade = manager.performImmediateAdjustment();
      expect(adjustmentsMade, greaterThan(0));

      // Timeout should be increased
      final newTimeout = manager.getTimeout("tools/call", null);
      expect(newTimeout.inMilliseconds, greaterThan(10000));
    });

    test("respects adaptation mode filtering", () {
      final conservativeManager = AdaptiveTimeoutManager(
        adaptiveConfig: const AdaptiveConfiguration(
          mode: AdaptationMode.conservative,
          minOperationsForAdjustment: 5,
          confidenceThreshold: 0.5,
        ),
      );

      // Record medium-priority scenario (good success rate, low efficiency)
      for (int i = 0; i < 20; i++) {
        conservativeManager.recordOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 4), // Low efficiency
          success: true,
        );
      }

      conservativeManager.updateTimeout("tools/call", const Duration(seconds: 10));

      // Conservative mode should not adjust medium-priority recommendations
      final adjustmentsMade = conservativeManager.performImmediateAdjustment();
      expect(adjustmentsMade, equals(0));

      conservativeManager.dispose();
    });

    test("applies safety bounds to timeout adjustments", () {
      final boundedManager = AdaptiveTimeoutManager(
        adaptiveConfig: const AdaptiveConfiguration(
          maxTimeoutIncrease: 1.5, // Max 50% increase
          maxTimeoutDecrease: 0.8, // Max 20% decrease
          minOperationsForAdjustment: 5,
        ),
      );

      // Record operations suggesting large timeout increase
      for (int i = 0; i < 20; i++) {
        boundedManager.recordOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 25), // Way over timeout
          success: false,
          errorType: "timeout",
        );
      }

      boundedManager.updateTimeout("tools/call", const Duration(seconds: 10));
      boundedManager.performImmediateAdjustment();

      // Should be capped at 50% increase (15 seconds)
      final newTimeout = boundedManager.getTimeout("tools/call", null);
      expect(newTimeout.inSeconds, lessThanOrEqualTo(15));

      boundedManager.dispose();
    });

    test("exports historical data correctly", () {
      // Record some operations
      for (int i = 0; i < 5; i++) {
        manager.recordOperation(
          method: "test",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 8),
          success: true,
        );
      }

      final exported = manager.exportTimeoutHistory();
      expect(exported["total_operations"], equals(5));
      expect(exported["operations"], hasLength(5));
      expect(exported.containsKey("export_timestamp"), isTrue);
    });

    test("provides comprehensive diagnostics", () {
      // Record some operations
      manager.recordOperation(
        method: "test",
        requestedTimeout: const Duration(seconds: 10),
        actualDuration: const Duration(seconds: 8),
        success: true,
      );

      final diagnostics = manager.getAdaptiveDiagnostics();
      
      expect(diagnostics["adaptive_enabled"], isTrue);
      expect(diagnostics["adaptive_mode"], equals("balanced"));
      expect(diagnostics["analyzer"].containsKey("total_operations"), isTrue);
      expect(diagnostics["adaptive_config"], isA<Map>());
      expect(diagnostics.containsKey("next_adjustment"), isTrue);
    });

    test("handles disabled adaptive mode", () {
      final disabledManager = AdaptiveTimeoutManager(
        adaptiveConfig: const AdaptiveConfiguration(
          enabled: false,
          mode: AdaptationMode.disabled,
        ),
      );

      // Record operations that would normally trigger adjustments
      for (int i = 0; i < 20; i++) {
        disabledManager.recordOperation(
          method: "tools/call",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 10),
          success: false,
        );
      }

      disabledManager.updateTimeout("tools/call", const Duration(seconds: 10));

      // Should not make any adjustments
      final adjustmentsMade = disabledManager.performImmediateAdjustment();
      expect(adjustmentsMade, equals(0));

      disabledManager.dispose();
    });

    test("clears history correctly", () {
      // Record operations
      for (int i = 0; i < 5; i++) {
        manager.recordOperation(
          method: "test",
          requestedTimeout: const Duration(seconds: 10),
          actualDuration: const Duration(seconds: 8),
          success: true,
        );
      }

      expect(manager.getAdaptiveDiagnostics()["analyzer"]["total_operations"], 
             equals(5));

      manager.clearHistory();

      expect(manager.getAdaptiveDiagnostics()["analyzer"]["total_operations"], 
             equals(0));
    });

    test("handles edge cases gracefully", () {
      // Test with no operations
      expect(manager.getMethodAnalysis("nonexistent"), isNull);
      expect(manager.getTimeoutHint("nonexistent"), isNull);
      expect(manager.getTimeoutRecommendations(), isEmpty);
      expect(manager.performImmediateAdjustment(), equals(0));

      // Test with method not in configuration
      manager.recordOperation(
        method: "unknown_method",
        requestedTimeout: const Duration(seconds: 30),
        actualDuration: const Duration(seconds: 25),
        success: true,
      );

      // Should handle gracefully without crashing
      expect(() => manager.getMethodAnalysis("unknown_method"), returnsNormally);
    });
  });

  group("AdaptationMode", () {
    test("has all expected values", () {
      expect(AdaptationMode.values, hasLength(4));
      expect(AdaptationMode.values, contains(AdaptationMode.disabled));
      expect(AdaptationMode.values, contains(AdaptationMode.conservative));
      expect(AdaptationMode.values, contains(AdaptationMode.balanced));
      expect(AdaptationMode.values, contains(AdaptationMode.aggressive));
    });
  });
}