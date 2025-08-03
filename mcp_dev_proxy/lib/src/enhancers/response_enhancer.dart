import '../../mcp_protocol.dart';
import 'error_context.dart';

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
}

class ResponseEnhancer {
  final List<ErrorEnhancer> _enhancers = [];

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
        final enhanced = enhancer.enhance({
          'code': code ?? _getDefaultCode(errorType),
          'message': message,
          'data': errorData,
        }, context);

        errorData = enhanced['data'] ?? errorData;
      }
    }

    return MCPError(
      code: code ?? _getDefaultCode(errorType),
      message: message,
      data: errorData,
    );
  }

  MCPError createServerCrashError(int exitCode, String? stderr) {
    return MCPError.serverCrash(exitCode, stderr ?? '');
  }

  MCPError createServerRestartError(String reason) {
    return MCPError.serverRestart(reason);
  }

  MCPError createTimeoutError(String operation, Duration timeout) {
    return MCPError(
      code: -32603,
      message: 'Operation timed out',
      data: {
        'operation': operation,
        'timeout_ms': timeout.inMilliseconds,
        'proxy': 'mcp_dev_proxy',
        'recovery_hint':
            'Check if the target server is responding or increase timeout',
      },
    );
  }

  MCPError createToolInterruptedError(String toolUseId, String reason) {
    return MCPError(
      code: -32603,
      message: 'Tool execution interrupted by server restart',
      data: {
        'tool_use_id': toolUseId,
        'reason': reason,
        'proxy': 'mcp_dev_proxy',
        'recovery_hint':
            'Use /resume command to start a fresh session without incomplete tool cycles',
      },
    );
  }

  int _getDefaultCode(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.serverCrash:
      case ErrorType.serverRestart:
      case ErrorType.timeout:
      case ErrorType.toolInterrupted:
        return -32603; // Internal error
      case ErrorType.connectionFailed:
        return -32002; // Invalid params (connection not available)
      case ErrorType.invalidResponse:
        return -32700; // Parse error
    }
  }
}
