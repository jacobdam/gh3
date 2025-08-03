import "dart:async";
import "dart:io";

import "error_context.dart";

/// Error severity levels for classification
enum ErrorSeverity {
  critical, // System cannot continue
  error, // Operation failed but system stable
  warning, // Potential issue detected
  info, // Informational error context
}

/// Error categories for classification
enum ErrorCategory {
  network, // Connection, timeout, DNS issues
  protocol, // JSON-RPC, formatting, version issues
  application, // Business logic, method not found
  system, // Resource, permission, OS issues
  user, // Invalid input, authentication
  unknown, // Unclassified errors
}

/// Enhanced error context with classification, severity, and recovery guidance
class EnhancedErrorContext extends ErrorContext {
  EnhancedErrorContext({
    required this.severity,
    required this.category,
    required this.operation,
    required this.errorMessage,
    this.correlationId,
    this.debugInfo = const {},
    this.recoverySuggestions = const [],
    this.stackTrace,
    super.detectedRuntime,
    super.targetCommand,
    super.environment,
    super.workingDirectory,
    super.lastOutput,
    super.timestamp,
  });

  final ErrorSeverity severity;
  final ErrorCategory category;
  final String operation;
  final String errorMessage;
  final String? correlationId;
  final Map<String, dynamic> debugInfo;
  final List<String> recoverySuggestions;
  final String? stackTrace;

  /// Classify an error and create enhanced context
  static EnhancedErrorContext classify(
    dynamic error,
    String operation, [
    Map<String, dynamic>? context,
  ]) {
    final category = ErrorClassifier.categorizeError(error);
    final severity = ErrorClassifier.determineSeverity(category, error);
    final suggestions =
        ErrorClassifier.generateRecoverySuggestions(category, error);

    return EnhancedErrorContext(
      severity: severity,
      category: category,
      operation: operation,
      errorMessage: error?.toString() ?? "Unknown error",
      debugInfo: context ?? {},
      recoverySuggestions: suggestions,
      stackTrace: error is Error ? error.stackTrace?.toString() : null,
    );
  }

  /// Determine if error is retryable
  bool isRetryable() {
    switch (category) {
      case ErrorCategory.network:
        return true; // Network issues are often transient
      case ErrorCategory.system:
        return severity !=
            ErrorSeverity.critical; // Some system errors are retryable
      case ErrorCategory.protocol:
        return false; // Protocol errors usually require fixes
      case ErrorCategory.application:
        return false; // Application logic errors need fixes
      case ErrorCategory.user:
        return false; // User errors need input correction
      case ErrorCategory.unknown:
        return false; // Unknown errors are risky to retry
    }
  }

  /// Get recommended retry delay for retryable errors
  Duration? getRecommendedRetryDelay() {
    if (!isRetryable()) return null;

    switch (category) {
      case ErrorCategory.network:
        switch (severity) {
          case ErrorSeverity.critical:
            return const Duration(seconds: 30);
          case ErrorSeverity.error:
            return const Duration(seconds: 5);
          case ErrorSeverity.warning:
            return const Duration(seconds: 2);
          case ErrorSeverity.info:
            return const Duration(seconds: 1);
        }
      case ErrorCategory.system:
        return const Duration(seconds: 10); // System errors need more time
      default:
        return null;
    }
  }

  @override
  EnhancedErrorContext copyWith({
    ErrorSeverity? severity,
    ErrorCategory? category,
    String? operation,
    String? errorMessage,
    String? correlationId,
    Map<String, dynamic>? debugInfo,
    List<String>? recoverySuggestions,
    String? stackTrace,
    String? detectedRuntime,
    String? targetCommand,
    Map<String, String>? environment,
    String? workingDirectory,
    String? lastOutput,
    DateTime? timestamp,
  }) {
    return EnhancedErrorContext(
      severity: severity ?? this.severity,
      category: category ?? this.category,
      operation: operation ?? this.operation,
      errorMessage: errorMessage ?? this.errorMessage,
      correlationId: correlationId ?? this.correlationId,
      debugInfo: debugInfo ?? this.debugInfo,
      recoverySuggestions: recoverySuggestions ?? this.recoverySuggestions,
      stackTrace: stackTrace ?? this.stackTrace,
      detectedRuntime: detectedRuntime ?? this.detectedRuntime,
      targetCommand: targetCommand ?? this.targetCommand,
      environment: environment ?? this.environment,
      workingDirectory: workingDirectory ?? this.workingDirectory,
      lastOutput: lastOutput ?? this.lastOutput,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      "severity": severity.name,
      "category": category.name,
      "operation": operation,
      "error_message": errorMessage,
      "correlation_id": correlationId,
      "debug_info": debugInfo,
      "recovery_suggestions": recoverySuggestions,
      "stack_trace": stackTrace,
    };
  }

