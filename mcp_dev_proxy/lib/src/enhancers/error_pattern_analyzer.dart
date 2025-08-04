import "dart:async";
import "dart:collection";
import "dart:math";

import "enhanced_error_context.dart";
import "error_context.dart";

/// Represents an error occurrence for pattern analysis
class ErrorOccurrence {
  const ErrorOccurrence({
    required this.timestamp,
    required this.errorType,
    required this.message,
    required this.operation,
    required this.severity,
    required this.category,
    this.correlationId,
    this.additionalContext = const {},
  });

  final DateTime timestamp;
  final String errorType;
  final String message;
  final String operation;
  final ErrorSeverity severity;
  final ErrorCategory category;
  final String? correlationId;
  final Map<String, dynamic> additionalContext;

  /// Generate a signature for pattern matching
  String get signature => "${errorType}:${operation}:${_normalizeMessage(message)}";

  /// Normalize error message for pattern matching
  String _normalizeMessage(String msg) {
    // Remove specific identifiers like IDs, timestamps, file paths
    return msg
        .replaceAll(RegExp(r'\b\d+\b'), '<NUM>')
        .replaceAll(RegExp(r'\b[a-fA-F0-9]{8,}\b'), '<ID>')
        .replaceAll(RegExp(r'/[^\s]+'), '<PATH>')
        .toLowerCase()
        .trim();
  }

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp.toIso8601String(),
    "error_type": errorType,
    "message": message,
    "operation": operation,
    "severity": severity.name,
    "category": category.name,
    "correlation_id": correlationId,
    "additional_context": additionalContext,
    "signature": signature,
  };
}

/// Pattern analysis results for a specific error signature
class ErrorPattern {
  const ErrorPattern({
    required this.signature,
    required this.occurrences,
    required this.frequency,
    required this.averageInterval,
    required this.severity,
    required this.category,
    required this.operations,
    required this.firstSeen,
    required this.lastSeen,
    required this.trend,
  });

  final String signature;
  final int occurrences;
  final double frequency; // Occurrences per hour
  final Duration averageInterval;
  final ErrorSeverity severity;
  final ErrorCategory category;
  final Set<String> operations;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final String trend; // "increasing", "stable", "decreasing"

  /// Priority level for this error pattern
  String get priority {
    if (severity == ErrorSeverity.critical) return "critical";
    if (frequency > 10 && trend == "increasing") return "high";
    if (frequency > 5 || severity == ErrorSeverity.error) return "medium";
    return "low";
  }

  /// Whether this pattern suggests a systemic issue
  bool get isSystemic => occurrences >= 5 && averageInterval.inMinutes < 60;

  Map<String, dynamic> toJson() => {
    "signature": signature,
    "occurrences": occurrences,
    "frequency": frequency,
    "average_interval_minutes": averageInterval.inMinutes,
    "severity": severity.name,
    "category": category.name,
    "operations": operations.toList(),
    "first_seen": firstSeen.toIso8601String(),
    "last_seen": lastSeen.toIso8601String(),
    "trend": trend,
    "priority": priority,
    "is_systemic": isSystemic,
  };
}

/// Recovery suggestion based on error patterns
class RecoverySuggestion {
  const RecoverySuggestion({
    required this.title,
    required this.description,
    required this.steps,
    required this.confidence,
    this.estimatedTime,
    this.requiresRestart = false,
  });

  final String title;
  final String description;
  final List<String> steps;
  final double confidence; // 0.0-1.0
  final String? estimatedTime;
  final bool requiresRestart;

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "steps": steps,
    "confidence": confidence,
    "estimated_time": estimatedTime,
    "requires_restart": requiresRestart,
  };
}

/// Analyzes error patterns and provides intelligent categorization and recovery guidance
class ErrorPatternAnalyzer {
  ErrorPatternAnalyzer({
    this.maxHistorySize = 1000,
    this.analysisWindow = const Duration(hours: 24),
    this.minOccurrencesForPattern = 3,
  });

  final int maxHistorySize;
  final Duration analysisWindow;
  final int minOccurrencesForPattern;

  final Queue<ErrorOccurrence> _errorHistory = Queue<ErrorOccurrence>();
  final Map<String, List<ErrorOccurrence>> _patternCache = {};
  Timer? _cleanupTimer;

  static const Duration _cleanupInterval = Duration(minutes: 30);
  static const Duration _cacheRefreshInterval = Duration(minutes: 5);

