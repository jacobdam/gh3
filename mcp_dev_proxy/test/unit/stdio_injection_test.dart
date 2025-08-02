import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import '../../lib/mcp_dev_proxy.dart';

void main() {
  group('Stdio Injection Tests', () {
    late Directory tempDir;
    late File testBinary;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('stdio_test_');
      testBinary = File('${tempDir.path}/test_binary');
      await testBinary.writeAsString('#!/bin/bash\necho "test"');
      await Process.run('chmod', ['+x', testBinary.path]);
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('should work with empty streams (headless mode)', () async {
      final proxy = MCPDevProxy(
        targetBinary: testBinary.path,
        stdinStream: const Stream.empty(), // Empty stream
        stdoutSink: _MockIOSink([]), // Mock sink
      );

      await proxy.start();

      // Should be able to handle input programmatically
      proxy.handleClientInput('{"jsonrpc":"2.0","id":1,"method":"test"}');

      await proxy.stop();

      // Test passes if no exceptions thrown
      expect(true, isTrue);
    });

    test('should work with custom stdin stream', () async {
      final inputController = StreamController<String>();
      final outputBuffer = <String>[];

      final proxy = MCPDevProxy(
        targetBinary: testBinary.path,
        stdinStream: inputController.stream,
        stdoutSink: _MockIOSink(outputBuffer),
      );

      await proxy.start();

      // Send input through custom stream
      inputController.add('{"jsonrpc":"2.0","id":1,"method":"test"}');

      // Give time for processing
      await Future.delayed(Duration(milliseconds: 100));

      inputController.close();
      await proxy.stop();

      // Should have received some output
      expect(outputBuffer.length, greaterThan(0));
    });

    test('should work with custom stdout sink', () async {
      final outputBuffer = <String>[];
      final mockStdout = _MockIOSink(outputBuffer);

      final proxy = MCPDevProxy(
        targetBinary: testBinary.path,
        stdoutSink: mockStdout,
      );

      await proxy.start();

      // Manually send input (no stdin stream)
      proxy.handleClientInput('{"jsonrpc":"2.0","id":1,"method":"test"}');

      await proxy.stop();

      // Should have captured output in our custom sink
      expect(outputBuffer.length, greaterThan(0));
      expect(outputBuffer.first, contains('MCP server'));
    });

    test('should use default streams when none provided', () {
      // This test just verifies the constructor defaults work
      final proxy = MCPDevProxy(
        targetBinary: testBinary.path,
        // No streams provided - should use defaults
      );

      // Should not throw and should have default streams
      expect(proxy.stdinStream, isNotNull);
      expect(proxy.stdoutSink, isNotNull);

      // Default stdout should be the system stdout
      expect(proxy.stdoutSink, equals(stdout));

      // Default stdin in test environment will be empty stream (since stdin is unavailable)
      // In production, it would be the transformed stdin
    });
  });
}

class _MockIOSink implements IOSink {
  final List<String> buffer;

  _MockIOSink(this.buffer);

  @override
  void writeln([Object? obj = ""]) {
    buffer.add(obj.toString());
  }

  @override
  void write(Object? obj) {
    buffer.add(obj.toString());
  }

  // Minimal implementation for other IOSink methods
  @override
  Encoding get encoding => utf8;
  @override
  set encoding(Encoding _encoding) {}
  @override
  void add(List<int> data) {}
  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
  @override
  Future addStream(Stream<List<int>> stream) async {}
  @override
  Future close() async {}
  @override
  Future get done => Future.value();
  @override
  Future flush() async {}
  @override
  void writeAll(Iterable objects, [String sep = ""]) {}
  @override
  void writeCharCode(int charCode) {}
}
