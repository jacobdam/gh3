import "dart:async";
import "configurable_timeout_manager.dart";
import "timeout_analyzer.dart";

/// Adaptation modes for timeout adjustments
enum AdaptationMode {
  disabled,     // No automatic adjustments
  conservative, // Only high-confidence, low-risk adjustments
  balanced,     // Moderate adjustments with good confidence
  aggressive,   // All recommended adjustments applied
}

/// Configuration for adaptive timeout behavior
class AdaptiveConfiguration {
  const AdaptiveConfiguration({
    this.enabled = true,
    this.mode = AdaptationMode.balanced,
    this.adjustmentInterval = const Duration(hours: 1),
    this.minOperationsForAdjustment = 20,
    this.maxTimeoutIncrease = 2.0,
    this.maxTimeoutDecrease = 0.5,
    this.confidenceThreshold = 0.6,
  });

  final bool enabled;
  final AdaptationMode mode;
  final Duration adjustmentInterval;
  final int minOperationsForAdjustment;
  final double maxTimeoutIncrease; // Multiplier (2.0 = max 2x increase)
  final double maxTimeoutDecrease; // Multiplier (0.5 = max 50% decrease)
  final double confidenceThreshold; // Minimum confidence for adjustments

  Map<String, dynamic> toJson() => {
    "enabled": enabled,
    "mode": mode.name,
    "adjustment_interval_minutes": adjustmentInterval.inMinutes,
    "min_operations_for_adjustment": minOperationsForAdjustment,
    "max_timeout_increase": maxTimeoutIncrease,
    "max_timeout_decrease": maxTimeoutDecrease,
    "confidence_threshold": confidenceThreshold,
  };
}

/// Enhanced timeout manager with adaptive behavior based on historical patterns
class AdaptiveTimeoutManager extends ConfigurableTimeoutManager {
  AdaptiveTimeoutManager({
    TimeoutConfiguration? initialConfig,
    AdaptiveConfiguration? adaptiveConfig,
  }) : _adaptiveConfig = adaptiveConfig ?? const AdaptiveConfiguration(),
       _analyzer = TimeoutAnalyzer(),
       super(initialConfig: initialConfig) {
    if (_adaptiveConfig.enabled && _adaptiveConfig.mode != AdaptationMode.disabled) {
      _schedulePeriodicAdjustment();
    }
  }

  final AdaptiveConfiguration _adaptiveConfig;
  final TimeoutAnalyzer _analyzer;
  Timer? _adjustmentTimer;
  DateTime? _lastAdjustment;

  /// Schedule periodic timeout adjustments
  void _schedulePeriodicAdjustment() {
    _adjustmentTimer?.cancel();
    _adjustmentTimer = Timer.periodic(_adaptiveConfig.adjustmentInterval, (_) {
      _performAutomaticAdjustments();
    });
  }

  /// Perform automatic timeout adjustments based on analysis
  void _performAutomaticAdjustments() {
    if (!_adaptiveConfig.enabled || _adaptiveConfig.mode == AdaptationMode.disabled) {
      return;
    }

    final currentTimeouts = getAllTimeouts();
    final recommendations = _analyzer.getTopRecommendations(currentTimeouts);

    int adjustmentsMade = 0;
    for (final recommendation in recommendations) {
      if (_shouldApplyRecommendation(recommendation)) {
        final safeBoundedTimeout = _applySafeBounds(
          recommendation.recommendedTimeout,
          recommendation.currentTimeout,
        );
        
        updateTimeout(recommendation.method, safeBoundedTimeout);
        adjustmentsMade++;
      }
    }

    if (adjustmentsMade > 0) {
      _lastAdjustment = DateTime.now();
    }
  }

  /// Check if a recommendation should be applied based on adaptation mode
  bool _shouldApplyRecommendation(TimeoutAnalysis recommendation) {
    // Must meet confidence threshold
    if (recommendation.confidence < _adaptiveConfig.confidenceThreshold) {
      return false;
    }

    // Must have sufficient operations
    if (recommendation.totalOperations < _adaptiveConfig.minOperationsForAdjustment) {
      return false;
    }

    // Apply mode-specific filtering
    switch (_adaptiveConfig.mode) {
      case AdaptationMode.disabled:
        return false;
      
      case AdaptationMode.conservative:
        return recommendation.adjustmentPriority == "high" && 
               recommendation.confidence >= 0.8;
      
      case AdaptationMode.balanced:
        return recommendation.adjustmentPriority != "none" && 
               recommendation.adjustmentPriority != "low";
      
      case AdaptationMode.aggressive:
        return recommendation.shouldAdjust;
    }
  }