  /// Record an error occurrence for pattern analysis
  void recordError(ErrorOccurrence error) {
    _errorHistory.add(error);
    
    // Enforce memory bounds using LRU eviction
    while (_errorHistory.length > maxHistorySize) {
      _errorHistory.removeFirst();
    }

    // Invalidate pattern cache for this signature
    _patternCache.remove(error.signature);
    
    _scheduleCleanup();
  }

  /// Schedule periodic cleanup of stale errors
  void _scheduleCleanup() {
    _cleanupTimer ??= Timer.periodic(_cleanupInterval, (_) => _cleanupStaleErrors());
  }

  /// Remove errors outside the analysis window
  void _cleanupStaleErrors() {
    final cutoff = DateTime.now().subtract(analysisWindow);
    _errorHistory.removeWhere((error) => error.timestamp.isBefore(cutoff));
    
    // Clear pattern cache to force refresh
    _patternCache.clear();
  }

  /// Get recent errors within the analysis window
  List<ErrorOccurrence> _getRecentErrors() {
    final cutoff = DateTime.now().subtract(analysisWindow);
    return _errorHistory.where((error) => error.timestamp.isAfter(cutoff)).toList();
  }

  /// Analyze patterns for a specific error signature
  ErrorPattern? analyzeSignature(String signature) {
    // Check cache first
    if (_patternCache.containsKey(signature)) {
      final cached = _patternCache[signature]!;
      if (cached.length >= minOccurrencesForPattern) {
        return _buildPatternFromOccurrences(signature, cached);
      }
    }

    final recentErrors = _getRecentErrors();
    final signatureErrors = recentErrors.where((e) => e.signature == signature).toList();
    
    if (signatureErrors.length < minOccurrencesForPattern) {
      return null; // Insufficient data
    }

    // Cache the results
    _patternCache[signature] = signatureErrors;
    
    return _buildPatternFromOccurrences(signature, signatureErrors);
  }

  /// Build an ErrorPattern from occurrences
  ErrorPattern _buildPatternFromOccurrences(String signature, List<ErrorOccurrence> occurrences) {
    occurrences.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    final firstSeen = occurrences.first.timestamp;
    final lastSeen = occurrences.last.timestamp;
    final timeSpan = lastSeen.difference(firstSeen);
    
    // Calculate frequency (occurrences per hour)
    final frequency = timeSpan.inMilliseconds > 0 
        ? (occurrences.length / timeSpan.inHours).clamp(0.0, double.infinity)
        : 0.0;

    // Calculate average interval between occurrences
    final intervals = <Duration>[];
    for (int i = 1; i < occurrences.length; i++) {
      intervals.add(occurrences[i].timestamp.difference(occurrences[i - 1].timestamp));
    }
    final averageInterval = intervals.isEmpty 
        ? Duration.zero
        : Duration(milliseconds: 
            intervals.map((d) => d.inMilliseconds).reduce((a, b) => a + b) ~/ intervals.length);

    // Determine trend (simple analysis based on recent vs older occurrences)
    final trend = _calculateTrend(occurrences);

    // Get the most common severity and category
    final severityCount = <ErrorSeverity, int>{};
    final categoryCount = <ErrorCategory, int>{};
    final operations = <String>{};

    for (final error in occurrences) {
      severityCount[error.severity] = (severityCount[error.severity] ?? 0) + 1;
      categoryCount[error.category] = (categoryCount[error.category] ?? 0) + 1;
      operations.add(error.operation);
    }

    final mostCommonSeverity = severityCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    final mostCommonCategory = categoryCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return ErrorPattern(
      signature: signature,
      occurrences: occurrences.length,
      frequency: frequency,
      averageInterval: averageInterval,
      severity: mostCommonSeverity,
      category: mostCommonCategory,
      operations: operations,
      firstSeen: firstSeen,
      lastSeen: lastSeen,
      trend: trend,
    );
  }

  /// Calculate trend based on error distribution over time
  String _calculateTrend(List<ErrorOccurrence> occurrences) {
    if (occurrences.length < 4) return "stable";
    
    final now = DateTime.now();
    final halfWindow = analysisWindow.inMilliseconds ~/ 2;
    final midpoint = now.subtract(Duration(milliseconds: halfWindow));
    
    final recentCount = occurrences.where((e) => e.timestamp.isAfter(midpoint)).length;
    final olderCount = occurrences.where((e) => e.timestamp.isBefore(midpoint)).length;
    
    if (recentCount > olderCount * 1.5) return "increasing";
    if (olderCount > recentCount * 1.5) return "decreasing";
    return "stable";
  }

