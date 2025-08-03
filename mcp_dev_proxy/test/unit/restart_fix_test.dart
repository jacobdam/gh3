import "dart:async";
import "dart:convert";
import "dart:io";

import "package:mcp_dev_proxy/mcp_dev_proxy.dart";
import "package:mcp_dev_proxy/mcp_protocol.dart";
import "package:test/test.dart";

void main() {
  group("Restart Fix Tests", () {
    late Directory tempDir;
    late File testBinary;
    late MCPDevProxy proxy;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp("mcp_proxy_test_");
      testBinary = File("${tempDir.path}/test_binary");
      await testBinary.writeAsString('#!/bin/bash\necho "test"');
      await Process.run("chmod", ["+x", testBinary.path]);

      proxy = MCPDevProxy(
        targetBinary: testBinary.path,
        stdinStream: const Stream.empty(),
        stdoutSink: _MockIOSink([]),
      );
    });

    tearDown(() async {
      try {
        await proxy.stop();
      } on Exception {
        // Ignore errors if proxy wasn"t started
      }
      await tempDir.delete(recursive: true);
    });

    test("should send error responses for pending requests during restart",
        () async {
      // SKIP: CI environment socket issues - low priority until sprint revamp completed
    },
        skip:
            "CI environment socket issues - SocketException: Write failed (Broken pipe)",);

    test("should handle restart reason in error response", () {
      // Test that MCPError.serverRestart creates proper error
      final testError = MCPError.serverRestart("binary_updated");

      expect(testError.code, equals(-32603));
      expect(testError.message, equals("MCP server restarting"));
      expect(testError.data["reason"], equals("binary_updated"));
      expect(testError.data["proxy"], equals("mcp_dev_proxy"));
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
