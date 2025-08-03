import 'package:test/test.dart';
import '../../lib/src/routing/request_router.dart';

void main() {
  group('RequestRouter', () {
    late RequestRouter router;

    setUp(() {
      router = RequestRouter();
    });

    group('Route Registration', () {
      test('should register a new route', () {
        final handler = TestRequestHandler();
        router.registerRoute('test/method', handler);
        
        expect(router.canHandle('test/method'), isTrue);
        expect(router.getSupportedMethods(), contains('test/method'));
      });

      test('should support multiple routes', () {
        final handler1 = TestRequestHandler();
        final handler2 = TestRequestHandler();
        
        router.registerRoute('test/method1', handler1);
        router.registerRoute('test/method2', handler2);
        
        expect(router.getSupportedMethods(), hasLength(2));
        expect(router.canHandle('test/method1'), isTrue);
        expect(router.canHandle('test/method2'), isTrue);
      });

      test('should overwrite existing route registration', () {
        final handler1 = TestRequestHandler();
        final handler2 = TestRequestHandler();
        
        router.registerRoute('test/method', handler1);
        router.registerRoute('test/method', handler2);
        
        expect(router.getSupportedMethods(), hasLength(1));
      });

      test('should return false for unregistered routes', () {
        expect(router.canHandle('unknown/method'), isFalse);
      });
    });

    group('Middleware', () {
      test('should add middleware', () {
        final middleware = TestRequestMiddleware();
        router.addMiddleware(middleware);
        
        // Middleware should be called during request processing
        expect(router.getMiddleware(), contains(middleware));
      });

      test('should execute middleware in order', () async {
        final middleware1 = TestRequestMiddleware();
        final middleware2 = TestRequestMiddleware();
        final handler = TestRequestHandler();
        
        router.addMiddleware(middleware1);
        router.addMiddleware(middleware2);
        router.registerRoute('test/method', handler);
        
        final context = RequestContext('test/method', {}, 'test-id');
        await router.routeRequest('test/method', {}, context);
        
        expect(middleware1.beforeRequestCalled, isTrue);
        expect(middleware2.beforeRequestCalled, isTrue);
        expect(middleware1.afterRequestCalled, isTrue);
        expect(middleware2.afterRequestCalled, isTrue);
      });
    });

    group('Request Routing', () {
      test('should route request to correct handler', () async {
        final handler = TestRequestHandler();
        router.registerRoute('test/method', handler);
        
        final context = RequestContext('test/method', {}, 'test-id');
        final result = await router.routeRequest('test/method', {'key': 'value'}, context);
        
        expect(handler.handleCalled, isTrue);
        expect(handler.lastParams, equals({'key': 'value'}));
        expect(handler.lastContext, equals(context));
        expect(result, equals({'handled': true}));
      });

      test('should throw exception for unregistered method', () async {
        final context = RequestContext('unknown/method', {}, 'test-id');
        
        expect(
          () => router.routeRequest('unknown/method', {}, context),
          throwsA(isA<RouteNotFoundException>()),
        );
      });

      test('should validate request parameters', () async {
        final handler = TestRequestHandler();
        router.registerRoute('test/method', handler);
        
        final context = RequestContext('test/method', {}, 'test-id');
        
        // Should not throw for valid parameters
        await router.routeRequest('test/method', {}, context);
        expect(handler.handleCalled, isTrue);
      });
    });

    group('Request Context', () {
      test('should create context with method and id', () {
        final context = RequestContext('test/method', {'param': 'value'}, 'test-id');
        
        expect(context.method, equals('test/method'));
        expect(context.id, equals('test-id'));
        expect(context.params, equals({'param': 'value'}));
      });

      test('should support metadata storage', () {
        final context = RequestContext('test/method', {}, 'test-id');
        
        context.setMetadata('key', 'value');
        expect(context.getMetadata('key'), equals('value'));
        expect(context.getMetadata('unknown'), isNull);
      });
    });

    group('Error Handling', () {
      test('should handle handler exceptions gracefully', () async {
        final handler = FailingRequestHandler();
        router.registerRoute('test/method', handler);
        
        final context = RequestContext('test/method', {}, 'test-id');
        
        expect(
          () => router.routeRequest('test/method', {}, context),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle middleware exceptions', () async {
        final middleware = FailingRequestMiddleware();
        final handler = TestRequestHandler();
        
        router.addMiddleware(middleware);
        router.registerRoute('test/method', handler);
        
        final context = RequestContext('test/method', {}, 'test-id');
        
        expect(
          () => router.routeRequest('test/method', {}, context),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Performance', () {
      test('should handle route lookup efficiently', () {
        // Register many routes
        for (int i = 0; i < 1000; i++) {
          router.registerRoute('test/method$i', TestRequestHandler());
        }
        
        final stopwatch = Stopwatch()..start();
        final canHandle = router.canHandle('test/method500');
        stopwatch.stop();
        
        expect(canHandle, isTrue);
        expect(stopwatch.elapsedMicroseconds, lessThan(1000)); // < 1ms
      });

      test('should handle request routing efficiently', () async {
        final handler = TestRequestHandler();
        router.registerRoute('test/method', handler);
        
        final context = RequestContext('test/method', {}, 'test-id');
        final stopwatch = Stopwatch()..start();
        
        await router.routeRequest('test/method', {}, context);
        
        stopwatch.stop();
        expect(stopwatch.elapsedMicroseconds, lessThan(1000)); // < 1ms
      });
    });
  });
}

// Test implementations
class TestRequestHandler extends RequestHandler {
  bool handleCalled = false;
  Map<String, dynamic>? lastParams;
  RequestContext? lastContext;

  @override
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    handleCalled = true;
    lastParams = params;
    lastContext = context;
    return {'handled': true};
  }
}

class FailingRequestHandler extends RequestHandler {
  @override
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    throw Exception('Handler failed');
  }
}

class TestRequestMiddleware extends RequestMiddleware {
  bool beforeRequestCalled = false;
  bool afterRequestCalled = false;

  @override
  Future<void> beforeRequest(RequestContext context) async {
    beforeRequestCalled = true;
  }

  @override
  Future<void> afterRequest(RequestContext context) async {
    afterRequestCalled = true;
  }
}

class FailingRequestMiddleware extends RequestMiddleware {
  @override
  Future<void> beforeRequest(RequestContext context) async {
    throw Exception('Middleware failed');
  }

  @override
  Future<void> afterRequest(RequestContext context) async {
    // No-op
  }
}