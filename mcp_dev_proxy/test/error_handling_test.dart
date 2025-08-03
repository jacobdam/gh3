import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Error Message Enhancement Tests', () {
    test('provides detailed guidance for missing binary', () async {
      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./missing_binary_test'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(milliseconds: 500));

      try {
        final statusRequest = {
          'jsonrpc': '2.0',
          'id': 'missing_binary_status',
          'method': 'tools/call',
          'params': {
            'name': 'proxy_status',
            'arguments': {}
          }
        };

        proxyInput.writeln(jsonEncode(statusRequest));

        final responseCompleter = Completer<String>();
        late StreamSubscription subscription;
        
        subscription = proxyOutput.listen((line) {
          try {
            final response = jsonDecode(line) as Map<String, dynamic>;
            if (response['id'] == 'missing_binary_status') {
              final content = response['result']['content'][0]['text'] as String;
              responseCompleter.complete(content);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final statusReport = await responseCompleter.future
            .timeout(Duration(seconds: 5));
        
        // Should contain comprehensive guidance
        expect(statusReport, contains('Binary not found'));
        expect(statusReport, contains('missing_binary_test'));
        expect(statusReport, contains('Compile your MCP server binary'));
        expect(statusReport, contains('dart compile exe'));
        expect(statusReport, contains('Proxy Capabilities'));
        expect(statusReport, contains('Crash Recovery'));
        expect(statusReport, contains('Hot Reload'));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
      }
    });

    test('includes proxy capabilities in all error responses', () async {
      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./unavailable_target'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(milliseconds: 500));

      try {
        // Send a request that will generate an error
        final badRequest = {
          'jsonrpc': '2.0',
          'id': 'capabilities_test',
          'method': 'unknown_method',
          'params': {}
        };

        proxyInput.writeln(jsonEncode(badRequest));

        final responseCompleter = Completer<Map<String, dynamic>>();
        late StreamSubscription subscription;
        
        subscription = proxyOutput.listen((line) {
          try {
            final response = jsonDecode(line) as Map<String, dynamic>;
            if (response['id'] == 'capabilities_test') {
              responseCompleter.complete(response);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final errorResponse = await responseCompleter.future
            .timeout(Duration(seconds: 5));
        
        expect(errorResponse['error'], isNotNull);
        final errorData = errorResponse['error']['data'];
        expect(errorData['proxy_capabilities'], isA<List>());
        expect(errorData['proxy_capabilities'], contains('crash_recovery'));
        expect(errorData['proxy_capabilities'], contains('hot_reload'));
        expect(errorData['proxy_capabilities'], contains('error_buffering'));
        expect(errorData['proxy_capabilities'], contains('debug_info'));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
      }
    });

    test('provides comprehensive help text', () async {
      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./help_test_target'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(milliseconds: 500));

      try {
        final helpRequest = {
          'jsonrpc': '2.0',
          'id': 'help_test',
          'method': 'tools/call',
          'params': {
            'name': 'proxy_help',
            'arguments': {}
          }
        };

        proxyInput.writeln(jsonEncode(helpRequest));

        final responseCompleter = Completer<String>();
        late StreamSubscription subscription;
        
        subscription = proxyOutput.listen((line) {
          try {
            final response = jsonDecode(line) as Map<String, dynamic>;
            if (response['id'] == 'help_test') {
              final content = response['result']['content'][0]['text'] as String;
              responseCompleter.complete(content);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final helpText = await responseCompleter.future
            .timeout(Duration(seconds: 5));
        
        // Should contain comprehensive guidance
        expect(helpText, contains('MCP Development Proxy Help'));
        expect(helpText, contains('What This Proxy Does'));
        expect(helpText, contains('How to Work With the Proxy'));
        expect(helpText, contains('Compile Your MCP Server'));
        expect(helpText, contains('Update Your Binary'));
        expect(helpText, contains('Handle Crashes'));
        expect(helpText, contains('Integration Tips'));
        expect(helpText, contains('Current Configuration'));
        expect(helpText, contains('help_test_target'));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
      }
    });

    test('provides contextual error messages for different scenarios', () async {
      // Test startup failure scenario
      final nonExecutableFile = File('./non_executable_test');
      await nonExecutableFile.writeAsString('not executable');
      // Don't make it executable

      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./non_executable_test'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(seconds: 2));

      try {
        final statusRequest = {
          'jsonrpc': '2.0',
          'id': 'startup_failure_test',
          'method': 'tools/call',
          'params': {
            'name': 'proxy_status',
            'arguments': {}
          }
        };

        proxyInput.writeln(jsonEncode(statusRequest));

        final responseCompleter = Completer<String>();
        late StreamSubscription subscription;
        
        subscription = proxyOutput.listen((line) {
          try {
            final response = jsonDecode(line) as Map<String, dynamic>;
            if (response['id'] == 'startup_failure_test') {
              final content = response['result']['content'][0]['text'] as String;
              responseCompleter.complete(content);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final statusReport = await responseCompleter.future
            .timeout(Duration(seconds: 5));
        
        expect(statusReport, anyOf([
          contains('Binary exists but process failed to start'),
          contains('Check if it\'s executable'),
          contains('Startup Error'),
          contains('Permission denied')
        ]));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
        await nonExecutableFile.delete();
      }
    });

    test('initialize response contains helpful instructions', () async {
      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./init_instructions_test'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(milliseconds: 500));

      try {
        final initRequest = {
          'jsonrpc': '2.0',
          'id': 'init_instructions',
          'method': 'initialize',
          'params': {
            'protocolVersion': '2024-11-05',
            'capabilities': {},
            'clientInfo': {'name': 'instructions_test', 'version': '1.0'}
          }
        };

        proxyInput.writeln(jsonEncode(initRequest));

        final responseCompleter = Completer<Map<String, dynamic>>();
        late StreamSubscription subscription;
        
        subscription = proxyOutput.listen((line) {
          try {
            final response = jsonDecode(line) as Map<String, dynamic>;
            if (response['id'] == 'init_instructions') {
              responseCompleter.complete(response);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final initResponse = await responseCompleter.future
            .timeout(Duration(seconds: 5));
        
        final instructions = initResponse['result']['instructions'] as String;
        expect(instructions, contains('Target MCP server is not available'));
        expect(instructions, contains('Expected Binary'));
        expect(instructions, contains('Action Needed'));
        expect(instructions, contains('Proxy Capabilities'));
        expect(instructions, contains('proxy_status'));
        expect(instructions, contains('proxy_help'));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
      }
    });
  });

  group('Recovery Guidance Tests', () {
    test('provides specific recovery steps for API errors', () async {
      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./recovery_test_target'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(milliseconds: 500));

      try {
        // Simulate incomplete tool cycle scenario
        final toolCall = {
          'jsonrpc': '2.0',
          'id': 'recovery_test_tool',
          'method': 'tools/call',
          'params': {
            'name': 'non_existent_tool',
            'arguments': {}
          }
        };

        proxyInput.writeln(jsonEncode(toolCall));
        await Future.delayed(Duration(milliseconds: 200));

        // Check tool cycles for recovery guidance
        final checkCyclesRequest = {
          'jsonrpc': '2.0',
          'id': 'recovery_guidance',
          'method': 'tools/call',
          'params': {
            'name': 'proxy_check_tool_cycles',
            'arguments': {}
          }
        };

        proxyInput.writeln(jsonEncode(checkCyclesRequest));

        final responseCompleter = Completer<String>();
        late StreamSubscription subscription;
        
        subscription = proxyOutput.listen((line) {
          try {
            final response = jsonDecode(line) as Map<String, dynamic>;
            if (response['id'] == 'recovery_guidance') {
              final content = response['result']['content'][0]['text'] as String;
              responseCompleter.complete(content);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final recoveryGuide = await responseCompleter.future
            .timeout(Duration(seconds: 5));
        
        expect(recoveryGuide, contains('/resume'));
        expect(recoveryGuide, contains('fresh session'));
        expect(recoveryGuide, contains('API Error: 400'));
        expect(recoveryGuide, contains('tool_use ids were found without tool_result'));
        expect(recoveryGuide, contains('Prevention'));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
      }
    });
  });
}