import "package:mcp_dev_proxy/mcp_protocol.dart";
import "package:test/test.dart";

void main() {
  group("MCPMessage", () {
    test("should parse JSON-RPC request", () {
      final json = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "test_method",
        "params": {"key": "value"},
      };

      final message = MCPMessage.fromJson(json);

      expect(message.jsonrpc, equals("2.0"));
      expect(message.id, equals(1));
      expect(message.method, equals("test_method"));
      expect(message.params, equals({"key": "value"}));
      expect(message.isRequest, isTrue);
      expect(message.isResponse, isFalse);
      expect(message.isNotification, isFalse);
    });

    test("should parse JSON-RPC response", () {
      final json = {
        "jsonrpc": "2.0",
        "id": 1,
        "result": {"success": true},
      };

      final message = MCPMessage.fromJson(json);

      expect(message.jsonrpc, equals("2.0"));
      expect(message.id, equals(1));
      expect(message.result, equals({"success": true}));
      expect(message.isRequest, isFalse);
      expect(message.isResponse, isTrue);
      expect(message.isNotification, isFalse);
    });

    test("should parse JSON-RPC notification", () {
      final json = {
        "jsonrpc": "2.0",
        "method": "notification",
        "params": {"data": "test"},
      };

      final message = MCPMessage.fromJson(json);

      expect(message.method, equals("notification"));
      expect(message.id, isNull);
      expect(message.isRequest, isTrue);
      expect(message.isResponse, isFalse);
      expect(message.isNotification, isTrue);
    });

    test("should parse JSON-RPC error response", () {
      final json = {
        "jsonrpc": "2.0",
        "id": 1,
        "error": {
          "code": -32603,
          "message": "Internal error",
          "data": {"details": "test error"},
        },
      };

      final message = MCPMessage.fromJson(json);

      expect(message.error, isNotNull);
      expect(message.error!.code, equals(-32603));
      expect(message.error!.message, equals("Internal error"));
      expect(message.error!.data, equals({"details": "test error"}));
      expect(message.isResponse, isTrue);
    });

    test("should convert to JSON", () {
      final message = MCPMessage(
        jsonrpc: "2.0",
        id: 1,
        method: "test",
        params: {"key": "value"},
      );

      final json = message.toJson();

      expect(json["jsonrpc"], equals("2.0"));
      expect(json["id"], equals(1));
      expect(json["method"], equals("test"));
      expect(json["params"], equals({"key": "value"}));
    });

    test("should add proxy metadata to successful response", () {
      final message = MCPMessage(
        jsonrpc: "2.0",
        id: 1,
        result: {"data": "test"},
      );

      final enhanced = message.withProxyMetadata();

      expect(enhanced.result["proxy"], isNotNull);
      expect(enhanced.result["proxy"]["name"], equals("mcp_dev_proxy"));
      expect(enhanced.result["proxy"]["version"], equals("1.0.0"));
      expect(
          enhanced.result["proxy"]["target"], equals("mcp_flutter_automation"),);
      expect(enhanced.result["data"], equals("test"));
    });

    test("should add proxy metadata with events", () {
      final message = MCPMessage(
        jsonrpc: "2.0",
        id: 1,
        result: {"data": "test"},
      );

      final enhanced = message.withProxyMetadata(
        proxyEvent: "restarted",
        reason: "binary_updated",
      );

      expect(enhanced.result["proxy"]["event"], equals("restarted"));
      expect(enhanced.result["proxy"]["reason"], equals("binary_updated"));
    });

    test("should not add proxy metadata to requests", () {
      final message = MCPMessage(
        jsonrpc: "2.0",
        id: 1,
        method: "test",
      );

      final enhanced = message.withProxyMetadata();

      expect(enhanced, equals(message));
    });

    test("should create error response", () {
      final error = MCPError(code: -32603, message: "Test error");
      final response = MCPMessage.createErrorResponse(1, error);

      expect(response.jsonrpc, equals("2.0"));
      expect(response.id, equals(1));
      expect(response.error, equals(error));
    });
  });

  group("MCPError", () {
    test("should create server crash error", () {
      final error = MCPError.serverCrash(1, "stderr output");

      expect(error.code, equals(-32603));
      expect(error.message, equals("MCP server crashed (exit code: 1)"));
      expect(error.data["stderr"], equals("stderr output"));
      expect(error.data["exit_code"], equals(1));
      expect(error.data["proxy"], equals("mcp_dev_proxy"));
    });

    test("should create server unavailable error", () {
      final error = MCPError.serverUnavailable();

      expect(error.code, equals(-32603));
      expect(error.message, equals("MCP server unavailable"));
      expect(error.data["proxy"], equals("mcp_dev_proxy"));
    });

    test("should create server restart error", () {
      final error = MCPError.serverRestart("binary_updated");

      expect(error.code, equals(-32603));
      expect(error.message, equals("MCP server restarting"));
      expect(error.data["reason"], equals("binary_updated"));
      expect(error.data["proxy"], equals("mcp_dev_proxy"));
      expect(error.data["message"],
          contains("Server is restarting due to binary_updated"),);
    });

    test("should convert to JSON", () {
      final error = MCPError(
        code: -32603,
        message: "Test error",
        data: {"key": "value"},
      );

      final json = error.toJson();

      expect(json["code"], equals(-32603));
      expect(json["message"], equals("Test error"));
      expect(json["data"], equals({"key": "value"}));
    });
  });

  group("MCPProtocol", () {
    test("should parse valid JSON message", () {
      const jsonString = '{"jsonrpc":"2.0","id":1,"method":"test"}';
      final message = MCPProtocol.parseMessage(jsonString);

      expect(message, isNotNull);
      expect(message!.method, equals("test"));
    });

    test("should return null for invalid JSON", () {
      const invalidJson = "invalid json";
      final message = MCPProtocol.parseMessage(invalidJson);

      expect(message, isNull);
    });

    test("should format message to JSON string", () {
      final message = MCPMessage(
        jsonrpc: "2.0",
        id: 1,
        method: "test",
      );

      final formatted = MCPProtocol.formatMessage(message);
      final parsed = MCPProtocol.parseMessage(formatted);

      expect(parsed, isNotNull);
      expect(parsed!.method, equals("test"));
      expect(parsed.id, equals(1));
    });
  });
}
