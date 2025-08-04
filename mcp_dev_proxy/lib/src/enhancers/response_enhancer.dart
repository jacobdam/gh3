import "../../mcp_protocol.dart";
import "enhanced_error_context.dart";
import "error_context.dart";
import "error_pattern_analyzer.dart";

abstract class ErrorEnhancer {
  bool canHandle(ErrorType errorType, ErrorContext context);
  Map<String, dynamic> enhance(
    Map<String, dynamic> error,
    ErrorContext context,
  );
}

enum ErrorType {
  serverCrash,
  serverRestart,
  timeout,
  connectionFailed,
  invalidResponse,
  toolInterrupted,
  serverUnavailable,
}

class ResponseEnhancer {
  ResponseEnhancer({
    bool enablePatternAnalysis = true,
  }) : _patternAnalyzer = enablePatternAnalysis ? ErrorPatternAnalyzer() : null;

  final List<ErrorEnhancer> _enhancers = [];
  final ErrorPatternAnalyzer? _patternAnalyzer;

  void addEnhancer(ErrorEnhancer enhancer) {
    _enhancers.add(enhancer);
  }

  MCPMessage enhanceResponse(
    MCPMessage message, {
    String? proxyEvent,
    String? reason,
  }) {
    return message.withProxyMetadata(
      proxyEvent: proxyEvent,
      reason: reason,
    );
  }

  MCPError enhanceError(
    ErrorType errorType,
    String message,
    ErrorContext context, {
    int? code,
    Map<String, dynamic>? data,
  }) {
    var errorData = data ?? <String, dynamic>{};

    // Apply enhancers
    for (final enhancer in _enhancers) {
      if (enhancer.canHandle(errorType, context)) {
        final enhanced = enhancer.enhance(
          {
            "code": code ?? _getDefaultCode(errorType),
            "message": message,
            "data": errorData,
          },
          context,
        );

        errorData = enhanced["data"] as Map<String, dynamic>? ?? errorData;
      }
    }

    return MCPError(
      code: code ?? _getDefaultCode(errorType),
      message: message,
      data: errorData,
    );
  }

  MCPError createServerCrashError(int exitCode, String? stderr) {
    return MCPError.serverCrash(exitCode, stderr ?? "");
  }

  MCPError createServerRestartError(String reason) {
    return MCPError.serverRestart(reason);
  }

  MCPError createTimeoutError(String operation, Duration timeout) {
    return MCPError(
      code: -32603,
      message: "Operation timed out",
      data: {
        "operation": operation,
        "timeout_ms": timeout.inMilliseconds,
        "proxy": "mcp_dev_proxy",
        "recovery_hint":
            "Check if the target server is responding or increase timeout",
      },
    );
  }

  MCPError createToolInterruptedError(String toolUseId, String reason) {
    return MCPError(
      code: -32603,
      message: "Tool execution interrupted by server restart",
      data: {
        "tool_use_id": toolUseId,
        "reason": reason,
        "proxy": "mcp_dev_proxy",
        "recovery_hint":
            "Use /resume command to start a fresh session without incomplete tool cycles",
      },
    );
  }

  MCPError createServerUnavailableError(
    ErrorContext context, {
    Map<String, dynamic>? additionalData,
  }) {
    final binaryExists = context.environment?["binaryExists"] == "true";
    final startupError = context.lastOutput;

    String message;
    String actionNeeded;

    if (!binaryExists) {
      message = "MCP server binary not found";
      actionNeeded =
          "Compile your MCP server binary and the proxy will handle the rest";
    } else if (startupError != null && startupError.isNotEmpty) {
      message = "Target MCP server failed to start";
      actionNeeded =
          "Check if binary is executable and implements MCP protocol";
    } else {
      message = "Target MCP server is not running";
      actionNeeded = "Check if your MCP server process crashed";
    }

    final data = <String, dynamic>{
      "proxy": "mcp_dev_proxy",
      "target_binary": context.targetCommand ?? "unknown",
      "message": message,
      "action_needed": actionNeeded,
      "status": binaryExists ? "binary_exists" : "binary_missing",
      "proxy_capabilities": [
        "crash_recovery",
        "hot_reload",
        "error_buffering",
        "debug_info",
      ],
    };

    if (startupError != null && startupError.isNotEmpty) {
      data["startup_error"] = startupError;
    }

    if (additionalData != null) {
      data.addAll(additionalData);
    }

    return MCPError(
      code: -32603,
      message: message,
      data: data,
    );
  }

  /// Create enhanced error with automatic classification and pattern analysis
  MCPError createEnhancedError(
    dynamic error,
    String operation, {
    String? correlationId,
    Map<String, dynamic>? context,
    ErrorContext? baseContext,
  }) {
    final enhancedContext = EnhancedErrorContext.classify(
      error,
      operation,
      context,
    );

    // Create enhanced context with correlation ID
    final contextWithCorrelation = enhancedContext.copyWith(
      correlationId: correlationId,
    );

    // Include base context if provided
    EnhancedErrorContext finalContext;
    if (baseContext != null) {
      finalContext = contextWithCorrelation.copyWith(
        detectedRuntime: baseContext.detectedRuntime,
        targetCommand: baseContext.targetCommand,
        environment: baseContext.environment,
        workingDirectory: baseContext.workingDirectory,
        lastOutput: baseContext.lastOutput,
      );
    } else {
      finalContext = contextWithCorrelation;
    }

    // Record error for pattern analysis
    _recordErrorForPatternAnalysis(finalContext);

    return _createErrorFromEnhancedContext(finalContext);
  }

