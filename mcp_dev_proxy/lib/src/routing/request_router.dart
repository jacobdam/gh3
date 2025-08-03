/// Request routing system for MCP Dev Proxy
///
/// Provides method-based request routing with middleware support.
library;

/// Exception thrown when a route is not found for a given method
class RouteNotFoundException implements Exception {
  final String method;

  const RouteNotFoundException(this.method);

  @override
  String toString() => "Route not found for method: $method";
}

/// Context object passed through request handling pipeline
class RequestContext {
  final String method;
  final Map<String, dynamic> params;
  final String id;
  final Map<String, dynamic> _metadata = {};

  RequestContext(this.method, this.params, this.id);

  /// Store metadata for the request
  void setMetadata(String key, dynamic value) {
    _metadata[key] = value;
  }

  /// Retrieve metadata for the request
  T? getMetadata<T>(String key) {
    return _metadata[key] as T?;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestContext &&
          runtimeType == other.runtimeType &&
          method == other.method &&
          id == other.id;

  @override
  int get hashCode => method.hashCode ^ id.hashCode;
}

/// Abstract base class for request handlers
abstract class RequestHandler {
  /// Handle the request with given parameters and context
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  );
}

/// Abstract base class for request middleware
abstract class RequestMiddleware {
  /// Called before request handling
  Future<void> beforeRequest(RequestContext context);

  /// Called after request handling
  Future<void> afterRequest(RequestContext context);
}

/// Main request router class providing method-based routing
class RequestRouter {
  final Map<String, RequestHandler> _routes = {};
  final List<RequestMiddleware> _middleware = [];

  /// Register a route handler for the given method
  void registerRoute(String method, RequestHandler handler) {
    _routes[method] = handler;
  }

  /// Add middleware to the processing pipeline
  void addMiddleware(RequestMiddleware middleware) {
    _middleware.add(middleware);
  }

  /// Check if the router can handle the given method
  bool canHandle(String method) {
    return _routes.containsKey(method);
  }

  /// Get list of all supported methods
  List<String> getSupportedMethods() {
    return _routes.keys.toList();
  }

  /// Get list of registered middleware (for testing)
  List<RequestMiddleware> getMiddleware() {
    return List.unmodifiable(_middleware);
  }

  /// Route a request to the appropriate handler
  ///
  /// Executes middleware before and after the handler.
  /// Throws [RouteNotFoundException] if no handler is registered for the method.
  Future<Map<String, dynamic>> routeRequest(
    String method,
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    final handler = _routes[method];
    if (handler == null) {
      throw RouteNotFoundException(method);
    }

    // Execute before middleware
    for (final middleware in _middleware) {
      await middleware.beforeRequest(context);
    }

    try {
      // Execute handler
      final result = await handler.handle(params, context);

      // Execute after middleware
      for (final middleware in _middleware.reversed) {
        await middleware.afterRequest(context);
      }

      return result;
    } catch (e) {
      // Still run after middleware on error, but don"t catch their exceptions
      for (final middleware in _middleware.reversed) {
        await middleware.afterRequest(context);
      }
      rethrow;
    }
  }
}
