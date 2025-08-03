import 'package:test/test.dart';
import 'dart:async';
import '../../lib/src/managers/timeout_manager.dart';

void main() {
  group('Late Response Filtering (T1.2)', () {
    late TimeoutManager timeoutManager;

    setUp(() {
      timeoutManager = TimeoutManager();
    });

    tearDown(() {
      timeoutManager.dispose();
    });

    test('should track active timeouts and prevent duplicates', () async {
      final responses = <Map<String, dynamic>>[];
      final requestId = 'test-timeout-tracking';

      // Start timeout
      final timer = timeoutManager.startTimeout(
        requestId,
        'tools/list',
        () {
          responses.add(timeoutManager.createTimeoutError(
            requestId,
            'tools/list',
            Duration(seconds: 10),
            null,
          ));
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
      expect(responses.length, equals(0),
          reason: 'No timeout should occur after cancellation');
    });

    test('should create structured timeout errors', () {
      final requestId = 'test-timeout-error';
      final method = 'tools/call';
      final timeout = Duration(seconds: 90);

      final timeoutError = timeoutManager.createTimeoutError(
        requestId,
        method,
        timeout,
        {'operation': 'test_tool'},
      );

      // Verify timeout error structure
      expect(timeoutError['jsonrpc'], equals('2.0'));
      expect(timeoutError['id'], equals(requestId));
      expect(timeoutError['error'], isNotNull);

      final error = timeoutError['error'];
      expect(error['code'], equals(-32603));
      expect(error['message'], equals('Request timeout'));
      expect(error['data']['method'], equals(method));
      expect(error['data']['timeout_seconds'], equals(90));
      expect(error['data']['suggestion'], isA<String>());
      expect(error['data']['context'], equals({'operation': 'test_tool'}));
    });

    test('should prevent duplicate timeouts for same request', () async {
      final responses = <Map<String, dynamic>>[];
      final requestId = 'test-duplicate-prevention';
      var timeoutCount = 0;

      // Set short timeout for testing
      timeoutManager.setCustomTimeout('initialize', Duration(milliseconds: 50));

      // Start first timeout
      timeoutManager.startTimeout(
        requestId,
        'initialize',
        () {
          timeoutCount++;
          responses.add({'error': 'first_timeout'});
        },
      );

      expect(timeoutManager.hasActiveTimeout(requestId), isTrue);

      // Start second timeout with same ID (should replace first)
      timeoutManager.startTimeout(
        requestId,
        'initialize',
        () {
          timeoutCount++;
          responses.add({'error': 'second_timeout'});
        },
      );

      // Should still have only one active timeout
      expect(timeoutManager.getActiveTimeoutCount(), equals(1));
      expect(timeoutManager.hasActiveTimeout(requestId), isTrue);

      // Wait for timeout to trigger
      await Future.delayed(Duration(milliseconds: 100));

      // Only the second timeout should have triggered
      expect(timeoutCount, equals(1), reason: 'Only one timeout should occur');
      expect(responses.length, equals(1),
          reason: 'Only one response should be sent');
      expect(responses.first['error'], equals('second_timeout'));
    });

    test('should handle timeout configuration correctly', () {
      // Test default timeouts
      expect(timeoutManager.getTimeout('initialize', null),
          equals(Duration(seconds: 15)));
      expect(timeoutManager.getTimeout('tools/list', null),
          equals(Duration(seconds: 10)));
      expect(timeoutManager.getTimeout('tools/call', null),
          equals(Duration(seconds: 90)));
      expect(timeoutManager.getTimeout('unknown/method', null),
          equals(Duration(seconds: 30)));

      // Test custom timeout configuration
      timeoutManager.setCustomTimeout('custom/method', Duration(seconds: 45));
      expect(timeoutManager.getTimeout('custom/method', null),
          equals(Duration(seconds: 45)));

      // Test parameter-based timeout
      final longRunningParams = {'timeout_seconds': 300};
      expect(timeoutManager.getTimeout('tools/call', longRunningParams),
          equals(Duration(seconds: 300)));
    });
  });
}