  /// Create MCP error from enhanced context
  MCPError _createErrorFromEnhancedContext(EnhancedErrorContext context) {
    final structuredLog = context.toStructuredLog();
    final errorData = <String, dynamic>{
      "proxy": "mcp_dev_proxy",
      "enhanced_error": structuredLog,
      "severity": context.severity.name,
      "category": context.category.name,
      "operation": context.operation,
      "recovery_suggestions": context.recoverySuggestions,
      "is_retryable": context.isRetryable(),
      "retry_delay_seconds": context.getRecommendedRetryDelay()?.inSeconds,
      if (context.correlationId != null)
        "correlation_id": context.correlationId,
    };

    // Add pattern analysis data if available
    if (_patternAnalyzer != null) {
      final occurrence = _createErrorOccurrence(context);
      final pattern = _patternAnalyzer!.analyzeSignature(occurrence.signature);
      
      if (pattern != null) {
        errorData["pattern_analysis"] = {
          "signature": pattern.signature,
          "frequency": pattern.frequency,
          "trend": pattern.trend,
          "priority": pattern.priority,
          "is_systemic": pattern.isSystemic,
          "occurrences": pattern.occurrences,
        };
        
        // Add pattern-based recovery suggestions
        final patternSuggestions = _patternAnalyzer!.generateRecoverySuggestions(pattern);
        if (patternSuggestions.isNotEmpty) {
          errorData["pattern_recovery_suggestions"] = patternSuggestions
              .map((s) => s.toJson())
              .toList();
        }
      }
    }

    return MCPError(
      code: _getCodeForCategory(context.category),
      message: context.errorMessage,
      data: errorData,
    );
  }

  /// Get appropriate error code for category
  int _getCodeForCategory(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.network:
        return -32300; // Transport error
      case ErrorCategory.protocol:
        return -32700; // Parse error
      case ErrorCategory.application:
        return -32601; // Method not found
      case ErrorCategory.system:
        return -32603; // Internal error
      case ErrorCategory.user:
        return -32602; // Invalid params
      case ErrorCategory.unknown:
        return -32603; // Internal error
    }
  }

  int _getDefaultCode(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.serverCrash:
      case ErrorType.serverRestart:
      case ErrorType.timeout:
      case ErrorType.toolInterrupted:
      case ErrorType.serverUnavailable:
        return -32603; // Internal error
      case ErrorType.connectionFailed:
        return -32002; // Invalid params (connection not available)
      case ErrorType.invalidResponse:
        return -32700; // Parse error
    }
  }

  /// Record error for pattern analysis
  void _recordErrorForPatternAnalysis(EnhancedErrorContext context) {
    if (_patternAnalyzer == null) return;

    final occurrence = _createErrorOccurrence(context);
    _patternAnalyzer!.recordError(occurrence);
  }

  /// Create ErrorOccurrence from EnhancedErrorContext
  ErrorOccurrence _createErrorOccurrence(EnhancedErrorContext context) {
    return ErrorOccurrence(
      timestamp: DateTime.now(),
      errorType: context.category.name,
      message: context.errorMessage,
      operation: context.operation,
      severity: context.severity,
      category: context.category,
      correlationId: context.correlationId,
      additionalContext: {
        if (context.targetCommand != null) "target_command": context.targetCommand!,
        if (context.detectedRuntime != null) "detected_runtime": context.detectedRuntime!,
        if (context.workingDirectory != null) "working_directory": context.workingDirectory!,
        if (context.lastOutput != null) "last_output": context.lastOutput!,
        if (context.environment != null) ...context.environment!,
      },
    );
  }

  /// Get error patterns from the analyzer
  List<ErrorPattern> getErrorPatterns() {
    return _patternAnalyzer?.getAllPatterns() ?? [];
  }

  /// Get pattern analysis for a specific signature
  ErrorPattern? analyzeErrorSignature(String signature) {
    return _patternAnalyzer?.analyzeSignature(signature);
  }

  /// Get recovery suggestions for a pattern
  List<RecoverySuggestion> getRecoverySuggestions(ErrorPattern pattern) {
    return _patternAnalyzer?.generateRecoverySuggestions(pattern) ?? [];
  }

  /// Export error analytics data
  Map<String, dynamic> exportErrorAnalytics() {
    return _patternAnalyzer?.exportAnalytics() ?? {
      "pattern_analysis_disabled": true,
      "export_timestamp": DateTime.now().toIso8601String(),
    };
  }

  /// Get error analysis diagnostics
  Map<String, dynamic> getErrorAnalysisDiagnostics() {
    if (_patternAnalyzer == null) {
      return {
        "pattern_analysis_enabled": false,
        "status": "disabled",
      };
    }

    final diagnostics = _patternAnalyzer!.getDiagnostics();
    return {
      "pattern_analysis_enabled": true,
      "status": "active",
      ...diagnostics,
    };
  }

  /// Clear error pattern history
  void clearErrorHistory() {
    _patternAnalyzer?.clearHistory();
  }

  /// Dispose of resources
  void dispose() {
    _patternAnalyzer?.dispose();
  }
}
