import "dart:async";

import "package:mcp_dev_proxy/src/managers/timeout_manager.dart";
import "package:test/test.dart";

void main() {
  group("Late Response Filtering (T1.2)", () {
    late TimeoutManager timeoutManager;

    setUp(() {
      timeoutManager = TimeoutManager();
    });

    tearDown(() {
      timeoutManager.dispose();
    });

    test("should track active timeouts and prevent duplicates", () async {
      final responses = <Map<String, dynamic>>[];
      const requestId = "test-timeout-tracking";

      // Start timeout
      timeoutManager.startTimeout(
        requestId,
        "tools/list",
        () {
          responses.add(
            timeoutManager.createTimeoutError(
              requestId,
              "tools/list",
              const Duration(seconds: 10),
              null,
            ),
          );
        },
      );

      // Verify timeout is tracked
      expect(timeoutManager.hasActiveTimeout(requestId), isTrue);
      expect(timeoutManager.getActiveTimeoutCount(), equals(1));

      // Cancel timeout (simulating successful response)
      timeoutManager.cancelTimeout(requestId);

      // Verify timeout is removed
      expect(timeoutManager.hasActiveTimeout(requestId), isFalse);
      expect(timeoutManager.getActiveTimeoutCount(), equals(0));
      expect(
        responses.length,
        equals(0),
        reason: "No timeout should occur after cancellation",
      );
    });

    test("should create structured timeout errors", () {
      const requestId = "test-timeout-error";
      const method = "tools/call";
      const timeout = Duration(seconds: 90);

      final timeoutError = timeoutManager.createTimeoutError(
        requestId,
        method,
        timeout,
        {"operation": "test_tool"},
      );

      // Verify timeout error structure
      expect(timeoutError["jsonrpc"], equals("2.0"));
      expect(timeoutError["id"], equals(requestId));
      expect(timeoutError["error"], isNotNull);

      final error = timeoutError["error"];
      expect(error["code"], equals(-32603));
      expect(error["message"], equals("Request timeout"));
      expect(error["data"]["method"], equals(method));
      expect(error["data"]["timeout_seconds"], equals(90));
      expect(error["data"]["suggestion"], isA<String>());
      expect(error["data"]["context"], equals({"operation": "test_tool"}));
    });

    test("should prevent duplicate timeouts for same request", () async {
      final responses = <Map<String, dynamic>>[];
      const requestId = "test-duplicate-prevention";
      var timeoutCount = 0;

      // Set short timeout for testing
      timeoutManager.setCustomTimeout(
        "initialize",
        const Duration(milliseconds: 50),
      );

      // Start first timeout
      timeoutManager.startTimeout(
        requestId,
        "initialize",
        () {
          timeoutCount++;
          responses.add({"error": "first_timeout"});
        },
      );

      expect(timeoutManager.hasActiveTimeout(requestId), isTrue);

      // Start second timeout with same ID (should replace first)
      timeoutManager.startTimeout(
        requestId,
        "initialize",
        () {
          timeoutCount++;
          responses.add({"error": "second_timeout"});
        },
      );

      // Should still have only one active timeout
      expect(timeoutManager.getActiveTimeoutCount(), equals(1));
      expect(timeoutManager.hasActiveTimeout(requestId), isTrue);

      // Wait for timeout to trigger
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Only the second timeout should have triggered
      expect(timeoutCount, equals(1), reason: "Only one timeout should occur");
      expect(
        responses.length,
        equals(1),
        reason: "Only one response should be sent",
      );
      expect(responses.first["error"], equals("second_timeout"));
    });

    test("should handle timeout configuration correctly", () {
      // Test default timeouts
      expect(
        timeoutManager.getTimeout("initialize", null),
        equals(const Duration(seconds: 15)),
      );
      expect(
        timeoutManager.getTimeout("tools/list", null),
        equals(const Duration(seconds: 10)),
      );
      expect(
        timeoutManager.getTimeout("tools/call", null),
        equals(const Duration(seconds: 90)),
      );
      expect(
        timeoutManager.getTimeout("unknown/method", null),
        equals(const Duration(seconds: 30)),
      );

      // Test custom timeout configuration
      timeoutManager.setCustomTimeout(
        "custom/method",
        const Duration(seconds: 45),
      );
      expect(
        timeoutManager.getTimeout("custom/method", null),
        equals(const Duration(seconds: 45)),
      );

      // Test parameter-based timeout
      final longRunningParams = {"timeout_seconds": 300};
      expect(
        timeoutManager.getTimeout("tools/call", longRunningParams),
        equals(const Duration(seconds: 300)),
      );
    });
  });
}
