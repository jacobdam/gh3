import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Tool Cycle Detection Tests', () {
    test('detects incomplete tool_use cycles', () async {
      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./nonexistent_target'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(milliseconds: 500));

      try {
        // Send a tool call that will be tracked as incomplete
        final toolCallRequest = {
          'jsonrpc': '2.0',
          'id': 'test_tool_123',
          'method': 'tools/call',
          'params': {
            'name': 'some_tool',
            'arguments': {'param': 'value'}
          }
        };

        proxyInput.writeln(jsonEncode(toolCallRequest));
        await Future.delayed(Duration(milliseconds: 200));

        // Now check tool cycles - should show the incomplete tool
        final checkCyclesRequest = {
          'jsonrpc': '2.0',
          'id': 'check_cycles',
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
            if (response['id'] == 'check_cycles') {
              final content = response['result']['content'][0]['text'] as String;
              responseCompleter.complete(content);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final cycleReport = await responseCompleter.future
            .timeout(Duration(seconds: 5));
        
        expect(cycleReport, contains('Issues Detected'));
        expect(cycleReport, contains('Incomplete tool_use cycles found: 1'));
        expect(cycleReport, contains('test_tool_123'));
        expect(cycleReport, contains('/resume'));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
      }
    });

    test('reports clean state when no incomplete cycles', () async {
      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./nonexistent_target'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(milliseconds: 500));

      try {
        // Check tool cycles without any previous tool calls
        final checkCyclesRequest = {
          'jsonrpc': '2.0',
          'id': 'check_clean',
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
            if (response['id'] == 'check_clean') {
              final content = response['result']['content'][0]['text'] as String;
              responseCompleter.complete(content);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final cycleReport = await responseCompleter.future
            .timeout(Duration(seconds: 5));
        
        expect(cycleReport, contains('✅ Clean'));
        expect(cycleReport, contains('No incomplete tool_use cycles detected'));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
      }
    });

    test('completes tool cycles when target responds', () async {
      // Create a mock server that responds to tool calls
      final mockServerFile = File('./responsive_mock_server.dart');
      await mockServerFile.writeAsString('''
import 'dart:convert';
import 'dart:io';

void main() async {
  await for (final line in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    final message = jsonDecode(line);
    
    if (message['method'] == 'initialize') {
      final response = {
        'jsonrpc': '2.0',
        'id': message['id'],
        'result': {
          'protocolVersion': '2024-11-05',
          'capabilities': {'tools': {}},
          'serverInfo': {'name': 'responsive_mock', 'version': '1.0.0'}
        }
      };
      print(jsonEncode(response));
    } else if (message['method'] == 'tools/call') {
      // Simulate tool execution and response
      final response = {
        'jsonrpc': '2.0',
        'id': message['id'],
        'result': {
          'content': [
            {'type': 'text', 'text': 'Tool executed successfully'}
          ]
        }
      };
      print(jsonEncode(response));
    }
  }
}
''');

      // Compile the mock server
      await Process.run('dart', [
        'compile', 'exe', 
        './responsive_mock_server.dart', 
        '-o', './responsive_mock_binary'
      ]);

      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./responsive_mock_binary'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      // Give time for target to start
      await Future.delayed(Duration(seconds: 2));

      try {
        // Send a tool call that should complete
        final toolCallRequest = {
          'jsonrpc': '2.0',
          'id': 'complete_tool_456',
          'method': 'tools/call',
          'params': {
            'name': 'test_tool',
            'arguments': {}
          }
        };

        proxyInput.writeln(jsonEncode(toolCallRequest));
        
        // Wait for completion
        await Future.delayed(Duration(milliseconds: 500));

        // Check tool cycles - should be clean
        final checkCyclesRequest = {
          'jsonrpc': '2.0',
          'id': 'check_after_complete',
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
            if (response['id'] == 'check_after_complete') {
              final content = response['result']['content'][0]['text'] as String;
              responseCompleter.complete(content);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final cycleReport = await responseCompleter.future
            .timeout(Duration(seconds: 5));
        
        expect(cycleReport, contains('✅ Clean'));
        expect(cycleReport, contains('No incomplete tool_use cycles detected'));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
        
        // Clean up
        await File('./responsive_mock_server.dart').delete();
        await File('./responsive_mock_binary').delete();
      }
    });
  });

  group('Restart Recovery Tests', () {
    test('sends error responses for incomplete tools during restart', () async {
      // Create a server that will crash
      final crashingServerFile = File('./crashing_mock_server.dart');
      await crashingServerFile.writeAsString('''
import 'dart:convert';
import 'dart:io';

void main() async {
  await for (final line in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    final message = jsonDecode(line);
    
    if (message['method'] == 'initialize') {
      final response = {
        'jsonrpc': '2.0',
        'id': message['id'],
        'result': {
          'protocolVersion': '2024-11-05',
          'capabilities': {'tools': {}},
          'serverInfo': {'name': 'crashing_mock', 'version': '1.0.0'}
        }
      };
      print(jsonEncode(response));
    } else if (message['method'] == 'tools/call') {
      // Crash without responding
      exit(1);
    }
  }
}
''');

      // Compile the crashing server
      await Process.run('dart', [
        'compile', 'exe', 
        './crashing_mock_server.dart', 
        '-o', './crashing_mock_binary'
      ]);

      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./crashing_mock_binary'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      // Give time for target to start
      await Future.delayed(Duration(seconds: 2));

      try {
        // Send a tool call that will cause crash
        final toolCallRequest = {
          'jsonrpc': '2.0',
          'id': 'crash_tool_789',
          'method': 'tools/call',
          'params': {
            'name': 'crash_tool',
            'arguments': {}
          }
        };

        proxyInput.writeln(jsonEncode(toolCallRequest));
        
        // Listen for error responses
        final errorCompleter = Completer<Map<String, dynamic>>();
        late StreamSubscription subscription;
        
        subscription = proxyOutput.listen((line) {
          try {
            final response = jsonDecode(line) as Map<String, dynamic>;
            if (response['id'] == 'crash_tool_789' && response['error'] != null) {
              errorCompleter.complete(response);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final errorResponse = await errorCompleter.future
            .timeout(Duration(seconds: 10));
        
        expect(errorResponse['error']['code'], equals(-32603));
        expect(errorResponse['error']['message'], anyOf([
          contains('crashed'),
          contains('restart'),
          contains('interrupted')
        ]));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
        
        // Clean up
        await File('./crashing_mock_server.dart').delete();
        await File('./crashing_mock_binary').delete();
      }
    });
  });
}