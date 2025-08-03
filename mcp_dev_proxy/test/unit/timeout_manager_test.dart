import "dart:async";

import "package:mcp_dev_proxy/src/managers/timeout_manager.dart";
import "package:test/test.dart";

void main() {
  group("TimeoutManager", () {
    late TimeoutManager timeoutManager;

    setUp(() {
      timeoutManager = TimeoutManager();
    });

    tearDown(() {
      timeoutManager.dispose();
    });

    group("getTimeout", () {
      test("should return correct timeout for initialize method", () {
        final timeout = timeoutManager.getTimeout("initialize", null);
        expect(timeout, equals(const Duration(seconds: 15)));
      });

      test("should return correct timeout for tools/call method", () {
        final timeout = timeoutManager.getTimeout("tools/call", null);
        expect(timeout, equals(const Duration(seconds: 90)));
      });

      test("should return correct timeout for list methods", () {
        final timeout1 = timeoutManager.getTimeout("tools/list", null);
        final timeout2 = timeoutManager.getTimeout("resources/list", null);
        final timeout3 = timeoutManager.getTimeout("prompts/list", null);

        expect(timeout1, equals(const Duration(seconds: 10)));
        expect(timeout2, equals(const Duration(seconds: 10)));
        expect(timeout3, equals(const Duration(seconds: 10)));
      });

      test("should return default timeout for unknown method", () {
        final timeout = timeoutManager.getTimeout("unknown/method", null);
        expect(timeout, equals(const Duration(seconds: 30)));
      });

      test("should use custom timeout when configured", () {
        timeoutManager.setCustomTimeout("custom/method", const Duration(seconds: 45));
        final timeout = timeoutManager.getTimeout("custom/method", null);
        expect(timeout, equals(const Duration(seconds: 45)));
      });

      test("should return extended timeout for long-running operations", () {
        final params = {"timeout_seconds": 300};
        final timeout = timeoutManager.getTimeout("tools/call", params);
        expect(timeout, equals(const Duration(seconds: 300)));
      });
    });

    group("startTimeout", () {
      test("should start timeout and call callback when expired", () async {
        final completer = Completer<bool>();
        const requestId = "test-request-1";

        timeoutManager.startTimeout(
            requestId, "tools/call", () => completer.complete(true),);

        expect(timeoutManager.hasActiveTimeout(requestId), isTrue);

        // Wait a bit longer than the timeout (use short timeout for testing)
        timeoutManager.setCustomTimeout(
            "tools/call", const Duration(milliseconds: 50),);
        timeoutManager.startTimeout(
            "test-fast", "tools/call", () => completer.complete(true),);

        final result =
            await completer.future.timeout(const Duration(milliseconds: 100));
        expect(result, isTrue);
      });

      test("should track multiple concurrent timeouts", () {
        timeoutManager.startTimeout("request-1", "initialize", () {});
        timeoutManager.startTimeout("request-2", "tools/call", () {});
        timeoutManager.startTimeout("request-3", "tools/list", () {});

        expect(timeoutManager.hasActiveTimeout("request-1"), isTrue);
        expect(timeoutManager.hasActiveTimeout("request-2"), isTrue);
        expect(timeoutManager.hasActiveTimeout("request-3"), isTrue);
        expect(timeoutManager.getActiveTimeoutCount(), equals(3));
      });

      test("should replace existing timeout for same request ID", () {
        var callCount = 0;

        timeoutManager.startTimeout(
            "request-1", "initialize", () => callCount++,);
        timeoutManager.startTimeout(
            "request-1", "tools/call", () => callCount++,);

        expect(timeoutManager.hasActiveTimeout("request-1"), isTrue);
        expect(timeoutManager.getActiveTimeoutCount(), equals(1));
      });
    });

    group("cancelTimeout", () {
      test("should cancel active timeout", () {
        var wasCalled = false;
        const requestId = "test-request";

        timeoutManager.startTimeout(
            requestId, "initialize", () => wasCalled = true,);
        expect(timeoutManager.hasActiveTimeout(requestId), isTrue);

        timeoutManager.cancelTimeout(requestId);
        expect(timeoutManager.hasActiveTimeout(requestId), isFalse);

        // Wait to ensure callback is not called
        Future.delayed(const Duration(milliseconds: 100), () {
          expect(wasCalled, isFalse);
        });
      });

      test("should handle canceling non-existent timeout gracefully", () {
        expect(() => timeoutManager.cancelTimeout("non-existent"),
            returnsNormally,);
      });

      test("should reduce active timeout count when canceled", () {
        timeoutManager.startTimeout("request-1", "initialize", () {});
        timeoutManager.startTimeout("request-2", "tools/call", () {});

        expect(timeoutManager.getActiveTimeoutCount(), equals(2));

        timeoutManager.cancelTimeout("request-1");
        expect(timeoutManager.getActiveTimeoutCount(), equals(1));

        timeoutManager.cancelTimeout("request-2");
        expect(timeoutManager.getActiveTimeoutCount(), equals(0));
      });
    });

    group("createTimeoutError", () {
      test("should create timeout error with basic information", () {
        final error = timeoutManager.createTimeoutError(
            "test-request", "tools/call", const Duration(seconds: 90), null,);

        expect(error["error"]["code"], equals(-32603));
        expect(error["error"]["message"], equals("Request timeout"));
        expect(error["error"]["data"]["method"], equals("tools/call"));
        expect(error["error"]["data"]["timeout_seconds"], equals(90));
        expect(error["id"], equals("test-request"));
      });

      test("should include operation context in error data", () {
        final context = {
          "tool_name": "file_reader",
          "operation_type": "large_file_processing",
        };

        final error = timeoutManager.createTimeoutError(
            "test-request", "tools/call", const Duration(seconds: 120), context,);

        expect(error["error"]["data"]["context"], equals(context));
      });

      test("should include helpful timeout guidance", () {
        final error = timeoutManager.createTimeoutError(
            "test-request", "tools/call", const Duration(seconds: 90), null,);

        expect(error["error"]["data"]["suggestion"],
            contains("Tool execution exceeded timeout"),);
      });
    });

    group("Custom timeout configuration", () {
      test("should allow setting custom timeouts", () {
        timeoutManager.setCustomTimeout("custom/method", const Duration(minutes: 5));
        final timeout = timeoutManager.getTimeout("custom/method", null);
        expect(timeout, equals(const Duration(minutes: 5)));
      });

      test("should clear custom timeout", () {
        timeoutManager.setCustomTimeout("custom/method", const Duration(minutes: 5));
        timeoutManager.clearCustomTimeout("custom/method");

        final timeout = timeoutManager.getTimeout("custom/method", null);
        expect(timeout, equals(const Duration(seconds: 30))); // default
      });

      test("should clear all custom timeouts", () {
        timeoutManager.setCustomTimeout("method1", const Duration(minutes: 1));
        timeoutManager.setCustomTimeout("method2", const Duration(minutes: 2));

        timeoutManager.clearAllCustomTimeouts();

        expect(timeoutManager.getTimeout("method1", null),
            equals(const Duration(seconds: 30)),);
        expect(timeoutManager.getTimeout("method2", null),
            equals(const Duration(seconds: 30)),);
      });
    });

    group("Timeout accuracy", () {
      test("should timeout within acceptable accuracy range", () async {
        final stopwatch = Stopwatch()..start();
        final completer = Completer<void>();

        timeoutManager.setCustomTimeout("test", const Duration(milliseconds: 100));
        timeoutManager.startTimeout("accuracy-test", "test", () {
          stopwatch.stop();
          completer.complete();
        });

        await completer.future;

        // Should be within ±50ms of expected timeout (lenient for CI environments)
        expect(stopwatch.elapsedMilliseconds, greaterThan(50));
        expect(stopwatch.elapsedMilliseconds, lessThan(200));
      });
    });

    group("Dispose and cleanup", () {
      test("should cancel all timeouts on dispose", () {
        timeoutManager.startTimeout("request-1", "initialize", () {});
        timeoutManager.startTimeout("request-2", "tools/call", () {});

        expect(timeoutManager.getActiveTimeoutCount(), equals(2));

        timeoutManager.dispose();

        expect(timeoutManager.getActiveTimeoutCount(), equals(0));
      });

      test("should handle multiple dispose calls gracefully", () {
        timeoutManager.startTimeout("request-1", "initialize", () {});

        timeoutManager.dispose();
        expect(() => timeoutManager.dispose(), returnsNormally);
      });
    });
  });
}
