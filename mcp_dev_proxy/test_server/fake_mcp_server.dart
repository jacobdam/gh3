#!/usr/bin/env dart

import "dart:io";
import "dart:convert";

/// A simple fake MCP server for testing the proxy
/// Responds predictably to various test scenarios
void main(List<String> args) async {
  // Parse command line arguments for test modes
  final isSlowMode = args.contains("--slow");
  final isCrashMode = args.contains("--crash");
  final isErrorMode = args.contains("--error");

  stderr.writeln("[FAKE-MCP] Starting fake MCP server");
  stderr.writeln("[FAKE-MCP] Args: ${args.join(" ")}");

  await stdin
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) async {
    stderr.writeln("[FAKE-MCP] Received: $line");

    try {
      final message = jsonDecode(line) as Map<String, dynamic>;
      final method = message["method"] as String?;
      final id = message["id"];

      // Handle different test scenarios
      if (isCrashMode && method == "crash_test") {
        stderr.writeln("[FAKE-MCP] CRASH TEST - Exiting with error!");
        exit(42); // Exit with specific code for testing
      }

      if (isErrorMode && method == "error_test") {
        final errorResponse = {
          "jsonrpc": "2.0",
          "id": id,
          "error": {
            "code": -32601,
            "message": "Method not found",
            "data": "fake_error_for_testing"
          }
        };
        stdout.writeln(jsonEncode(errorResponse));
        return;
      }

      // Add delay for slow mode testing
      if (isSlowMode) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      // Generate appropriate response based on method
      final response = _generateResponse(method, id);

      stderr.writeln("[FAKE-MCP] Sending: ${jsonEncode(response)}");
      stdout.writeln(jsonEncode(response));
    } catch (e) {
      stderr.writeln("[FAKE-MCP] Error parsing JSON: $e");
      // Invalid JSON - just ignore for testing
    }
  }).asFuture<void>();
}

Map<String, dynamic> _generateResponse(String? method, dynamic id) {
  switch (method) {
    case "tools/list":
      return {
        "jsonrpc": "2.0",
        "id": id,
        "result": {
          "tools": [
            {
              "name": "fake_tool",
              "description": "A fake tool for testing",
              "inputSchema": {
                "type": "object",
                "properties": {
                  "test_param": {"type": "string"}
                }
              }
            }
          ]
        }
      };

    case "resources/list":
      return {
        "jsonrpc": "2.0",
        "id": id,
        "result": {
          "resources": [
            {
              "uri": "fake://test-resource",
              "name": "Test Resource",
              "description": "A fake resource for testing"
            }
          ]
        }
      };

    case "ping":
      return {
        "jsonrpc": "2.0",
        "id": id,
        "result": {
          "status": "pong",
          "timestamp": DateTime.now().toIso8601String()
        }
      };

    case "fake_tool":
      return {
        "jsonrpc": "2.0",
        "id": id,
        "result": {
          "success": true,
          "message": "Fake tool executed successfully",
          "test_data": "fake_response_data"
        }
      };

    case "slow_test":
      return {
        "jsonrpc": "2.0",
        "id": id,
        "result": {"message": "Slow response completed", "delay": "simulated"}
      };

    default:
      return {
        "jsonrpc": "2.0",
        "id": id,
        "result": {
          "echo": method,
          "message": "Unknown method echoed back",
          "fake_server": true
        }
      };
  }
}