  /// Enhanced structured log that includes base context information
  @override
  Map<String, dynamic> toStructuredLog() {
    final baseLog = super.toStructuredLog();
    return {
      ...baseLog,
      "timestamp": timestamp.toIso8601String(),
      "severity": severity.name,
      "category": category.name,
      "operation": operation,
      "correlation_id": correlationId,
      "error_message": errorMessage,
      "debug_info": debugInfo,
      "recovery_suggestions": recoverySuggestions,
      "is_retryable": isRetryable(),
      "retry_delay": getRecommendedRetryDelay()?.inSeconds,
      "stack_trace": stackTrace,
    };
  }
}

/// Error classification utility
class ErrorClassifier {
  /// Categorize error based on type and message
  static ErrorCategory categorizeError(dynamic error) {
    if (error == null) return ErrorCategory.unknown;

    // Network errors
    if (error is SocketException) return ErrorCategory.network;
    if (error is TimeoutException) return ErrorCategory.network;
    if (error is HttpException) return ErrorCategory.network;

    // Protocol errors
    if (error is FormatException) return ErrorCategory.protocol;

    // System errors
    if (error is FileSystemException) return ErrorCategory.system;
    if (error is ProcessException) return ErrorCategory.system;
    if (error is OutOfMemoryError) return ErrorCategory.system;

    // Check error message for additional context
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains("connection") ||
        errorMessage.contains("network") ||
        errorMessage.contains("timeout") ||
        errorMessage.contains("dns")) {
      return ErrorCategory.network;
    }

    if (errorMessage.contains("json") ||
        errorMessage.contains("parse") ||
        errorMessage.contains("format") ||
        errorMessage.contains("protocol")) {
      return ErrorCategory.protocol;
    }

    if (errorMessage.contains("permission") ||
        errorMessage.contains("access") ||
        errorMessage.contains("file") ||
        errorMessage.contains("directory")) {
      return ErrorCategory.system;
    }

    if (errorMessage.contains("invalid") ||
        errorMessage.contains("parameter") ||
        errorMessage.contains("authentication") ||
        errorMessage.contains("unauthorized")) {
      return ErrorCategory.user;
    }

    if (errorMessage.contains("method not found") ||
        errorMessage.contains("not implemented") ||
        errorMessage.contains("business logic")) {
      return ErrorCategory.application;
    }

    return ErrorCategory.unknown;
  }

  /// Determine error severity based on category and error details
  static ErrorSeverity determineSeverity(
      ErrorCategory category, dynamic error) {
    switch (category) {
      case ErrorCategory.network:
        if (error is TimeoutException) return ErrorSeverity.warning;
        return ErrorSeverity.error;

      case ErrorCategory.protocol:
        return ErrorSeverity.error;

      case ErrorCategory.application:
        return ErrorSeverity.error;

      case ErrorCategory.system:
        if (error is ProcessException) return ErrorSeverity.critical;
        if (error is OutOfMemoryError) return ErrorSeverity.critical;
        return ErrorSeverity.error;

      case ErrorCategory.user:
        return ErrorSeverity.error;

      case ErrorCategory.unknown:
        return ErrorSeverity.error;
    }
  }

  /// Generate recovery suggestions based on error category and details
  static List<String> generateRecoverySuggestions(
    ErrorCategory category,
    dynamic error,
  ) {
    switch (category) {
      case ErrorCategory.network:
        return [
          "Check if the server is running and accessible",
          "Verify network connectivity and firewall settings",
          "Try increasing timeout values",
          "Check DNS resolution for the target host",
        ];

      case ErrorCategory.protocol:
        return [
          "Verify the request/response format matches the expected protocol",
          "Check JSON structure and syntax",
          "Ensure protocol version compatibility",
          "Validate message encoding (UTF-8, etc.)",
        ];

      case ErrorCategory.application:
        return [
          "Check if the requested method/operation is implemented",
          "Verify business logic constraints are met",
          "Review application logs for additional context",
          "Ensure required dependencies are available",
        ];

      case ErrorCategory.system:
        return [
          "Check file and directory permissions",
          "Verify available disk space and memory",
          "Ensure required system resources are available",
          "Check process limits and system configuration",
        ];

      case ErrorCategory.user:
        return [
          "Verify input parameters are valid and complete",
          "Check authentication credentials and permissions",
          "Review request format and required fields",
          "Ensure user has necessary access rights",
        ];

      case ErrorCategory.unknown:
        return [
          "Review error logs for additional context",
          "Check system status and resource availability",
          "Try the operation again with different parameters",
          "Contact support if the issue persists",
        ];
    }
  }
}
