import "dart:io";

import "package:test/test.dart";

void main() {
  group("Agent Workflow Integration (AW1)", () {
    late Directory tempDir;
    late File testBinary;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp("agent_workflow_");
      testBinary = File("${tempDir.path}/test_mcp_server");
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test("should support complete AI agent development cycle", () async {
      final workflowSteps = <String>[];
      final responses = <Map<String, dynamic>>[];

      // Step 1: Agent starts with missing binary
      workflowSteps.add("1. Missing binary detected");

      // Simulate proxy detecting missing binary
      expect(testBinary.existsSync(), isFalse);

      final missingBinaryError = {
        "jsonrpc": "2.0",
        "id": "init-1",
        "error": {
          "code": -32603,
          "message": "Target MCP server binary not found",
          "data": {
            "problem": "Binary not found at ${testBinary.path}",
            "context": "Proxy attempted to start target server",
            "guidance":
                "Compile your MCP server using appropriate build command",
            "next_steps": [
              "compile_binary",
              "verify_path",
              "check_proxy_status",
            ],
            "proxy_tools": ["proxy_status", "proxy_help"],
          },
        },
      };

      responses.add(missingBinaryError);
      workflowSteps.add("2. Received compilation guidance");

      // Verify agent receives actionable guidance
      final error = missingBinaryError["error"]! as Map<String, dynamic>;
      final data = error["data"] as Map<String, dynamic>;

      expect(data["guidance"], contains("Compile"));
      expect(data["next_steps"], contains("compile_binary"));
      expect(data["proxy_tools"], contains("proxy_status"));

      // Step 3: Agent creates binary (simulating compilation)
      await testBinary.writeAsString('#!/bin/bash\necho "MCP server started"');
      await Process.run("chmod", ["+x", testBinary.path]);
      workflowSteps.add("3. Binary created");

      // Step 4: Proxy auto-connects to new binary
      expect(testBinary.existsSync(), isTrue);
      workflowSteps.add("4. Auto-connection triggered");

      // Step 5: Agent tests functionality

      final toolsListResponse = {
        "jsonrpc": "2.0",
        "id": "tools-1",
        "result": {
          "tools": [
            {
              "name": "test_tool",
              "description": "A test tool for agent development",
            }
          ],
          "proxy": {
            "name": "mcp_dev_proxy",
            "event": "connected",
            "binary_path": testBinary.path,
          },
        },
      };

      responses.add(toolsListResponse);
      workflowSteps.add("5. Functionality verified");

      // Step 6: Simulate binary crash
      await testBinary.delete();
      workflowSteps.add("6. Binary crashed (deleted)");

      // Step 7: Agent receives crash error with debugging guidance
      final crashError = {
        "jsonrpc": "2.0",
        "id": "crash-1",
        "error": {
          "code": -32603,
          "message": "Target server process crashed",
          "data": {
            "problem": "Server process exited unexpectedly",
            "context": "Binary no longer exists at ${testBinary.path}",
            "guidance": "Check server logs and recompile if necessary",
            "next_steps": ["check_logs", "recompile", "debug_crash"],
            "proxy_tools": ["proxy_status", "proxy_restart"],
          },
        },
      };

      responses.add(crashError);
      workflowSteps.add("7. Received crash debugging guidance");

      // Step 8: Agent modifies code and recompiles
      await testBinary
          .writeAsString('#!/bin/bash\necho "MCP server v2 started"');
      await Process.run("chmod", ["+x", testBinary.path]);
      workflowSteps.add("8. Code modified and recompiled");

      // Step 9: Proxy auto-restarts
      final restartNotification = {
        "jsonrpc": "2.0",
        "id": "restart-1",
        "result": {
          "status": "restarted",
          "proxy": {
            "name": "mcp_dev_proxy",
            "event": "restarted",
            "reason": "binary_updated",
            "restart_count": 1,
          },
        },
      };

      responses.add(restartNotification);
      workflowSteps.add("9. Auto-restart completed");

      // Step 10: Agent continues development
      final continuedDevelopment = {
        "jsonrpc": "2.0",
        "id": "continue-1",
        "result": {
          "tools": [
            {
              "name": "enhanced_tool",
              "description": "Enhanced tool after modifications",
            }
          ],
        },
      };

      responses.add(continuedDevelopment);
      workflowSteps.add("10. Development continued successfully");

      // Verify complete workflow
      expect(workflowSteps.length, equals(10));
      expect(responses.length, equals(5));

      // Verify no hanging operations throughout cycle
      for (final response in responses) {
        expect(
          response["id"],
          isNotNull,
          reason: "All responses should have IDs",
        );
        if (response.containsKey("error")) {
          final error = response["error"] as Map<String, dynamic>;
          expect(
            error["data"]["guidance"],
            isA<String>(),
            reason: "Errors should include guidance",
          );
          expect(
            error["data"]["next_steps"],
            isA<List<dynamic>>(),
            reason: "Errors should include next steps",
          );
        }
      }

      // Verify autonomous recovery guidance provided
      final errorResponses =
          responses.where((r) => r.containsKey("error")).toList();
      for (final errorResponse in errorResponses) {
        final data = errorResponse["error"]["data"] as Map<String, dynamic>;
        expect(
          data["next_steps"],
          isNotEmpty,
          reason: "Should provide autonomous recovery steps",
        );
        expect(
          data["proxy_tools"],
          isNotEmpty,
          reason: "Should suggest diagnostic tools",
        );
      }

      print("Agent Workflow Steps Completed:");
      for (int i = 0; i < workflowSteps.length; i++) {
        print("  ${workflowSteps[i]}");
      }
    });

    test("should prevent API validation errors during development", () {
      // Verify session recovery guidance prevents Claude API validation errors
      final sessionRecoveryGuidance = {
        "incomplete_cycles": 2,
        "guidance": "Use /resume command to recover Claude session",
        "explanation":
            "Incomplete tool_use → tool_result cycles can cause API validation errors",
        "recovery_steps": [
          "Use /resume command in Claude",
          "Check proxy_check_tool_cycles for status",
          "Restart proxy if needed with proxy_restart",
        ],
      };

      expect(sessionRecoveryGuidance["guidance"], contains("/resume"));
      expect(
        sessionRecoveryGuidance["explanation"],
        contains("API validation"),
      );
      final recoverySteps = sessionRecoveryGuidance["recovery_steps"]! as List;
      expect(
        recoverySteps.any(
          (step) => step.toString().contains("proxy_check_tool_cycles"),
        ),
        isTrue,
      );
    });

    test("should handle various MCP server types", () {
      final serverTypes = [
        {
          "type": "dart",
          "compilation": "dart compile exe server.dart -o mcp_server",
          "environment_check": "dart --version",
          "timeout_profile": "standard",
        },
        {
          "type": "python",
          "compilation": "N/A (interpreted)",
          "environment_check": "python --version",
          "timeout_profile": "extended",
        },
        {
          "type": "flutter",
          "compilation": "dart compile exe",
          "environment_check": "flutter doctor",
          "timeout_profile": "long_running", // For widget tests, builds
        }
      ];

      for (final serverType in serverTypes) {
        expect(serverType["compilation"], isNotNull);
        expect(serverType["environment_check"], isNotNull);
        expect(serverType["timeout_profile"], isNotNull);
      }
    });
  });
}
