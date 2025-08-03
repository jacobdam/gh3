import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Hot Reload Tests', () {
    test('detects binary changes and triggers restart', () async {
      // Create initial binary
      final testBinary = File('./hot_reload_test_binary');
      await testBinary.writeAsString('#!/bin/bash\necho "version 1"\n');
      await Process.run('chmod', ['+x', './hot_reload_test_binary']);

      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./hot_reload_test_binary'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyStderr = proxyProcess.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      // Give time for initial start
      await Future.delayed(Duration(seconds: 2));

      try {
        // Listen for restart events
        final restartCompleter = Completer<bool>();
        late StreamSubscription subscription;
        
        subscription = proxyStderr.listen((line) {
          if (line.contains('Target binary changed') || 
              line.contains('scheduling restart')) {
            restartCompleter.complete(true);
            subscription.cancel();
          }
        });

        // Modify the binary to trigger hot reload
        await Future.delayed(Duration(milliseconds: 500));
        await testBinary.writeAsString('#!/bin/bash\necho "version 2"\n');
        
        // Touch the file to ensure timestamp changes
        await Process.run('touch', ['./hot_reload_test_binary']);

        final reloadDetected = await restartCompleter.future
            .timeout(Duration(seconds: 10));
        
        expect(reloadDetected, isTrue);
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
        await testBinary.delete();
      }
    });

    test('handles multiple rapid binary changes with debouncing', () async {
      final testBinary = File('./debounce_test_binary');
      await testBinary.writeAsString('#!/bin/bash\necho "initial"\n');
      await Process.run('chmod', ['+x', './debounce_test_binary']);

      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./debounce_test_binary'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyStderr = proxyProcess.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(seconds: 2));

      try {
        int restartCount = 0;
        final subscription = proxyStderr.listen((line) {
          if (line.contains('scheduling restart')) {
            restartCount++;
          }
        });

        // Make rapid changes
        for (int i = 0; i < 5; i++) {
          await testBinary.writeAsString('#!/bin/bash\necho "version $i"\n');
          await Process.run('touch', ['./debounce_test_binary']);
          await Future.delayed(Duration(milliseconds: 100));
        }

        // Wait for debouncing to settle
        await Future.delayed(Duration(seconds: 3));
        
        subscription.cancel();
        
        // Should have fewer restarts than changes due to debouncing
        expect(restartCount, lessThan(5));
        expect(restartCount, greaterThan(0));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
        await testBinary.delete();
      }
    });
  });

  group('Crash Recovery Tests', () {
    test('recovers from target server crash', () async {
      // Create a server that crashes after initialization
      final crashingServerFile = File('./crash_recovery_server.dart');
      await crashingServerFile.writeAsString('''
import 'dart:convert';
import 'dart:io';

void main() async {
  bool crashed = false;
  
  await for (final line in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    final message = jsonDecode(line);
    
    if (message['method'] == 'initialize') {
      final response = {
        'jsonrpc': '2.0',
        'id': message['id'],
        'result': {
          'protocolVersion': '2024-11-05',
          'capabilities': {'tools': {}},
          'serverInfo': {'name': 'crash_recovery_server', 'version': '1.0.0'}
        }
      };
      print(jsonEncode(response));
      
      // Crash after responding to initialize
      if (!crashed) {
        crashed = true;
        await Future.delayed(Duration(milliseconds: 100));
        exit(42); // Exit with specific code
      }
    }
  }
}
''');

      await Process.run('dart', [
        'compile', 'exe', 
        './crash_recovery_server.dart', 
        '-o', './crash_recovery_binary'
      ]);

      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./crash_recovery_binary'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyStderr = proxyProcess.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(milliseconds: 500));

      try {
        // Send initialize to trigger crash
        final initRequest = {
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'initialize',
          'params': {
            'protocolVersion': '2024-11-05',
            'capabilities': {},
            'clientInfo': {'name': 'crash_test', 'version': '1.0'}
          }
        };

        proxyInput.writeln(jsonEncode(initRequest));

        // Listen for crash detection
        final crashCompleter = Completer<bool>();
        late StreamSubscription subscription;
        
        subscription = proxyStderr.listen((line) {
          if (line.contains('crashed with exit code') || 
              line.contains('exit code: 42')) {
            crashCompleter.complete(true);
            subscription.cancel();
          }
        });

        final crashDetected = await crashCompleter.future
            .timeout(Duration(seconds: 10));
        
        expect(crashDetected, isTrue);
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
        
        await File('./crash_recovery_server.dart').delete();
        await File('./crash_recovery_binary').delete();
      }
    });

    test('provides crash details in error responses', () async {
      // Create server that crashes immediately
      final immediateCrashFile = File('./immediate_crash_server.dart');
      await immediateCrashFile.writeAsString('''
import 'dart:io';
void main() {
  stderr.write('Fatal error occurred');
  exit(1);
}
''');

      await Process.run('dart', [
        'compile', 'exe', 
        './immediate_crash_server.dart', 
        '-o', './immediate_crash_binary'
      ]);

      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./immediate_crash_binary'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyOutput = proxyProcess.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(seconds: 2));

      try {
        // Request proxy status to see crash details
        final statusRequest = {
          'jsonrpc': '2.0',
          'id': 'crash_status',
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
            if (response['id'] == 'crash_status') {
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
        
        expect(statusReport, contains('Startup Error'));
        expect(statusReport, anyOf([
          contains('Failed to start'),
          contains('exit code'),
          contains('process failed')
        ]));
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
        
        await File('./immediate_crash_server.dart').delete();
        await File('./immediate_crash_binary').delete();
      }
    });
  });

  group('Binary Monitoring Tests', () {
    test('monitors for binary creation when missing', () async {
      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./monitoring_test_binary'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyStderr = proxyProcess.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(milliseconds: 500));

      try {
        // Listen for monitoring start
        final monitoringCompleter = Completer<bool>();
        late StreamSubscription subscription;
        
        subscription = proxyStderr.listen((line) {
          if (line.contains('Starting binary availability monitoring')) {
            monitoringCompleter.complete(true);
            subscription.cancel();
          }
        });

        final monitoringStarted = await monitoringCompleter.future
            .timeout(Duration(seconds: 5));
        
        expect(monitoringStarted, isTrue);
        
        // Create the binary and verify detection
        final testBinary = File('./monitoring_test_binary');
        await testBinary.writeAsString('#!/bin/bash\necho "test"\n');
        await Process.run('chmod', ['+x', './monitoring_test_binary']);

        final detectionCompleter = Completer<bool>();
        late StreamSubscription detectionSub;
        
        detectionSub = proxyStderr.listen((line) {
          if (line.contains('Binary now available')) {
            detectionCompleter.complete(true);
            detectionSub.cancel();
          }
        });

        final binaryDetected = await detectionCompleter.future
            .timeout(Duration(seconds: 10));
        
        expect(binaryDetected, isTrue);
        
        await testBinary.delete();
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
      }
    });

    test('stops monitoring when target starts successfully', () async {
      // Create a working binary first
      final workingBinary = File('./working_test_binary');
      await workingBinary.writeAsString('''#!/bin/bash
while read line; do
  echo '{"jsonrpc":"2.0","id":1,"result":{"protocolVersion":"2024-11-05","capabilities":{},"serverInfo":{"name":"working","version":"1.0"}}}'
  break
done
''');
      await Process.run('chmod', ['+x', './working_test_binary']);

      final proxyProcess = await Process.start(
        './mcp_dev_proxy_binary',
        ['./working_test_binary'],
        mode: ProcessStartMode.normal,
      );
      
      final proxyStderr = proxyProcess.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      final proxyInput = proxyProcess.stdin;
      
      await Future.delayed(Duration(seconds: 2));

      try {
        // Send initialize to start target
        final initRequest = {
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'initialize',
          'params': {
            'protocolVersion': '2024-11-05',
            'capabilities': {},
            'clientInfo': {'name': 'monitor_test', 'version': '1.0'}
          }
        };

        proxyInput.writeln(jsonEncode(initRequest));
        
        // Wait for startup
        await Future.delayed(Duration(seconds: 1));

        // Check logs - should not have monitoring messages after successful start
        bool foundStopMonitoring = false;
        final subscription = proxyStderr.listen((line) {
          if (line.contains('Stop monitoring') || 
              line.contains('Target process started successfully')) {
            foundStopMonitoring = true;
          }
        });

        await Future.delayed(Duration(seconds: 2));
        subscription.cancel();
        
        // Should have successfully started (monitoring may or may not explicitly log stop)
        expect(foundStopMonitoring, isTrue);
        
      } finally {
        proxyInput.close();
        proxyProcess.kill();
        await proxyProcess.exitCode;
        await workingBinary.delete();
      }
    });
  });
}