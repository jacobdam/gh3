import "dart:convert";
import "dart:io";

import "package:logging/logging.dart";

import "../../mcp_protocol.dart";
import "../core/proxy_state.dart";
import "../core/tool_cycle_tracker.dart";
import "../enhancers/error_context.dart";
import "../enhancers/response_enhancer.dart";
import "../managers/timeout_manager.dart";

/// Coordinates error handling across all proxy components.
///
/// This class is responsible for:
/// - Managing error responses for failed requests
/// - Coordinating timeout error handling
/// - Managing error responses during restarts and crashes
/// - Sending structured error messages to clients
class ErrorCoordinator {
  ErrorCoordinator({
    required ResponseEnhancer responseEnhancer,
    required TimeoutManager timeoutManager,
    required ProxyState proxyState,
    required ToolCycleTracker toolCycleTracker,
    required IOSink stdoutSink,
    required String targetBinary,
  })  : _responseEnhancer = responseEnhancer,
        _timeoutManager = timeoutManager,
        _proxyState = proxyState,
        _toolCycleTracker = toolCycleTracker,
        _stdoutSink = stdoutSink,
        _targetBinary = targetBinary;

  final Logger _logger = Logger("ErrorCoordinator");
  final ResponseEnhancer _responseEnhancer;
  final TimeoutManager _timeoutManager;
  final ProxyState _proxyState;
  final ToolCycleTracker _toolCycleTracker;
  final IOSink _stdoutSink;
  final String _targetBinary;

  /// Handles process crash by sending errors to all pending requests.
  void handleProcessCrash(int exitCode, String? stderr) {
    _logger.warning("Handling process crash with exit code: $exitCode");

    final crashError =
        _responseEnhancer.createServerCrashError(exitCode, stderr);

    // Send error responses for all pending requests
    for (final entry in _proxyState.pendingRequests.entries) {
      sendErrorToClient(entry.key, crashError.toJson());
    }
    _proxyState.clearAllPendingRequests();
  }

  /// Handles restart by sending errors to all pending requests and tool cycles.
  void handleRestart(String reason) {
    _logger.info("Handling restart coordination: $reason");

    _proxyState.markRestartPending(reason);

    // Send error responses for all pending requests
    final restartError = _responseEnhancer.createServerRestartError(reason);
    for (final entry in _proxyState.pendingRequests.entries) {
      sendErrorToClient(entry.key, restartError.toJson());
    }
    _proxyState.clearAllPendingRequests();

    // Also send error responses for incomplete tool_use cycles
    for (final toolUseId in _proxyState.pendingToolUses) {
      _logger.warning("Sending error for incomplete tool_use: $toolUseId");
      _toolCycleTracker.markCycleInterrupted(toolUseId, reason);
      final toolError =
          _responseEnhancer.createToolInterruptedError(toolUseId, reason);
      sendErrorToClient(toolUseId, toolError.toJson());
    }
    _proxyState.clearAllPendingToolUses();

    // Cancel all pending timeouts
    _timeoutManager.dispose();
  }

  /// Handles request timeout by sending timeout error to client.
  void handleRequestTimeout(String requestId, String method) {
    _logger.warning("Request timeout: $requestId ($method)");

    final timeout = _timeoutManager.getTimeout(method, <String, dynamic>{});
    final operationContext = {
      "proxy": "mcp_dev_proxy",
      "proxy_capabilities": [
        "crash_recovery",
        "hot_reload",
        "error_buffering",
        "debug_info",
      ],
      "recovery_hint":
          "The target MCP server may be unresponsive. Check server logs or restart the connection.",
    };

    final timeoutErrorData = _timeoutManager.createTimeoutError(
      requestId,
      method,
      timeout,
      operationContext,
    );

    sendErrorToClient(
        requestId, timeoutErrorData["error"] as Map<String, dynamic>);
    _proxyState.removePendingRequest(requestId);
  }

  /// Handles server unavailable scenario by creating appropriate error.
  Map<String, dynamic> createServerUnavailableError(MCPMessage message,
      [Exception? exception]) {
    final context = ErrorContext(
      targetCommand: _targetBinary,
      lastOutput: _proxyState.startupError,
      workingDirectory: Directory.current.path,
      environment: {
        "binaryExists": File(_targetBinary).existsSync().toString(),
      },
    );

    final error = _responseEnhancer.createServerUnavailableError(
      context,
      additionalData: {
        if (exception != null) "error": exception.toString(),
        "method": message.method,
      },
    );

    return error.toJson();
  }

  /// Sends an error message to the client.
  void sendErrorToClient(dynamic requestId, Map<String, dynamic> error) {
    try {
      final errorResponse = MCPMessage(
        jsonrpc: "2.0",
        id: requestId,
        error: MCPError(
          code: error["code"] as int? ?? -32603,
          message: error["message"] as String? ?? "Internal error",
          data: error["data"],
        ),
      );

      final responseJson = jsonEncode(errorResponse.toJson());
      _stdoutSink.writeln(responseJson);
      _logger.fine("Error sent to client: ${error["message"]}");
    } on Exception catch (e) {
      _logger.severe("Failed to send error to client: $e");
    }
  }

  /// Sends a message to the client.
  void sendToClient(MCPMessage message) {
    try {
      final messageJson = jsonEncode(message.toJson());
      _stdoutSink.writeln(messageJson);
      _logger.fine("Message sent to client: ${message.method ?? "response"}");
    } on Exception catch (e) {
      _logger.severe("Failed to send message to client: $e");
    }
  }

  /// Gets current error handling statistics.
  Map<String, dynamic> getErrorStats() {
    return {
      "pending_requests": _proxyState.pendingRequests.length,
      "pending_tool_uses": _proxyState.pendingToolUses.length,
      "startup_error": _proxyState.startupError,
      "restart_pending": _proxyState.restartPending,
      "last_restart_reason": _proxyState.lastRestartReason,
    };
  }
}
