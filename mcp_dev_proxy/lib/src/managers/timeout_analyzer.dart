import "dart:async";
import "dart:collection";
import "dart:math";

/// Represents a timeout operation result for analysis
class TimeoutOperation {
  const TimeoutOperation({
    required this.method,
    required this.requestedTimeout,
    required this.actualDuration,
    required this.success,
    required this.timestamp,
    this.errorType,
  });

  final String method;
  final Duration requestedTimeout;
  final Duration actualDuration;
  final bool success;
  final DateTime timestamp;
  final String? errorType;

  /// Calculate efficiency score (0.0-1.0) for this operation
  double get efficiencyScore {
    if (!success) return 0.0;
    
    final ratio = actualDuration.inMilliseconds / requestedTimeout.inMilliseconds;
    
    // Optimal efficiency when actual duration is 70-90% of timeout
    if (ratio >= 0.7 && ratio <= 0.9) return 1.0;
    if (ratio < 0.7) return 0.8; // Too fast timeout (could be longer)
    if (ratio <= 1.0) return 0.6; // Close to timeout (risky)
    return 0.0; // Timed out
  }

  Map<String, dynamic> toJson() => {
    "method": method,
    "requested_timeout_ms": requestedTimeout.inMilliseconds,
    "actual_duration_ms": actualDuration.inMilliseconds,
    "success": success,
    "timestamp": timestamp.toIso8601String(),
    "error_type": errorType,
    "efficiency_score": efficiencyScore,
  };
}

/// Analysis results for a specific method's timeout patterns
class TimeoutAnalysis {
  const TimeoutAnalysis({
    required this.method,
    required this.totalOperations,
    required this.successRate,
    required this.averageEfficiency,
    required this.recommendedTimeout,
    required this.confidence,
    required this.currentTimeout,
  });

  final String method;
  final int totalOperations;
  final double successRate;
  final double averageEfficiency;
  final Duration recommendedTimeout;
  final double confidence; // 0.0-1.0
  final Duration currentTimeout;

  /// Whether the recommendation suggests a significant change
  bool get shouldAdjust => 
    (recommendedTimeout.inMilliseconds - currentTimeout.inMilliseconds).abs() > 
    (currentTimeout.inMilliseconds * 0.2); // 20% threshold

  /// Priority level for this adjustment recommendation
  String get adjustmentPriority {
    if (!shouldAdjust) return "none";
    if (confidence < 0.5) return "low";
    if (successRate < 0.8) return "high";
    if (averageEfficiency < 0.6) return "medium";
    return "low";
  }

  Map<String, dynamic> toJson() => {
    "method": method,
    "total_operations": totalOperations,
    "success_rate": successRate,
    "average_efficiency": averageEfficiency,
    "recommended_timeout_ms": recommendedTimeout.inMilliseconds,
    "current_timeout_ms": currentTimeout.inMilliseconds,
    "confidence": confidence,
    "should_adjust": shouldAdjust,
    "adjustment_priority": adjustmentPriority,
  };
}

/// Analyzes timeout patterns and provides adaptive recommendations
class TimeoutAnalyzer {
  TimeoutAnalyzer({
    this.maxHistorySize = 1000,
    this.analysisWindow = const Duration(hours: 24),
    this.minOperationsForRecommendation = 10,
  });

  final int maxHistorySize;
  final Duration analysisWindow;
  final int minOperationsForRecommendation;

  final Queue<TimeoutOperation> _operationHistory = Queue<TimeoutOperation>();
  Timer? _cleanupTimer;

  static const Duration _cleanupInterval = Duration(minutes: 15);

  /// Record a timeout operation result
  void recordOperation(TimeoutOperation operation) {
    _operationHistory.add(operation);
    
    // Enforce memory bounds using LRU eviction
    while (_operationHistory.length > maxHistorySize) {
      _operationHistory.removeFirst();
    }

    _scheduleCleanup();
  }

  /// Schedule periodic cleanup of stale operations
  void _scheduleCleanup() {
    _cleanupTimer ??= Timer.periodic(_cleanupInterval, (_) => _cleanupStaleOperations());
  }

  /// Remove operations outside the analysis window
  void _cleanupStaleOperations() {
    final cutoff = DateTime.now().subtract(analysisWindow);
    _operationHistory.removeWhere((op) => op.timestamp.isBefore(cutoff));
  }

  /// Get operations for a specific method within the analysis window
  List<TimeoutOperation> _getRecentOperations(String method) {
    final cutoff = DateTime.now().subtract(analysisWindow);
    return _operationHistory
        .where((op) => op.method == method && op.timestamp.isAfter(cutoff))
        .toList();
  }

