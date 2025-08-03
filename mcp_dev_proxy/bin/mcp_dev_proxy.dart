#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:mcp_dev_proxy/mcp_dev_proxy.dart';

void main(List<String> arguments) async {
  // Setup logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    stderr.writeln('[${record.level.name}] ${record.time}: ${record.message}');
  });

  final logger = Logger('main');

  if (arguments.isEmpty) {
    stderr.writeln('Usage: mcp_dev_proxy <target_binary> [args...]');
    stderr.writeln('');
    stderr.writeln('Example:');
    stderr.writeln(
        '  mcp_dev_proxy ./mcp_flutter_automation/mcp_flutter_automation_binary');
    exit(1);
  }

  final targetBinary = arguments.first;
  final targetArgs = arguments.length > 1 ? arguments.sublist(1) : <String>[];

  // Note: We don't check binary existence here anymore - let the proxy handle it gracefully

  // Create stdin stream with proper error handling
  Stream<String> createStdinStream() {
    try {
      return stdin.transform(utf8.decoder).transform(const LineSplitter());
    } catch (e) {
      stderr.writeln('Warning: Failed to create stdin stream: $e');
      return const Stream.empty();
    }
  }

  final proxy = MCPDevProxy(
    targetBinary: targetBinary,
    arguments: targetArgs,
    stdinStream: createStdinStream(),
    stdoutSink: stdout,
  );

  // Handle graceful shutdown
  ProcessSignal.sigint.watch().listen((_) async {
    logger.info('Received SIGINT, shutting down...');
    await proxy.stop();
    exit(0);
  });

  ProcessSignal.sigterm.watch().listen((_) async {
    logger.info('Received SIGTERM, shutting down...');
    await proxy.stop();
    exit(0);
  });

  try {
    await proxy.start();

    // Keep the proxy running
    await ProcessSignal.sigint.watch().first;
  } catch (e, stack) {
    logger.severe('MCP Dev Proxy failed: $e');
    logger.severe(stack.toString());
    exit(1);
  }
}
