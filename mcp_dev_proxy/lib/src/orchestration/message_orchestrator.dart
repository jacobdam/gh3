import "dart:async";

import "package:logging/logging.dart";

import "../../mcp_protocol.dart";
import "../../process_manager.dart";
import "../core/proxy_state.dart";
import "../orchestration/error_coordinator.dart";
import "../routing/request_router.dart";

/// Handles all message processing and routing for the MCP Development Proxy.
///
/// This class is responsible for:
/// - Parsing incoming client messages
/// - Routing messages through the appropriate handlers
/// - Managing message flow coordination
class MessageOrchestrator {
  MessageOrchestrator({
    required RequestRouter requestRouter,
    required ProxyState proxyState,
    required ProcessManager processManager,
    required ErrorCoordinator errorCoordinator,
  })  : _requestRouter = requestRouter,
        _proxyState = proxyState,
        _processManager = processManager,
        _errorCoordinator = errorCoordinator;

  final Logger _logger = Logger("MessageOrchestrator");
  final RequestRouter _requestRouter;
  final ProxyState _proxyState;
  final ProcessManager _processManager;
  final ErrorCoordinator _errorCoordinator;

  /// Handles incoming client input by parsing and routing messages.
  Future<void> handleClientInput(String line) async {
    _logger.fine("Processing client input: ${line.length} characters");

    final message = MCPProtocol.parseMessage(line);
    if (message == null) {
      _logger.warning("Failed to parse message, ignoring: $line");
      return;
    }

    await handleMessage(message);
  }

  /// Routes a parsed MCP message through the appropriate handler.
  Future<void> handleMessage(MCPMessage message) async {
    _logger.fine("Handling ${message.method} message with ID: ${message.id}");

    // Track message in proxy state
    if (message.isRequest && message.id != null) {
      _proxyState.addPendingRequest(message.id, message);
    }

    // Handle special cases when target is not available
    if (!_processManager.isRunning) {
      if (message.isRequest && message.id != null) {
        await _routeRequestWhenUnavailable(message);
      }
      return;
    }

    // Forward to target process when available
    try {
      final line = MCPProtocol.formatMessage(message);
      _processManager.sendMessage(line);
    } on Exception catch (e) {
      _logger.warning("Failed to forward message to target: $e");
      if (message.isRequest && message.id != null) {
        final error =
            _errorCoordinator.createServerUnavailableError(message, e);
        _errorCoordinator.sendErrorToClient(message.id, error);
      }
    }
  }

  /// Route requests through request router when target is unavailable
  Future<void> _routeRequestWhenUnavailable(MCPMessage message) async {
    final method = message.method;

    if (method != null && _requestRouter.canHandle(method)) {
      try {
        final params =
            message.params as Map<String, dynamic>? ?? <String, dynamic>{};
        final context =
            RequestContext(method, params, message.id?.toString() ?? "");
        final result =
            await _requestRouter.routeRequest(method, params, context);

        final response = MCPMessage(
          jsonrpc: "2.0",
          id: message.id,
          result: result,
        );
        _errorCoordinator.sendToClient(response);
      } on Exception catch (e) {
        _logger.warning("Failed to route request through RequestRouter: $e");
        final error =
            _errorCoordinator.createServerUnavailableError(message, e);
        _errorCoordinator.sendErrorToClient(message.id, error);
      }
    } else if (method == "tools/call") {
      // Handle proxy tools via request router
      final params =
          message.params as Map<String, dynamic>? ?? <String, dynamic>{};
      final toolName = params["name"] as String?;

      if (toolName == null) {
        _errorCoordinator.sendErrorToClient(
          message.id,
          {
            "code": -32602,
            "message": "Missing tool name in request",
          },
        );
        return;
      }

      try {
        final context =
            RequestContext(toolName, params, message.id?.toString() ?? "");
        final result =
            await _requestRouter.routeRequest(toolName, params, context);

        final response = MCPMessage(
          jsonrpc: "2.0",
          id: message.id,
          result: result,
        );
        _errorCoordinator.sendToClient(response);
      } on Exception catch (e) {
        if (e is RouteNotFoundException) {
          _errorCoordinator.sendErrorToClient(
            message.id,
            {
              "code": -32601,
              "message": "Unknown tool: $toolName",
            },
          );
        } else {
          _errorCoordinator.sendErrorToClient(
            message.id,
            {
              "code": -32603,
              "message": "Internal error: $e",
            },
          );
        }
      }
    } else {
      // For unhandled methods, send standard unavailable error
      final error = _errorCoordinator.createServerUnavailableError(message);
      _errorCoordinator.sendErrorToClient(message.id, error);
    }
  }

  /// Gets current message processing statistics.
  Map<String, dynamic> getMessageStats() {
    return {
      "pending_requests": _proxyState.pendingRequests.length,
    };
  }
}