  /// Get all error patterns with sufficient data
  List<ErrorPattern> getAllPatterns() {
    final recentErrors = _getRecentErrors();
    final signatureGroups = <String, List<ErrorOccurrence>>{};
    
    // Group errors by signature
    for (final error in recentErrors) {
      signatureGroups.putIfAbsent(error.signature, () => []).add(error);
    }

    final patterns = <ErrorPattern>[];
    for (final entry in signatureGroups.entries) {
      if (entry.value.length >= minOccurrencesForPattern) {
        final pattern = _buildPatternFromOccurrences(entry.key, entry.value);
        patterns.add(pattern);
      }
    }

    // Sort by priority and frequency
    patterns.sort((a, b) {
      final priorityOrder = {"critical": 4, "high": 3, "medium": 2, "low": 1};
      final aPriority = priorityOrder[a.priority] ?? 0;
      final bPriority = priorityOrder[b.priority] ?? 0;
      
      if (aPriority != bPriority) return bPriority.compareTo(aPriority);
      return b.frequency.compareTo(a.frequency);
    });

    return patterns;
  }

  /// Generate recovery suggestions for an error pattern
  List<RecoverySuggestion> generateRecoverySuggestions(ErrorPattern pattern) {
    final suggestions = <RecoverySuggestion>[];

    // Base suggestions on error category and severity
    switch (pattern.category) {
      case ErrorCategory.network:
        suggestions.addAll(_getNetworkRecoverySuggestions(pattern));
        break;
      case ErrorCategory.protocol:
        suggestions.addAll(_getProtocolRecoverySuggestions(pattern));
        break;
      case ErrorCategory.application:
        suggestions.addAll(_getApplicationRecoverySuggestions(pattern));
        break;
      case ErrorCategory.system:
        suggestions.addAll(_getSystemRecoverySuggestions(pattern));
        break;
      case ErrorCategory.user:
        suggestions.addAll(_getUserRecoverySuggestions(pattern));
        break;
      case ErrorCategory.unknown:
        suggestions.addAll(_getGenericRecoverySuggestions(pattern));
        break;
    }

    // Add systemic issue suggestions if applicable
    if (pattern.isSystemic) {
      suggestions.addAll(_getSystemicRecoverySuggestions(pattern));
    }

    return suggestions;
  }

  /// Network-specific recovery suggestions
  List<RecoverySuggestion> _getNetworkRecoverySuggestions(ErrorPattern pattern) {
    return [
      const RecoverySuggestion(
        title: "Check Network Connectivity",
        description: "Verify network connection and DNS resolution",
        steps: [
          "Test network connectivity to target server",
          "Verify DNS resolution is working",
          "Check for firewall or proxy issues",
          "Test with different network connection if available",
        ],
        confidence: 0.8,
        estimatedTime: "2-5 minutes",
      ),
      const RecoverySuggestion(
        title: "Increase Timeout Values",
        description: "Network issues may require longer timeout periods",
        steps: [
          "Review current timeout configuration",
          "Consider increasing timeout values for network operations",
          "Monitor error patterns after timeout adjustment",
        ],
        confidence: 0.7,
        estimatedTime: "1-2 minutes",
      ),
    ];
  }

  /// Protocol-specific recovery suggestions
  List<RecoverySuggestion> _getProtocolRecoverySuggestions(ErrorPattern pattern) {
    return [
      const RecoverySuggestion(
        title: "Verify Protocol Compatibility",
        description: "Check MCP protocol version and message format compatibility",
        steps: [
          "Verify MCP server supports the required protocol version",
          "Check message format and structure",
          "Review server logs for protocol-specific errors",
          "Test with a minimal MCP client to isolate issues",
        ],
        confidence: 0.8,
        estimatedTime: "3-5 minutes",
      ),
    ];
  }

  /// Application-specific recovery suggestions
  List<RecoverySuggestion> _getApplicationRecoverySuggestions(ErrorPattern pattern) {
    return [
      const RecoverySuggestion(
        title: "Review Application Configuration",
        description: "Check application settings and method availability",
        steps: [
          "Verify the requested method is available on the server",
          "Check application configuration and settings",
          "Review server logs for application-specific errors",
          "Test with different parameters if applicable",
        ],
        confidence: 0.7,
        estimatedTime: "2-4 minutes",
      ),
    ];
  }

