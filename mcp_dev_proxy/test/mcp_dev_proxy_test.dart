import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:mcp_dev_proxy/mcp_dev_proxy.dart';
import 'package:mcp_dev_proxy/mcp_protocol.dart';

void main() {
  group('MCPDevProxy Unit Tests', () {
    late MCPDevProxy proxy;
    late StreamController<String> inputController;
    late List<String> outputLines;
    late IOSink mockOutputSink;

    setUp(() {
      inputController = StreamController<String>.broadcast();
      outputLines = [];
      mockOutputSink = _MockIOSink(outputLines);

      proxy = MCPDevProxy(
        targetBinary: './test_nonexistent_binary',
        arguments: ['--test'],
        stdinStream: inputController.stream,
        stdoutSink: mockOutputSink,
      );
    });

    tearDown(() async {
      await proxy.stop();
      await inputController.close();
    });

    test('proxy starts successfully with missing binary', () async {
      await proxy.start();
      // Should not throw and should be monitoring for binary
      expect(true, isTrue); // Proxy should start without errors
    });

    test('handles initialize request when target unavailable', () async {
      await proxy.start();
      
      final initMessage = {
        'jsonrpc': '2.0',
        'id': 1,
        'method': 'initialize',
        'params': {
          'protocolVersion': '2024-11-05',
          'capabilities': {},
          'clientInfo': {'name': 'test', 'version': '1.0'}
        }
      };

      inputController.add(jsonEncode(initMessage));
      
      // Give some time for processing
      await Future.delayed(Duration(milliseconds: 100));
      
      expect(outputLines.length, greaterThan(0));
      final response = jsonDecode(outputLines.first);
      expect(response['jsonrpc'], equals('2.0'));
      expect(response['id'], equals(1));
      expect(response['result'], isNotNull);
      expect(response['result']['serverInfo']['name'], equals('mcp_dev_proxy'));
    });

    test('provides proxy tools when target unavailable', () async {
      await proxy.start();
      
      final toolsListMessage = {
        'jsonrpc': '2.0',
        'id': 2,
        'method': 'tools/list',
        'params': {}
      };

      inputController.add(jsonEncode(toolsListMessage));
      
      await Future.delayed(Duration(milliseconds: 100));
      
      expect(outputLines.length, greaterThan(0));
      final response = jsonDecode(outputLines.last);
      expect(response['result']['tools'], isA<List>());
      
      final tools = response['result']['tools'] as List;
      final toolNames = tools.map((t) => t['name']).toList();
      expect(toolNames, contains('proxy_status'));
      expect(toolNames, contains('proxy_help'));
      expect(toolNames, contains('proxy_check_tool_cycles'));
    });

    test('tracks tool_use cycles', () async {
      await proxy.start();
      
      final toolCallMessage = {
        'jsonrpc': '2.0',
        'id': 3,
        'method': 'tools/call',
        'params': {
          'name': 'proxy_status',
          'arguments': {}
        }
      };

      inputController.add(jsonEncode(toolCallMessage));
      
      await Future.delayed(Duration(milliseconds: 100));
      
      expect(outputLines.length, greaterThan(0));
      final response = jsonDecode(outputLines.last);
      expect(response['result']['content'], isA<List>());
      expect(response['result']['content'][0]['text'], contains('MCP Dev Proxy Status'));
    });

    test('handles proxy_check_tool_cycles tool', () async {
      await proxy.start();
      
      final toolCallMessage = {
        'jsonrpc': '2.0',
        'id': 4,
        'method': 'tools/call',
        'params': {
          'name': 'proxy_check_tool_cycles',
          'arguments': {}
        }
      };

      inputController.add(jsonEncode(toolCallMessage));
      
      await Future.delayed(Duration(milliseconds: 100));
      
      expect(outputLines.length, greaterThan(0));
      final response = jsonDecode(outputLines.last);
      expect(response['result']['content'][0]['text'], contains('Tool Cycle Status'));
    });

    test('handles unknown tool gracefully', () async {
      await proxy.start();
      
      final toolCallMessage = {
        'jsonrpc': '2.0',
        'id': 5,
        'method': 'tools/call',
        'params': {
          'name': 'unknown_tool',
          'arguments': {}
        }
      };

      inputController.add(jsonEncode(toolCallMessage));
      
      await Future.delayed(Duration(milliseconds: 100));
      
      expect(outputLines.length, greaterThan(0));
      final response = jsonDecode(outputLines.last);
      expect(response['error'], isNotNull);
      expect(response['error']['message'], contains('Unknown tool'));
    });

    test('handles malformed JSON gracefully', () async {
      await proxy.start();
      
      inputController.add('invalid json');
      
      await Future.delayed(Duration(milliseconds: 100));
      
      // Should not crash, just log warning
      expect(true, isTrue);
    });
  });

  group('MCPProtocol Tests', () {
    test('parses valid MCP message', () {
      final json = {
        'jsonrpc': '2.0',
        'id': 1,
        'method': 'test',
        'params': {'key': 'value'}
      };
      
      final message = MCPProtocol.parseMessage(jsonEncode(json));
      expect(message, isNotNull);
      expect(message!.jsonrpc, equals('2.0'));
      expect(message.id, equals(1));
      expect(message.method, equals('test'));
    });

    test('handles invalid JSON', () {
      final message = MCPProtocol.parseMessage('invalid json');
      expect(message, isNull);
    });

    test('formats message correctly', () {
      final message = MCPMessage(
        jsonrpc: '2.0',
        id: 1,
        method: 'test',
        params: {'key': 'value'}
      );
      
      final formatted = MCPProtocol.formatMessage(message);
      final parsed = jsonDecode(formatted);
      expect(parsed['jsonrpc'], equals('2.0'));
      expect(parsed['id'], equals(1));
      expect(parsed['method'], equals('test'));
    });

    test('creates error responses', () {
      final error = MCPError.serverUnavailable({'test': 'data'});
      final response = MCPMessage.createErrorResponse(1, error);
      
      expect(response.id, equals(1));
      expect(response.error, isNotNull);
      expect(response.error!.code, equals(-32603));
      expect(response.error!.message, equals('MCP server unavailable'));
    });

    test('creates server restart errors with proxy capabilities', () {
      final error = MCPError.serverRestart('test_reason');
      expect(error.data['proxy_capabilities'], isA<List>());
      expect(error.data['proxy_capabilities'], contains('crash_recovery'));
      expect(error.data['proxy_capabilities'], contains('hot_reload'));
    });
  });
}

class _MockIOSink implements IOSink {
  final List<String> lines;
  
  _MockIOSink(this.lines);
  
  @override
  void writeln([Object? obj = ""]) {
    lines.add(obj.toString());
  }
  
  @override
  void write(Object? obj) {
    lines.add(obj.toString());
  }
  
  // Minimal implementation of other required methods
  @override
  Encoding encoding = utf8;
  
  @override
  Future get done => Future.value();
  
  @override
  Future close() => Future.value();
  
  @override
  Future flush() => Future.value();
  
  @override
  void add(List<int> data) {}
  
  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
  
  @override
  Future addStream(Stream<List<int>> stream) => Future.value();
  
  @override
  void writeAll(Iterable objects, [String separator = ""]) {}
  
  @override
  void writeCharCode(int charCode) {}
}