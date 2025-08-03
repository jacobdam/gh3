import "dart:convert";

class MCPMessage {
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
      jsonrpc: json["jsonrpc"] is String ? json["jsonrpc"] as String : "2.0",
      id: json["id"],
      method: json["method"] is String ? json["method"] as String? : null,
      params: json["params"],
      result: json["result"],
      error: json["error"] != null && json["error"] is Map<String, dynamic>
          ? MCPError.fromJson(json["error"] as Map<String, dynamic>)
          : null,
    );
  }
  final String jsonrpc;
  final dynamic id;
  final String? method;
  final dynamic params;
  final dynamic result;
  final MCPError? error;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      "jsonrpc": jsonrpc,
    };

    if (id != null) json["id"] = id;
    if (method != null) json["method"] = method;
    if (params != null) json["params"] = params;
    if (result != null) json["result"] = result;
    if (error != null) json["error"] = error!.toJson();

    return json;
  }

  bool get isRequest => method != null;
  bool get isResponse => result != null || error != null;
  bool get isNotification => method != null && id == null;

  MCPMessage withProxyMetadata({String? proxyEvent, String? reason}) {
    if (!isResponse) return this;

    final proxyData = <String, dynamic>{
      "name": "mcp_dev_proxy",
      "version": "1.0.0",
      "target": "mcp_flutter_automation",
    };

    if (proxyEvent != null) proxyData["event"] = proxyEvent;
    if (reason != null) proxyData["reason"] = reason;

    if (result != null) {
      final Map<String, dynamic> resultMap;
      if (result is Map<String, dynamic>) {
        resultMap = Map<String, dynamic>.from(result as Map<String, dynamic>);
        resultMap["proxy"] = proxyData;
      } else {
        resultMap = {"original_result": result, "proxy": proxyData};
      }

      return MCPMessage(
        jsonrpc: jsonrpc,
        id: id,
        result: resultMap,
      );
    }

    return this;
  }

  static MCPMessage createErrorResponse(dynamic id, MCPError error) {
    return MCPMessage(
      jsonrpc: "2.0",
      id: id,
      error: error,
    );
  }
}

class MCPError {
  MCPError({
    required this.code,
    required this.message,
    this.data,
  });

  factory MCPError.fromJson(Map<String, dynamic> json) {
    return MCPError(
      code: json["code"] is int ? json["code"] as int : -32603,
      message: json["message"] is String
          ? json["message"] as String
          : "Unknown error",
      data: json["data"],
    );
  }
  final int code;
  final String message;
  final dynamic data;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      "code": code,
      "message": message,
    };

    if (data != null) json["data"] = data;

    return json;
  }

  static MCPError serverCrash(int exitCode, String stderr) {
    return MCPError(
      code: -32603,
      message: "MCP server crashed (exit code: $exitCode)",
      data: {
        "stderr": stderr,
        "exit_code": exitCode,
        "proxy": "mcp_dev_proxy",
        "proxy_capabilities": [
          "crash_recovery",
          "hot_reload",
          "error_buffering",
          "debug_info",
        ],
      },
    );
  }

  static MCPError serverUnavailable([Map<String, dynamic>? details]) {
    final data = details ?? {};
    data["proxy"] = "mcp_dev_proxy";
    data["proxy_capabilities"] = [
      "crash_recovery",
      "hot_reload",
      "error_buffering",
      "debug_info",
    ];

    return MCPError(
      code: -32603,
      message: "MCP server unavailable",
      data: data,
    );
  }

  static MCPError serverRestart(String reason) {
    return MCPError(
      code: -32603,
      message: "MCP server restarting",
      data: {
        "reason": reason,
        "proxy": "mcp_dev_proxy",
        "message":
            "Server is restarting due to $reason. Please retry your request.",
        "proxy_capabilities": [
          "crash_recovery",
          "hot_reload",
          "error_buffering",
          "debug_info",
        ],
      },
    );
  }
}

class MCPProtocol {
  static MCPMessage? parseMessage(String line) {
    try {
      final decoded = jsonDecode(line);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return MCPMessage.fromJson(decoded);
    } on Exception {
      return null;
    }
  }

  static String formatMessage(MCPMessage message) {
    return jsonEncode(message.toJson());
  }
}
