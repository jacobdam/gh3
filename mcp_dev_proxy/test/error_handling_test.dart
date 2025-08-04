import "package:mcp_dev_proxy/src/enhancers/error_context.dart";
import "package:mcp_dev_proxy/src/enhancers/response_enhancer.dart";
import "package:test/test.dart";

void main() {
  group("Error Message Enhancement Tests", () {
    late ResponseEnhancer enhancer;

    setUp(() {
      enhancer = ResponseEnhancer();
    });

    test("provides contextual error messages for different scenarios",
        () async {
      final context = ErrorContext(
        targetCommand: "test_server",
        workingDirectory: "/test/path",
        environment: {"PATH": "/usr/bin"},
      );

      // Test server crash error
      final serverCrashError = enhancer.enhanceError(
        ErrorType.serverCrash,
        "Server process crashed",
        context,
        code: -32603,
      );

      expect(serverCrashError.code, equals(-32603));
      expect(serverCrashError.message, equals("Server process crashed"));
      expect(serverCrashError.data, isNotNull);

      // Test timeout error
      final timeoutError = enhancer.enhanceError(
        ErrorType.timeout,
        "Request timed out after 30 seconds",
        context,
        code: -32000,
      );

      expect(timeoutError.code, equals(-32000));
      expect(
        timeoutError.message,
        equals("Request timed out after 30 seconds"),
      );
      expect(timeoutError.data, isNotNull);
    });
  });

  group("Recovery Guidance Tests", () {
    late ResponseEnhancer enhancer;

    setUp(() {
      enhancer = ResponseEnhancer();
    });

    test("provides specific recovery steps for API errors", () async {
      final context = ErrorContext(
        targetCommand: "test_server",
        workingDirectory: "/test/path",
        environment: {"PATH": "/usr/bin"},
      );

      final connectionError = enhancer.createEnhancedError(
        "Connection refused",
        "tool_call",
        correlationId: "test_123",
        context: {"error_type": "network"},
        baseContext: context,
      );

      expect(connectionError.data, isNotNull);
      expect(connectionError.data!["operation"], equals("tool_call"));
      expect(connectionError.data!["correlation_id"], equals("test_123"));
      expect(connectionError.data!["category"], isNotNull);
      expect(connectionError.data!["severity"], isNotNull);
    });
  });
}
