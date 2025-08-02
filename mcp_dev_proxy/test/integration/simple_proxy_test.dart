import 'dart:io';
import 'package:test/test.dart';
import 'package:mcp_dev_proxy/mcp_dev_proxy.dart';
import 'package:mcp_dev_proxy/mcp_protocol.dart';

void main() {
  group('MCPDevProxy Basic Integration', () {
    late Directory tempDir;
    late File mockServerScript;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('proxy_integration_test');

      // Create a simple mock MCP server script
      mockServerScript = File('${tempDir.path}/mock_server.dart');
      await mockServerScript.writeAsString('''
#!/usr/bin/env dart
import 'dart:io';
import 'dart:convert';

void main() async {
  stdin.transform(utf8.decoder).transform(LineSplitter()).listen((line) {
    final message = jsonDecode(line);
    
    if (message['method'] == 'test_method') {
      final response = {
        'jsonrpc': '2.0',
        'id': message['id'],
        'result': {'success': true}
      };
      stdout.writeln(jsonEncode(response));
    }
  });
}
''');

      // Make script executable
      await Process.run('chmod', ['+x', mockServerScript.path]);
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('should create proxy instance', () {
      final proxy = MCPDevProxy(
        targetBinary: 'dart',
        arguments: [mockServerScript.path],
      );

      expect(proxy.targetBinary, equals('dart'));
      expect(proxy.arguments, equals([mockServerScript.path]));
    });

    test('should parse and handle client input', () {
      final proxy = MCPDevProxy(
        targetBinary: 'dart',
        arguments: [mockServerScript.path],
      );

      // Test parsing a valid JSON-RPC message
      final request = MCPMessage(
        jsonrpc: '2.0',
        id: 1,
        method: 'test_method',
      );

      final line = MCPProtocol.formatMessage(request);
      expect(line, contains('test_method'));

      // Should not throw when handling input (even if process isn't started)
      expect(() => proxy.handleClientInput(line), returnsNormally);
    });

    test('should handle binary file path', () async {
      final proxy = MCPDevProxy(
        targetBinary: mockServerScript.path,
        arguments: [],
      );

      expect(proxy.targetBinary, equals(mockServerScript.path));

      // Verify file exists
      expect(await File(proxy.targetBinary).exists(), isTrue);
    });

    test('should handle process manager access after start', () async {
      final proxy = MCPDevProxy(
        targetBinary: 'dart',
        arguments: [mockServerScript.path],
      );

      // Process manager is not initialized until start() is called
      expect(() => proxy.processManager, throwsA(anything));

      // After start, should be accessible
      await proxy.start();
      expect(() => proxy.processManager, returnsNormally);
      expect(proxy.processManager, isNotNull);

      await proxy.stop();
    });
  });

  group('MCPProtocol Parsing', () {
    test('should handle real MCP messages', () {
      const jsonString =
          '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}';
      final message = MCPProtocol.parseMessage(jsonString);

      expect(message, isNotNull);
      expect(message!.method, equals('tools/list'));
      expect(message.id, equals(1));
      expect(message.isRequest, isTrue);
    });

    test('should add proxy metadata correctly', () {
      final response = MCPMessage(
        jsonrpc: '2.0',
        id: 1,
        result: {'tools': []},
      );

      final enhanced = response.withProxyMetadata();

      expect(enhanced.result['proxy'], isNotNull);
      expect(enhanced.result['proxy']['name'], equals('mcp_dev_proxy'));
      expect(enhanced.result['tools'], equals([]));
    });
  });
}