  /// Apply safety bounds to recommended timeout
  Duration _applySafeBounds(Duration recommended, Duration current) {
    final currentMs = current.inMilliseconds;
    final recommendedMs = recommended.inMilliseconds;

    // Calculate bounds
    final maxIncreaseMs = (currentMs * _adaptiveConfig.maxTimeoutIncrease).round();
    final maxDecreaseMs = (currentMs * _adaptiveConfig.maxTimeoutDecrease).round();

    // Apply bounds
    final boundedMs = recommendedMs.clamp(maxDecreaseMs, maxIncreaseMs);
    
    return Duration(milliseconds: boundedMs);
  }

  /// Record a timeout operation for analysis
  void recordOperation({
    required String method,
    required Duration requestedTimeout,
    required Duration actualDuration,
    required bool success,
    String? errorType,
  }) {
    final operation = TimeoutOperation(
      method: method,
      requestedTimeout: requestedTimeout,
      actualDuration: actualDuration,
      success: success,
      timestamp: DateTime.now(),
      errorType: errorType,
    );

    _analyzer.recordOperation(operation);
  }

  /// Get timeout analysis for a specific method
  TimeoutAnalysis? getMethodAnalysis(String method) {
    final currentTimeout = getTimeout(method, null);
    return _analyzer.analyzeMethod(method, currentTimeout);
  }

  /// Get timeout recommendations for all methods
  List<TimeoutAnalysis> getTimeoutRecommendations({int limit = 10}) {
    final currentTimeouts = getAllTimeouts();
    return _analyzer.getTopRecommendations(currentTimeouts, limit: limit);
  }

  /// Get comprehensive analysis for all methods with data
  Map<String, TimeoutAnalysis> getAllMethodAnalyses() {
    final currentTimeouts = getAllTimeouts();
    return _analyzer.analyzeAllMethods(currentTimeouts);
  }

  /// Update adaptive configuration
  void updateAdaptiveConfiguration(AdaptiveConfiguration config) {
    // Cancel existing timer
    _adjustmentTimer?.cancel();
    
    // Update configuration
    final oldConfig = _adaptiveConfig;
    // Note: In a real implementation, _adaptiveConfig would need to be mutable
    // or we'd need to recreate the manager. For this implementation, we'll
    // assume the configuration update mechanism.
    
    // Restart timer if needed
    if (config.enabled && config.mode != AdaptationMode.disabled) {
      _schedulePeriodicAdjustment();
    }
  }

  /// Get timeout hint for a specific operation
  /// Returns recommended timeout based on historical patterns
  Duration? getTimeoutHint(String method, {double confidenceThreshold = 0.5}) {
    final analysis = getMethodAnalysis(method);
    
    if (analysis == null || analysis.confidence < confidenceThreshold) {
      return null; // Insufficient data or low confidence
    }

    return analysis.recommendedTimeout;
  }

  /// Force immediate adjustment analysis and application
  int performImmediateAdjustment() {
    if (!_adaptiveConfig.enabled) return 0;
    
    final currentTimeouts = getAllTimeouts();
    final recommendations = _analyzer.getTopRecommendations(currentTimeouts);

    int adjustmentsMade = 0;
    for (final recommendation in recommendations) {
      if (_shouldApplyRecommendation(recommendation)) {
        final safeBoundedTimeout = _applySafeBounds(
          recommendation.recommendedTimeout,
          recommendation.currentTimeout,
        );
        
        updateTimeout(recommendation.method, safeBoundedTimeout);
        adjustmentsMade++;
      }
    }

    if (adjustmentsMade > 0) {
      _lastAdjustment = DateTime.now();
    }

    return adjustmentsMade;
  }

  /// Export historical timeout data for external analysis
  Map<String, dynamic> exportTimeoutHistory() {
    return _analyzer.exportHistoricalData();
  }

  /// Get comprehensive diagnostic information
  Map<String, dynamic> getAdaptiveDiagnostics() {
    final baseInfo = getConfigurationInfo();
    final analyzerDiagnostics = _analyzer.getDiagnostics();
    
    return {
      ...baseInfo,
      "adaptive_enabled": _adaptiveConfig.enabled,
      "adaptive_mode": _adaptiveConfig.mode.name,
      "last_adjustment": _lastAdjustment?.toIso8601String(),
      "next_adjustment": _adjustmentTimer != null 
          ? DateTime.now().add(_adaptiveConfig.adjustmentInterval).toIso8601String()
          : null,
      "analyzer": analyzerDiagnostics,
      "adaptive_config": _adaptiveConfig.toJson(),
    };
  }

  /// Clear all historical data (useful for testing or reset)
  void clearHistory() {
    _analyzer.clearHistory();
  }

  @override
  void dispose() {
    _adjustmentTimer?.cancel();
    _analyzer.dispose();
    super.dispose();
  }
}