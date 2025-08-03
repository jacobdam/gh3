import "dart:async";
import "dart:convert";
import "dart:io";

import "package:mcp_dev_proxy/mcp_dev_proxy.dart";
import "package:test/test.dart";

void main() {
  group("Stdio Injection Tests", () {
    late Directory tempDir;
    late File testBinary;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp("stdio_test_");
      testBinary = File("${tempDir.path}/test_binary");
      await testBinary.writeAsString('#!/bin/bash\necho "test"');
      await Process.run("chmod", ["+x", testBinary.path]);
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test("should work with empty streams (headless mode)", () async {
      // SKIP: CI environment socket issues - low priority until sprint revamp completed
    },
        skip:
            "CI environment socket issues - SocketException: Write failed (Broken pipe)",);

    test("should work with custom stdin stream", () async {
      // SKIP: CI environment socket issues - low priority until sprint revamp completed
    },
        skip:
            "CI environment socket issues - SocketException: Write failed (Broken pipe)",);

    test("should work with custom stdout sink", () async {
      // SKIP: CI environment socket issues - low priority until sprint revamp completed
    },
        skip:
            "CI environment socket issues - SocketException: Write failed (Broken pipe)",);

    test("should use provided streams directly", () {
      // This test verifies the streams are used as provided
      const testStdin = Stream<String>.empty();
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

  _MockIOSink(this.buffer);
  final List<String> buffer;

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
  set encoding(Encoding encoding) {}
  @override
  void add(List<int> data) {}
  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
  @override
  Future<void> addStream(Stream<List<int>> stream) async {}
  @override
  Future<void> close() async {}
  @override
  Future<void> get done => Future<void>.value();
  @override
  Future<void> flush() async {}
  @override
  void writeAll(Iterable<Object?> objects, [String sep = ""]) {}
  @override
  void writeCharCode(int charCode) {}
}
