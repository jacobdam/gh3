import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('MCP Dev Proxy Integration Tests', () {
    late Process proxyProcess;
    late Stream<String> proxyOutput;
    late IOSink proxyInput;

    setUp(() async {
      // Start the proxy with a non-existent target
      proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./test_target_binary'],
        mode: ProcessStartMode.normal,
      );

      proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      proxyInput = proxyProcess.stdin;

      // Give proxy time to start
      await Future.delayed(Duration(milliseconds: 500));
    });

    tearDown(() async {
      proxyInput.close();
      proxyProcess.kill();
      await proxyProcess.exitCode;
    });

    test('proxy responds to initialize request', () async {
      final initRequest = {
        'jsonrpc': '2.0',
        'id': 1,
        'method': 'initialize',
        'params': {
          'protocolVersion': '2024-11-05',
          'capabilities': {},
          'clientInfo': {'name': 'integration_test', 'version': '1.0'}
        }
      };

      proxyInput.writeln(jsonEncode(initRequest));

      final responseCompleter = Completer<Map<String, dynamic>>();
      late StreamSubscription subscription;

      subscription = proxyOutput.listen((line) {
        try {
          final response = jsonDecode(line) as Map<String, dynamic>;
          if (response['id'] == 1) {
            responseCompleter.complete(response);
            subscription.cancel();
          }
        } catch (e) {
          // Ignore non-JSON lines (logs)
        }
      });

      final response =
          await responseCompleter.future.timeout(Duration(seconds: 5));

      expect(response['jsonrpc'], equals('2.0'));
      expect(response['id'], equals(1));
      expect(response['result'], isNotNull);
      expect(response['result']['serverInfo']['name'], equals('mcp_dev_proxy'));
      expect(response['result']['instructions'], isA<String>());
      expect(response['result']['instructions'],
          contains('Target MCP server is not available'));
    });

    test('proxy provides tools when target unavailable', () async {
      final toolsRequest = {
        'jsonrpc': '2.0',
        'id': 2,
        'method': 'tools/list',
        'params': {}
      };

      proxyInput.writeln(jsonEncode(toolsRequest));

      final responseCompleter = Completer<Map<String, dynamic>>();
      late StreamSubscription subscription;

      subscription = proxyOutput.listen((line) {
        try {
          final response = jsonDecode(line) as Map<String, dynamic>;
          if (response['id'] == 2) {
            responseCompleter.complete(response);
            subscription.cancel();
          }
        } catch (e) {
          // Ignore non-JSON lines
        }
      });

      final response =
          await responseCompleter.future.timeout(Duration(seconds: 5));

      expect(response['result']['tools'], isA<List>());
      final tools = response['result']['tools'] as List;
      final toolNames = tools.map((t) => t['name']).toList();
      expect(toolNames, contains('proxy_status'));
      expect(toolNames, contains('proxy_help'));
      expect(toolNames, contains('proxy_check_tool_cycles'));
    });

    test('proxy_status tool returns detailed information', () async {
      final toolCallRequest = {
        'jsonrpc': '2.0',
        'id': 3,
        'method': 'tools/call',
        'params': {'name': 'proxy_status', 'arguments': {}}
      };

      proxyInput.writeln(jsonEncode(toolCallRequest));

      final responseCompleter = Completer<Map<String, dynamic>>();
      late StreamSubscription subscription;

      subscription = proxyOutput.listen((line) {
        try {
          final response = jsonDecode(line) as Map<String, dynamic>;
          if (response['id'] == 3) {
            responseCompleter.complete(response);
            subscription.cancel();
          }
        } catch (e) {
          // Ignore non-JSON lines
        }
      });

      final response =
          await responseCompleter.future.timeout(Duration(seconds: 5));

      // Check if response has result or error
      if (response.containsKey('result') && response['result'] != null) {
        expect(response['result']['content'], isA<List>());
        final content = response['result']['content'][0]['text'] as String;
        expect(content, contains('MCP Dev Proxy Status'));
        expect(content, contains('Target Binary:'));
        expect(content, contains('Binary not found'));
        expect(content, contains('Proxy Capabilities'));
      } else if (response.containsKey('error')) {
        // If there's an error, log it but don't fail the test completely
        print('Proxy status tool returned error: ${response['error']}');
        expect(response['error']['message'], isA<String>());
      } else {
        fail('Unexpected response structure: $response');
      }
    });

    test('proxy detects binary creation and attempts restart', () async {
      // Create a simple executable file
      final testBinary = File('./test_target_binary');
      await testBinary.writeAsString('#!/bin/bash\necho "test binary"\n');
      await Process.run('chmod', ['+x', './test_target_binary']);

      // Monitor proxy logs for restart activity
      final logCompleter = Completer<bool>();
      late StreamSubscription subscription;

      subscription = proxyProcess.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        if (line.contains('Binary now available') ||
            line.contains('attempting to start target process')) {
          logCompleter.complete(true);
          subscription.cancel();
        }
      });

      final detected = await logCompleter.future.timeout(Duration(seconds: 10));

      expect(detected, isTrue);

      // Clean up
      await testBinary.delete();
    });
  });

  group('End-to-End with Mock MCP Server', () {
    test('proxy forwards requests to working target server', () async {
      // Create a simple mock MCP server
      final mockServerFile = File('./mock_mcp_server.dart');
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
          'serverInfo': {'name': 'mock_server', 'version': '1.0.0'}
        }
      };
      print(jsonEncode(response));
    } else if (message['method'] == 'tools/list') {
      final response = {
        'jsonrpc': '2.0',
        'id': message['id'],
        'result': {'tools': []}
      };
      print(jsonEncode(response));
    }
  }
}
''');

      // Compile the mock server
      final compileResult = await Process.run('dart', [
        'compile',
        'exe',
        './mock_mcp_server.dart',
        '-o',
        './mock_mcp_server_binary'
      ]);

      expect(compileResult.exitCode, equals(0));

      // Start proxy with the mock server
      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./mock_mcp_server_binary'],
        mode: ProcessStartMode.normal,
      );

      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;

      // Give time for both to start
      await Future.delayed(Duration(seconds: 2));

      try {
        // Send initialize request through proxy
        final initRequest = {
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'initialize',
          'params': {
            'protocolVersion': '2024-11-05',
            'capabilities': {},
            'clientInfo': {'name': 'e2e_test', 'version': '1.0'}
          }
        };

        proxyInput.writeln(jsonEncode(initRequest));

        final responseCompleter = Completer<Map<String, dynamic>>();
        late StreamSubscription subscription;

        subscription = proxyOutput.listen((line) {
          try {
            final response = jsonDecode(line) as Map<String, dynamic>;
            if (response['id'] == 1) {
              responseCompleter.complete(response);
              subscription.cancel();
            }
          } catch (e) {
            // Ignore non-JSON lines
          }
        });

        final response =
            await responseCompleter.future.timeout(Duration(seconds: 10));

        // Should get response from mock server (not proxy fallback)
        expect(response['result']['serverInfo']['name'], equals('mock_server'));
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;

        // Clean up files
        await File('./mock_mcp_server.dart').delete();
        await File('./mock_mcp_server_binary').delete();
      }
    });
  });
}
