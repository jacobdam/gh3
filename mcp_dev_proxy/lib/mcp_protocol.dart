import 'dart:convert';

class MCPMessage {
  final String jsonrpc;
  final dynamic id;
  final String? method;
  final dynamic params;
  final dynamic result;
  final MCPError? error;

  MCPMessage({
    required this.jsonrpc,
    this.id,
    this.method,
    this.params,
    this.result,
    this.error,
  });

  factory MCPMessage.fromJson(Map<String, dynamic> json) {
    return MCPMessage(
      jsonrpc: json['jsonrpc'] ?? '2.0',
      id: json['id'],
      method: json['method'],
      params: json['params'],
      result: json['result'],
      error: json['error'] != null ? MCPError.fromJson(json['error']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'jsonrpc': jsonrpc,
    };

    if (id != null) json['id'] = id;
    if (method != null) json['method'] = method;
    if (params != null) json['params'] = params;
    if (result != null) json['result'] = result;
    if (error != null) json['error'] = error!.toJson();

    return json;
  }

  bool get isRequest => method != null;
  bool get isResponse => result != null || error != null;
  bool get isNotification => method != null && id == null;

  MCPMessage withProxyMetadata({String? proxyEvent, String? reason}) {
    if (!isResponse) return this;

    final proxyData = <String, dynamic>{
      'name': 'mcp_dev_proxy',
      'version': '1.0.0',
      'target': 'mcp_flutter_automation',
    };

    if (proxyEvent != null) proxyData['event'] = proxyEvent;
    if (reason != null) proxyData['reason'] = reason;

    if (result != null) {
      return MCPMessage(
        jsonrpc: jsonrpc,
        id: id,
        result: {
          if (result is Map<String, dynamic>) ...result,
          'proxy': proxyData,
        },
      );
    }

    return this;
  }

  static MCPMessage createErrorResponse(dynamic id, MCPError error) {
    return MCPMessage(
      jsonrpc: '2.0',
      id: id,
      error: error,
    );
  }
}

class MCPError {
  final int code;
  final String message;
  final dynamic data;

  MCPError({
    required this.code,
    required this.message,
    this.data,
  });

  factory MCPError.fromJson(Map<String, dynamic> json) {
    return MCPError(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'code': code,
      'message': message,
    };

    if (data != null) json['data'] = data;

    return json;
  }

  static MCPError serverCrash(int exitCode, String stderr) {
    return MCPError(
      code: -32603,
      message: 'MCP server crashed (exit code: $exitCode)',
      data: {
        'stderr': stderr,
        'exit_code': exitCode,
        'proxy': 'mcp_dev_proxy',
      },
    );
  }

  static MCPError serverUnavailable() {
    return MCPError(
      code: -32603,
      message: 'MCP server unavailable',
      data: {
        'proxy': 'mcp_dev_proxy',
      },
    );
  }
}

class MCPProtocol {
  static MCPMessage? parseMessage(String line) {
    try {
      final json = jsonDecode(line) as Map<String, dynamic>;
      return MCPMessage.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  static String formatMessage(MCPMessage message) {
    return jsonEncode(message.toJson());
  }
}
