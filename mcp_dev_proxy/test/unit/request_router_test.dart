import 'package:test/test.dart';
import '../../lib/src/routing/request_router.dart';

void main() {
  group('RequestRouter - MCP Proxy Usage', () {
    late RequestRouter router;

    setUp(() {
      router = RequestRouter();
    });

    group('Basic MCP Method Routing', () {
      test('should handle MCP standard methods', () {
        final mcpHandler = _MockMCPHandler();
        
        // Register standard MCP methods
        router.registerRoute('initialize', mcpHandler);
        router.registerRoute('tools/list', mcpHandler);
        router.registerRoute('tools/call', mcpHandler);
        router.registerRoute('resources/list', mcpHandler);
        
        expect(router.canHandle('initialize'), isTrue);
        expect(router.canHandle('tools/list'), isTrue);
        expect(router.canHandle('tools/call'), isTrue);
        expect(router.canHandle('resources/list'), isTrue);
        expect(router.canHandle('unknown/method'), isFalse);
      });

      test('should route MCP requests correctly', () async {
        final mcpHandler = _MockMCPHandler();
        router.registerRoute('tools/list', mcpHandler);
        
        final context = RequestContext('tools/list', {}, 'test-123');
        final result = await router.routeRequest('tools/list', {}, context);
        
        expect(mcpHandler.wasCalled, isTrue);
        expect(mcpHandler.lastMethod, equals('tools/list'));
        expect(result['status'], equals('handled'));
      });
    });

    group('Proxy Tool Routing', () {
      test('should handle proxy-specific tools', () {
        final proxyHandler = _MockProxyHandler();
        
        // Register proxy tools
        router.registerRoute('proxy_status', proxyHandler);
        router.registerRoute('proxy_help', proxyHandler);
        router.registerRoute('proxy_restart', proxyHandler);
        
        expect(router.canHandle('proxy_status'), isTrue);
        expect(router.canHandle('proxy_help'), isTrue);
        expect(router.canHandle('proxy_restart'), isTrue);
      });

      test('should route proxy tool requests', () async {
        final proxyHandler = _MockProxyHandler();
        router.registerRoute('proxy_status', proxyHandler);
        
        final context = RequestContext('proxy_status', {}, 'proxy-456');
        final result = await router.routeRequest('proxy_status', {}, context);
        
        expect(proxyHandler.wasCalled, isTrue);
        expect(result['proxy_tool'], isTrue);
      });
    });

    group('Error Handling', () {
      test('should throw exception for unregistered methods', () {
        final context = RequestContext('unknown/method', {}, 'error-789');
        
        expect(
          () => router.routeRequest('unknown/method', {}, context),
          throwsA(isA<RouteNotFoundException>()),
        );
      });
    });

    group('Request Context', () {
      test('should create context with method and id', () {
        final context = RequestContext('test/method', {'key': 'value'}, 'ctx-123');
        
        expect(context.method, equals('test/method'));
        expect(context.id, equals('ctx-123'));
        expect(context.params, equals({'key': 'value'}));
      });
    });
  });
}

// Minimal test doubles for MCP proxy usage
class _MockMCPHandler extends RequestHandler {
  bool wasCalled = false;
  String? lastMethod;

  @override
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    wasCalled = true;
    lastMethod = context.method;
    return {'status': 'handled', 'method': context.method};
  }
}

class _MockProxyHandler extends RequestHandler {
  bool wasCalled = false;

  @override
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    wasCalled = true;
    return {'proxy_tool': true, 'method': context.method};
  }
}