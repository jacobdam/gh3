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
  serverUnavailable,
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

        errorData = enhanced['data'] as Map<String, dynamic>? ?? errorData;
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

  MCPError createServerUnavailableError(ErrorContext context,
      {Map<String, dynamic>? additionalData}) {
    final binaryExists = context.environment?['binaryExists'] == 'true';
    final startupError = context.lastOutput;

    String message;
    String actionNeeded;

    if (!binaryExists) {
      message = 'MCP server binary not found';
      actionNeeded =
          'Compile your MCP server binary and the proxy will handle the rest';
    } else if (startupError != null && startupError.isNotEmpty) {
      message = 'Target MCP server failed to start';
      actionNeeded =
          'Check if binary is executable and implements MCP protocol';
    } else {
      message = 'Target MCP server is not running';
      actionNeeded = 'Check if your MCP server process crashed';
    }

    final data = <String, dynamic>{
      'proxy': 'mcp_dev_proxy',
      'target_binary': context.targetCommand ?? 'unknown',
      'message': message,
      'action_needed': actionNeeded,
      'status': binaryExists ? 'binary_exists' : 'binary_missing',
      'proxy_capabilities': [
        'crash_recovery',
        'hot_reload',
        'error_buffering',
        'debug_info'
      ],
    };

    if (startupError != null && startupError.isNotEmpty) {
      data['startup_error'] = startupError;
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
}
