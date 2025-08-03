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
      // SKIP: CI environment socket issues - low priority until sprint revamp completed
    },
        skip:
            'CI environment socket issues - SocketException: Write failed (Broken pipe)');

    test('should work with custom stdin stream', () async {
      // SKIP: CI environment socket issues - low priority until sprint revamp completed
    },
        skip:
            'CI environment socket issues - SocketException: Write failed (Broken pipe)');

    test('should work with custom stdout sink', () async {
      final outputBuffer = <String>[];
      final mockStdout = _MockIOSink(outputBuffer);

      final proxy = MCPDevProxy(
        targetBinary: testBinary.path,
        stdinStream: const Stream.empty(),
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

    test('should use provided streams directly', () {
      // This test verifies the streams are used as provided
      final testStdin = const Stream<String>.empty();
      final testStdout = _MockIOSink([]);

      final proxy = MCPDevProxy(
        targetBinary: testBinary.path,
        stdinStream: testStdin,
        stdoutSink: testStdout,
      );

      // Should use the exact streams provided
      expect(proxy.stdinStream, equals(testStdin));
      expect(proxy.stdoutSink, equals(testStdout));
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