  /// Analyze timeout patterns for a specific method
  TimeoutAnalysis? analyzeMethod(String method, Duration currentTimeout) {
    final operations = _getRecentOperations(method);
    
    if (operations.length < minOperationsForRecommendation) {
      return null; // Insufficient data
    }

    final successfulOps = operations.where((op) => op.success).toList();
    final successRate = successfulOps.length / operations.length;
    
    if (successfulOps.isEmpty) {
      // All operations failed - recommend longer timeout
      return TimeoutAnalysis(
        method: method,
        totalOperations: operations.length,
        successRate: successRate,
        averageEfficiency: 0.0,
        recommendedTimeout: Duration(
          milliseconds: (currentTimeout.inMilliseconds * 1.5).round(),
        ),
        confidence: 0.8,
        currentTimeout: currentTimeout,
      );
    }

    final averageEfficiency = successfulOps
        .map((op) => op.efficiencyScore)
        .reduce((a, b) => a + b) / successfulOps.length;

    // Calculate percentiles for timeout recommendation
    final sortedDurations = successfulOps
        .map((op) => op.actualDuration.inMilliseconds)
        .toList()..sort();
    
    final p95Index = (sortedDurations.length * 0.95).ceil() - 1;
    final p95Duration = sortedDurations[p95Index.clamp(0, sortedDurations.length - 1)];
    
    // Add 20% buffer to P95 for recommended timeout
    final recommendedMs = (p95Duration * 1.2).round();
    final recommendedTimeout = Duration(milliseconds: recommendedMs);

    // Calculate confidence based on sample size and consistency
    final sampleSizeScore = min(operations.length / 50.0, 1.0); // Max at 50 operations
    final consistencyScore = 1.0 - _calculateVariabilityScore(sortedDurations);
    final successRateScore = successRate;
    
    final confidence = (sampleSizeScore + consistencyScore + successRateScore) / 3.0;

    return TimeoutAnalysis(
      method: method,
      totalOperations: operations.length,
      successRate: successRate,
      averageEfficiency: averageEfficiency,
      recommendedTimeout: recommendedTimeout,
      confidence: confidence,
      currentTimeout: currentTimeout,
    );
  }

  /// Calculate variability score (higher = more variable, lower confidence)
  double _calculateVariabilityScore(List<int> sortedValues) {
    if (sortedValues.length < 2) return 0.0;
    
    final mean = sortedValues.reduce((a, b) => a + b) / sortedValues.length;
    final variance = sortedValues
        .map((v) => pow(v - mean, 2))
        .reduce((a, b) => a + b) / sortedValues.length;
    final stdDev = sqrt(variance);
    
    // Normalize by mean to get coefficient of variation
    return min(stdDev / mean, 1.0);
  }

  /// Get analysis for all methods with sufficient data
  Map<String, TimeoutAnalysis> analyzeAllMethods(Map<String, Duration> currentTimeouts) {
    final results = <String, TimeoutAnalysis>{};
    
    // Group operations by method
    final methodGroups = <String, List<TimeoutOperation>>{};
    for (final op in _operationHistory) {
      methodGroups.putIfAbsent(op.method, () => []).add(op);
    }

    // Analyze each method that has current timeout configuration
    for (final entry in currentTimeouts.entries) {
      final analysis = analyzeMethod(entry.key, entry.value);
      if (analysis != null) {
        results[entry.key] = analysis;
      }
    }

    return results;
  }

  /// Get timeout recommendations prioritized by urgency
  List<TimeoutAnalysis> getTopRecommendations(
    Map<String, Duration> currentTimeouts, {
    int limit = 5,
  }) {
    final analyses = analyzeAllMethods(currentTimeouts).values.toList();
    
    // Sort by priority: high > medium > low, then by confidence
    analyses.sort((a, b) {
      final priorityOrder = {"high": 3, "medium": 2, "low": 1, "none": 0};
      final aPriority = priorityOrder[a.adjustmentPriority] ?? 0;
      final bPriority = priorityOrder[b.adjustmentPriority] ?? 0;
      
      if (aPriority != bPriority) return bPriority.compareTo(aPriority);
      return b.confidence.compareTo(a.confidence);
    });

    return analyses
        .where((analysis) => analysis.shouldAdjust)
        .take(limit)
        .toList();
  }

  /// Export historical data for external analysis
  Map<String, dynamic> exportHistoricalData() {
    return {
      "analysis_window_hours": analysisWindow.inHours,
      "total_operations": _operationHistory.length,
      "operations": _operationHistory.map((op) => op.toJson()).toList(),
      "export_timestamp": DateTime.now().toIso8601String(),
    };
  }

  /// Get diagnostic information about the analyzer state
  Map<String, dynamic> getDiagnostics() {
    final now = DateTime.now();
    final cutoff = now.subtract(analysisWindow);
    final recentOps = _operationHistory.where((op) => op.timestamp.isAfter(cutoff)).length;
    
    final methodCounts = <String, int>{};
    for (final op in _operationHistory) {
      methodCounts[op.method] = (methodCounts[op.method] ?? 0) + 1;
    }

    return {
      "total_operations": _operationHistory.length,
      "recent_operations": recentOps,
      "analysis_window_hours": analysisWindow.inHours,
      "min_operations_for_recommendation": minOperationsForRecommendation,
      "method_counts": methodCounts,
      "oldest_operation": _operationHistory.isEmpty ? null : _operationHistory.first.timestamp.toIso8601String(),
      "newest_operation": _operationHistory.isEmpty ? null : _operationHistory.last.timestamp.toIso8601String(),
    };
  }

  /// Clear all historical data
  void clearHistory() {
    _operationHistory.clear();
  }

  /// Dispose of resources
  void dispose() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }
}