  /// System-specific recovery suggestions  
  List<RecoverySuggestion> _getSystemRecoverySuggestions(ErrorPattern pattern) {
    return [
      const RecoverySuggestion(
        title: "Check System Resources",
        description: "Verify system has sufficient resources and permissions",
        steps: [
          "Check available memory and CPU usage",
          "Verify file permissions and access rights",
          "Check disk space availability",
          "Review system logs for resource issues",
        ],
        confidence: 0.8,
        estimatedTime: "2-3 minutes",
      ),
      RecoverySuggestion(
        title: "Restart Target Process",
        description: "System issues may require process restart",
        steps: const [
          "Stop the target MCP server process",
          "Wait 2-3 seconds for cleanup",
          "Restart the target process",
          "Monitor for continued issues",
        ],
        confidence: 0.6,
        estimatedTime: "1-2 minutes",
        requiresRestart: true,
      ),
    ];
  }

  /// User-specific recovery suggestions
  List<RecoverySuggestion> _getUserRecoverySuggestions(ErrorPattern pattern) {
    return [
      const RecoverySuggestion(
        title: "Validate Input Parameters",
        description: "Check input validation and parameter formatting",
        steps: [
          "Review the parameters being sent to the server",
          "Verify parameter types and formats match expectations",
          "Check for required parameters that may be missing",
          "Test with known good parameters",
        ],
        confidence: 0.8,
        estimatedTime: "1-3 minutes",
      ),
    ];
  }

  /// Generic recovery suggestions for unknown error types
  List<RecoverySuggestion> _getGenericRecoverySuggestions(ErrorPattern pattern) {
    return [
      const RecoverySuggestion(
        title: "Enable Debug Logging",
        description: "Increase logging verbosity to gather more information",
        steps: [
          "Enable debug or verbose logging",
          "Reproduce the error condition",
          "Review detailed logs for additional context",
          "Look for patterns in the error messages",
        ],
        confidence: 0.6,
        estimatedTime: "2-5 minutes",
      ),
    ];
  }

  /// Systemic issue recovery suggestions
  List<RecoverySuggestion> _getSystemicRecoverySuggestions(ErrorPattern pattern) {
    return [
      const RecoverySuggestion(
        title: "Investigate Systemic Issue",
        description: "Frequent errors suggest a deeper system problem",
        steps: [
          "Review system health and resource utilization",
          "Check for recent configuration changes",
          "Analyze error patterns across different operations",
          "Consider temporary rate limiting or circuit breaker patterns",
        ],
        confidence: 0.9,
        estimatedTime: "5-10 minutes",
      ),
    ];
  }

  /// Export error analytics data
  Map<String, dynamic> exportAnalytics() {
    final patterns = getAllPatterns();
    final recentErrors = _getRecentErrors();
    
    return {
      "analysis_window_hours": analysisWindow.inHours,
      "total_errors": recentErrors.length,
      "unique_patterns": patterns.length,
      "patterns": patterns.map((p) => p.toJson()).toList(),
      "error_distribution": _calculateErrorDistribution(recentErrors),
      "export_timestamp": DateTime.now().toIso8601String(),
    };
  }

  /// Calculate error distribution by category and severity
  Map<String, dynamic> _calculateErrorDistribution(List<ErrorOccurrence> errors) {
    final categoryCount = <String, int>{};
    final severityCount = <String, int>{};
    final operationCount = <String, int>{};

    for (final error in errors) {
      categoryCount[error.category.name] = (categoryCount[error.category.name] ?? 0) + 1;
      severityCount[error.severity.name] = (severityCount[error.severity.name] ?? 0) + 1;
      operationCount[error.operation] = (operationCount[error.operation] ?? 0) + 1;
    }

    return {
      "by_category": categoryCount,
      "by_severity": severityCount,
      "by_operation": operationCount,
    };
  }

  /// Get diagnostic information about the analyzer state
  Map<String, dynamic> getDiagnostics() {
    final recentErrors = _getRecentErrors();
    final patterns = getAllPatterns();
    
    return {
      "total_errors": _errorHistory.length,
      "recent_errors": recentErrors.length,
      "analysis_window_hours": analysisWindow.inHours,
      "min_occurrences_for_pattern": minOccurrencesForPattern,
      "identified_patterns": patterns.length,
      "cache_size": _patternCache.length,
      "high_priority_patterns": patterns.where((p) => p.priority == "high" || p.priority == "critical").length,
    };
  }

  /// Clear all historical data
  void clearHistory() {
    _errorHistory.clear();
    _patternCache.clear();
  }

  /// Dispose of resources
  void dispose() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }
}