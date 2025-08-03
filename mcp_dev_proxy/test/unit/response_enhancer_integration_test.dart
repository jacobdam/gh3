import "dart:async";
import "dart:io";

import "package:mcp_dev_proxy/src/enhancers/error_context.dart";
import "package:mcp_dev_proxy/src/enhancers/response_enhancer.dart";
import "package:test/test.dart";

void main() {
  group("ResponseEnhancer Enhanced Error Integration", () {
    late ResponseEnhancer enhancer;

    setUp(() {
      enhancer = ResponseEnhancer();
    });

    test("createEnhancedError should classify network errors properly", () {
      const error = SocketException("Connection refused");
      final mcpError = enhancer.createEnhancedError(
        error,
        "server_connect",
        correlationId: "req_123",
        context: {"server": "localhost:8080"},
      );

      expect(mcpError.code, -32300); // Transport error
      expect(mcpError.message, "SocketException: Connection refused");
      expect(mcpError.data["category"], "network");
      expect(mcpError.data["severity"], "error");
      expect(mcpError.data["operation"], "server_connect");
      expect(mcpError.data["is_retryable"], isTrue);
      expect(mcpError.data["retry_delay_seconds"], isA<int>());
      expect(mcpError.data["recovery_suggestions"], isA<List>());
      expect(mcpError.data["correlation_id"], "req_123");
    });

    test("createEnhancedError should classify protocol errors properly", () {
      const error = FormatException("Invalid JSON");
      final mcpError = enhancer.createEnhancedError(
        error,
        "parse_response",
        context: {"raw_length": 100},
      );

      expect(mcpError.code, -32700); // Parse error
      expect(mcpError.data["category"], "protocol");
      expect(mcpError.data["severity"], "error");
      expect(mcpError.data["is_retryable"], isFalse);
      expect(mcpError.data["retry_delay_seconds"], isNull);
    });

    test("createEnhancedError should classify system errors properly", () {
      const error = ProcessException("ls", []);
      final mcpError = enhancer.createEnhancedError(
        error,
        "execute_command",
      );

      expect(mcpError.code, -32603); // Internal error
      expect(mcpError.data["category"], "system");
      expect(mcpError.data["severity"], "critical");
      expect(mcpError.data["is_retryable"], isFalse);
    });

    test("createEnhancedError should include base context information", () {
      final baseContext = ErrorContext(
        detectedRuntime: "dart",
        targetCommand: "dart run server.dart",
        environment: {"PATH": "/usr/bin"},
        workingDirectory: "/project",
        lastOutput: "Server starting...",
      );

      const error = SocketException("Connection timeout");
      final mcpError = enhancer.createEnhancedError(
        error,
        "server_connect",
        baseContext: baseContext,
      );

      final enhancedError =
          mcpError.data["enhanced_error"] as Map<String, dynamic>;
      expect(enhancedError["detectedRuntime"], "dart");
      expect(enhancedError["targetCommand"], "dart run server.dart");
      expect(enhancedError["environment"], {"PATH": "/usr/bin"});
      expect(enhancedError["workingDirectory"], "/project");
      expect(enhancedError["lastOutput"], "Server starting...");
    });

    test("createEnhancedError should handle null errors gracefully", () {
      final mcpError = enhancer.createEnhancedError(
        null,
        "unknown_operation",
      );

      expect(mcpError.code, -32603); // Internal error
      expect(mcpError.data["category"], "unknown");
      expect(mcpError.data["severity"], "error");
      expect(mcpError.message, "Unknown error");
    });

    test("createEnhancedError should include structured logging data", () {
      final error =
          TimeoutException("Operation timed out", const Duration(seconds: 30));
      final mcpError = enhancer.createEnhancedError(
        error,
        "fetch_data",
        correlationId: "op_456",
        context: {"timeout": 30, "retries": 2},
      );

      final enhancedError =
          mcpError.data["enhanced_error"] as Map<String, dynamic>;
      expect(enhancedError["timestamp"], isA<String>());
      expect(enhancedError["severity"], "warning");
      expect(enhancedError["category"], "network");
      expect(enhancedError["operation"], "fetch_data");
      expect(enhancedError["correlation_id"], "op_456");
      expect(enhancedError["debug_info"], {"timeout": 30, "retries": 2});
      expect(enhancedError["recovery_suggestions"], isA<List>());
      expect(enhancedError["is_retryable"], isTrue);
      expect(enhancedError["retry_delay"], isA<int>());
    });

    test("error code mapping should be appropriate for each category", () {
      final testCases = [
        (const SocketException("Network error"), -32300),
        (const FormatException("Protocol error"), -32700),
        (Exception("Application error"), -32603), // Unknown -> Internal
        (const ProcessException("ls", []), -32603), // System -> Internal
      ];

      for (final (error, expectedCode) in testCases) {
        final mcpError = enhancer.createEnhancedError(error, "test_operation");
        expect(mcpError.code, expectedCode);
      }
    });

    test("enhanced errors should maintain all existing functionality", () {
      // Test that existing methods still work
      final timeoutError =
          enhancer.createTimeoutError("test_op", const Duration(seconds: 30));
      expect(timeoutError.code, -32603);
      expect(timeoutError.message, "Operation timed out");

      final crashError = enhancer.createServerCrashError(1, "stderr output");
      expect(crashError.code, -32603);
      expect(crashError.message, "MCP server crashed (exit code: 1)");

      final restartError = enhancer.createServerRestartError("Binary changed");
      expect(restartError.code, -32603);
      expect(restartError.message, "MCP server restarting");
    });

    test("enhanced error data should be comprehensive", () {
      const error = FileSystemException("Permission denied", "/tmp/file");
      final mcpError = enhancer.createEnhancedError(
        error,
        "file_access",
        correlationId: "fs_789",
        context: {"file_path": "/tmp/file", "operation": "write"},
      );

      expect(mcpError.data["proxy"], "mcp_dev_proxy");
      expect(mcpError.data["enhanced_error"], isA<Map<String, dynamic>>());
      expect(mcpError.data["severity"], "error");
      expect(mcpError.data["category"], "system");
      expect(mcpError.data["operation"], "file_access");
      expect(mcpError.data["recovery_suggestions"], isA<List>());
      expect(mcpError.data["is_retryable"], isA<bool>());
      expect(mcpError.data["correlation_id"], "fs_789");

      final suggestions = mcpError.data["recovery_suggestions"] as List;
      expect(
          suggestions
              .any((s) => s.toString().toLowerCase().contains("permission")),
          isTrue);
    });
  });
}
