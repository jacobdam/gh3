import 'package:test/test.dart';
import '../../lib/src/enhancers/response_enhancer.dart';
import '../../lib/src/enhancers/error_context.dart';
import '../../lib/mcp_protocol.dart';

class MockErrorEnhancer extends ErrorEnhancer {
  final ErrorType supportedType;
  final Map<String, dynamic> enhancementData;

  MockErrorEnhancer(this.supportedType, this.enhancementData);

  @override
  bool canHandle(ErrorType errorType, ErrorContext context) {
    return errorType == supportedType;
  }

  @override
  Map<String, dynamic> enhance(
    Map<String, dynamic> error,
    ErrorContext context,
  ) {
    final data = Map<String, dynamic>.from(error['data'] ?? {});
    data.addAll(enhancementData);
    return {
      ...error,
      'data': data,
    };
  }
}

void main() {
  group('ResponseEnhancer', () {
    late ResponseEnhancer enhancer;
    late ErrorContext context;

    setUp(() {
      enhancer = ResponseEnhancer();
      context = ErrorContext(
        detectedRuntime: 'dart',
        targetCommand: 'dart run example.dart',
        workingDirectory: '/test/path',
      );
    });

    group('enhanceResponse', () {
      test('should enhance response with proxy metadata', () {
        final originalMessage = MCPMessage(
          jsonrpc: '2.0',
          id: '123',
          result: {'data': 'test'},
        );

        final enhanced = enhancer.enhanceResponse(
          originalMessage,
          proxyEvent: 'restarted',
          reason: 'binary_updated',
        );

        expect(enhanced.result!['proxy'], isNotNull);
        expect(enhanced.result!['proxy']['name'], equals('mcp_dev_proxy'));
        expect(enhanced.result!['proxy']['event'], equals('restarted'));
        expect(enhanced.result!['proxy']['reason'], equals('binary_updated'));
        expect(enhanced.result!['data'], equals('test'));
      });

      test('should enhance response without proxy event', () {
        final originalMessage = MCPMessage(
          jsonrpc: '2.0',
          id: '123',
          result: {'tools': []},
        );

        final enhanced = enhancer.enhanceResponse(originalMessage);

        expect(enhanced.result!['proxy'], isNotNull);
        expect(enhanced.result!['proxy']['name'], equals('mcp_dev_proxy'));
        expect(enhanced.result!['proxy']['event'], isNull);
        expect(enhanced.result!['tools'], equals([]));
      });
    });

    group('enhanceError', () {
      test('should create basic error without enhancers', () {
        final error = enhancer.enhanceError(
          ErrorType.timeout,
          'Operation timed out',
          context,
          code: -32603,
          data: {'operation': 'test'},
        );

        expect(error.code, equals(-32603));
        expect(error.message, equals('Operation timed out'));
        expect(error.data['operation'], equals('test'));
      });

      test('should apply custom enhancers', () {
        final mockEnhancer = MockErrorEnhancer(
          ErrorType.timeout,
          {'enhanced': true, 'runtime': 'dart'},
        );
        enhancer.addEnhancer(mockEnhancer);

        final error = enhancer.enhanceError(
          ErrorType.timeout,
          'Operation timed out',
          context,
          data: {'operation': 'test'},
        );

        expect(error.data['operation'], equals('test'));
        expect(error.data['enhanced'], equals(true));
        expect(error.data['runtime'], equals('dart'));
      });

      test('should use default error codes', () {
        final serverCrashError = enhancer.enhanceError(
          ErrorType.serverCrash,
          'Server crashed',
          context,
        );
        expect(serverCrashError.code, equals(-32603));

        final connectionError = enhancer.enhanceError(
          ErrorType.connectionFailed,
          'Connection failed',
          context,
        );
        expect(connectionError.code, equals(-32002));

        final parseError = enhancer.enhanceError(
          ErrorType.invalidResponse,
          'Invalid response',
          context,
        );
        expect(parseError.code, equals(-32700));
      });

      test('should apply multiple enhancers', () {
        final enhancer1 = MockErrorEnhancer(
          ErrorType.timeout,
          {'enhancer1': true},
        );
        final enhancer2 = MockErrorEnhancer(
          ErrorType.timeout,
          {'enhancer2': true},
        );
        
        enhancer.addEnhancer(enhancer1);
        enhancer.addEnhancer(enhancer2);

        final error = enhancer.enhanceError(
          ErrorType.timeout,
          'Operation timed out',
          context,
        );

        expect(error.data['enhancer1'], equals(true));
        expect(error.data['enhancer2'], equals(true));
      });
    });

    group('createServerCrashError', () {
      test('should create server crash error with stderr', () {
        final error = enhancer.createServerCrashError(1, 'stderr output');

        expect(error.code, equals(-32603));
        expect(error.message, contains('MCP server crashed'));
        expect(error.data['exit_code'], equals(1));
        expect(error.data['stderr'], equals('stderr output'));
        expect(error.data['proxy'], equals('mcp_dev_proxy'));
      });

      test('should create server crash error without stderr', () {
        final error = enhancer.createServerCrashError(2, null);

        expect(error.code, equals(-32603));
        expect(error.message, contains('MCP server crashed'));
        expect(error.data['exit_code'], equals(2));
        expect(error.data['stderr'], equals(''));
      });
    });

    group('createServerRestartError', () {
      test('should create server restart error', () {
        final error = enhancer.createServerRestartError('binary_updated');

        expect(error.code, equals(-32603));
        expect(error.message, contains('MCP server restarting'));
        expect(error.data['reason'], equals('binary_updated'));
        expect(error.data['proxy'], equals('mcp_dev_proxy'));
      });
    });

    group('createTimeoutError', () {
      test('should create timeout error', () {
        final timeout = const Duration(seconds: 30);
        final error = enhancer.createTimeoutError('test_operation', timeout);

        expect(error.code, equals(-32603));
        expect(error.message, equals('Operation timed out'));
        expect(error.data['operation'], equals('test_operation'));
        expect(error.data['timeout_ms'], equals(30000));
        expect(error.data['proxy'], equals('mcp_dev_proxy'));
        expect(error.data['recovery_hint'], contains('Check if the target server'));
      });
    });

    group('createToolInterruptedError', () {
      test('should create tool interrupted error', () {
        final error = enhancer.createToolInterruptedError(
          'tool_123',
          'binary_updated',
        );

        expect(error.code, equals(-32603));
        expect(error.message, equals('Tool execution interrupted by server restart'));
        expect(error.data['tool_use_id'], equals('tool_123'));
        expect(error.data['reason'], equals('binary_updated'));
        expect(error.data['proxy'], equals('mcp_dev_proxy'));
        expect(error.data['recovery_hint'], contains('/resume command'));
      });
    });
  });

  group('ErrorContext', () {
    test('should create context with default timestamp', () {
      final now = DateTime.now();
      final context = ErrorContext(detectedRuntime: 'dart');
      
      expect(context.detectedRuntime, equals('dart'));
      expect(context.timestamp.difference(now).inSeconds, lessThan(1));
    });

    test('should create context with custom timestamp', () {
      final customTime = DateTime(2023, 1, 1);
      final context = ErrorContext(
        detectedRuntime: 'python',
        timestamp: customTime,
      );
      
      expect(context.detectedRuntime, equals('python'));
      expect(context.timestamp, equals(customTime));
    });

    test('should copy with modifications', () {
      final original = ErrorContext(
        detectedRuntime: 'dart',
        targetCommand: 'dart run',
      );

      final modified = original.copyWith(
        detectedRuntime: 'python',
        workingDirectory: '/new/path',
      );

      expect(modified.detectedRuntime, equals('python'));
      expect(modified.targetCommand, equals('dart run')); // unchanged
      expect(modified.workingDirectory, equals('/new/path'));
    });

    test('should serialize to and from JSON', () {
      final original = ErrorContext(
        detectedRuntime: 'dart',
        targetCommand: 'dart run example.dart',
        environment: {'PATH': '/usr/bin'},
        workingDirectory: '/test/path',
        lastOutput: 'test output',
        timestamp: DateTime(2023, 1, 1, 12, 0, 0),
      );

      final json = original.toJson();
      final restored = ErrorContext.fromJson(json);

      expect(restored.detectedRuntime, equals(original.detectedRuntime));
      expect(restored.targetCommand, equals(original.targetCommand));
      expect(restored.environment, equals(original.environment));
      expect(restored.workingDirectory, equals(original.workingDirectory));
      expect(restored.lastOutput, equals(original.lastOutput));
      expect(restored.timestamp, equals(original.timestamp));
    });
  });
}