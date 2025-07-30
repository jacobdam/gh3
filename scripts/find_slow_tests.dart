#!/usr/bin/env dart
/*
Flutter Test Performance Analyzer

This script analyzes Flutter test execution times to identify the slowest tests.
It runs tests with single-threaded execution and parses timing information.

Usage:
    dart run scripts/find_slow_tests.dart [options]

Options:
    --timeout SECONDS    Timeout for test execution (default: 180)
    --threshold SECONDS  Minimum duration to consider slow (default: 1)
    --top N             Number of top slow tests to show (default: 10)
    --output FILE       Output results to file (default: stdout)
    --test-path PATH    Specific test path to analyze (default: all tests)
    --format FORMAT     Output format: table, json, csv (default: table)

Examples:
    # Find top 10 slowest tests
    dart run scripts/find_slow_tests.dart

    # Find tests taking 2+ seconds, show top 5
    dart run scripts/find_slow_tests.dart --threshold 2 --top 5

    # Analyze only UI system tests
    dart run scripts/find_slow_tests.dart --test-path test/ui_system/

    # Output to JSON file
    dart run scripts/find_slow_tests.dart --format json --output slow_tests.json
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

class TestTiming {
  final double duration;
  final String testName;
  final String filePath;
  final String description;

  TestTiming({
    required this.duration,
    required this.testName,
    required this.filePath,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'duration_seconds': duration,
        'test_name': testName,
        'file_path': filePath,
        'description': description,
      };
}

class SlowTestAnalyzer {
  final int timeout;
  final double threshold;
  final int top;
  final String? outputFile;
  final String testPath;
  final String format;

  SlowTestAnalyzer({
    this.timeout = 180,
    this.threshold = 1.0,
    this.top = 10,
    this.outputFile,
    this.testPath = '',
    this.format = 'table',
  });

  Future<void> analyze() async {
    print('🔍 Running Flutter tests (timeout: ${timeout}s)...');
    
    final timingLines = await _runFlutterTests();
    if (timingLines.isEmpty) {
      print('❌ No timing data captured. Tests may have failed or timed out.');
      exit(1);
    }

    final slowTests = _parseTestTimings(timingLines);
    final result = _formatOutput(slowTests);

    if (outputFile != null) {
      await File(outputFile!).writeAsString(result);
      print('📝 Results written to $outputFile');
    } else {
      print(result);
    }

    // Exit with appropriate code
    if (slowTests.isNotEmpty) {
      print('⚠️  Found ${slowTests.length} tests exceeding ${threshold}s threshold');
      exit(slowTests.length > 5 ? 1 : 0);
    } else {
      print('✅ All tests are fast!');
      exit(0);
    }
  }

  Future<List<String>> _runFlutterTests() async {
    final args = [
      'test',
      '--reporter=expanded',
      '--concurrency=1',
      if (testPath.isNotEmpty) testPath,
    ];

    try {
      final process = await Process.start('flutter', args);
      final output = <String>[];
      
      // Set up timeout
      Timer? timeoutTimer;
      if (timeout > 0) {
        timeoutTimer = Timer(Duration(seconds: timeout), () {
          process.kill();
          print('⚠️  Test execution timed out after ${timeout}s');
        });
      }

      await for (final line in process.stdout.transform(utf8.decoder).transform(const LineSplitter())) {
        // Filter for timing lines, excluding loading messages
        if (RegExp(r'^\d{2}:\d{2} \+\d+:').hasMatch(line) && !line.contains('loading ')) {
          output.add(line.trim());
        }
      }

      timeoutTimer?.cancel();
      await process.exitCode;
      
      print('✅ Captured ${output.length} test timing entries');
      return output;
    } catch (e) {
      print('❌ Error running tests: $e');
      return [];
    }
  }

  List<TestTiming> _parseTestTimings(List<String> timingLines) {
    final slowTests = <TestTiming>[];
    int? prevTime;
    String? prevTestName;

    final timeRegex = RegExp(r'(\d{2}):(\d{2}) \+(\d+): (.+)');

    for (final line in timingLines) {
      final match = timeRegex.firstMatch(line);
      if (match == null) continue;

      final minutes = int.parse(match.group(1)!);
      final seconds = int.parse(match.group(2)!);
      final testName = match.group(4)!;
      final currentTime = minutes * 60 + seconds;

      if (prevTime != null && prevTestName != null) {
        var duration = currentTime - prevTime;
        if (duration < 0) {
          duration += 3600; // Handle minute rollover
        }

        if (duration >= threshold) {
          slowTests.add(TestTiming(
            duration: duration.toDouble(),
            testName: prevTestName,
            filePath: _extractFilePath(prevTestName),
            description: _extractTestDescription(prevTestName),
          ));
        }
      }

      prevTime = currentTime;
      prevTestName = testName;
    }

    // Sort by duration (descending)
    slowTests.sort((a, b) => b.duration.compareTo(a.duration));
    return slowTests;
  }

  String _extractFilePath(String testName) {
    final match = RegExp(r'(/[^:]+\.dart)').firstMatch(testName);
    return match?.group(1) ?? 'unknown';
  }

  String _extractTestDescription(String testName) {
    final parts = testName.split(': ');
    return parts.length > 1 ? parts.sublist(1).join(': ') : testName;
  }

  String _formatOutput(List<TestTiming> slowTests) {
    final topTests = slowTests.take(top).toList();

    switch (format) {
      case 'json':
        return _formatJson(topTests, slowTests.length);
      case 'csv':
        return _formatCsv(topTests);
      default:
        return _formatTable(topTests, slowTests);
    }
  }

  String _formatJson(List<TestTiming> topTests, int totalSlowTests) {
    final results = topTests.asMap().entries.map((entry) {
      final index = entry.key;
      final test = entry.value;
      return {
        'rank': index + 1,
        ...test.toJson(),
      };
    }).toList();

    final output = {
      'timestamp': DateTime.now().toIso8601String(),
      'total_slow_tests': totalSlowTests,
      'threshold_seconds': threshold,
      'top_tests': results,
    };

    return const JsonEncoder.withIndent('  ').convert(output);
  }

  String _formatCsv(List<TestTiming> topTests) {
    final buffer = StringBuffer();
    buffer.writeln('Rank,Duration (s),Test Name,File Path');

    for (int i = 0; i < topTests.length; i++) {
      final test = topTests[i];
      buffer.writeln('${i + 1},${test.duration},"${test.testName}","${test.filePath}"');
    }

    return buffer.toString();
  }

  String _formatTable(List<TestTiming> topTests, List<TestTiming> allSlowTests) {
    if (topTests.isEmpty) {
      return '✅ No tests found taking longer than ${threshold}s threshold.';
    }

    final buffer = StringBuffer();
    buffer.writeln('\n🐌 Top ${topTests.length} Slowest Tests:');
    buffer.writeln('=' * 80);

    for (int i = 0; i < topTests.length; i++) {
      final test = topTests[i];
      final emoji = _getEmojiForDuration(test.duration);

      buffer.writeln('\n${i + 1}. $emoji ${test.duration}s');
      buffer.writeln('   📁 ${test.filePath}');
      buffer.writeln('   🧪 ${test.description}');
    }

    // Add summary statistics
    final totalSlowTime = allSlowTests.fold<double>(0, (sum, test) => sum + test.duration);
    final avgSlowTime = allSlowTests.isNotEmpty ? totalSlowTime / allSlowTests.length : 0;

    buffer.writeln('\n${'=' * 80}');
    buffer.writeln('📊 Summary:');
    buffer.writeln('   • Total slow tests: ${allSlowTests.length}');
    buffer.writeln('   • Total slow time: ${totalSlowTime.toStringAsFixed(1)}s');
    buffer.writeln('   • Average slow time: ${avgSlowTime.toStringAsFixed(1)}s');
    buffer.writeln('   • Potential optimization target: ${(totalSlowTime * 0.7).toStringAsFixed(1)}s savings');

    return buffer.toString();
  }

  String _getEmojiForDuration(double duration) {
    if (duration >= 10) return '🚨';
    if (duration >= 5) return '🔥';
    if (duration >= 2) return '⚠️';
    return '🐌';
  }
}

void main(List<String> arguments) async {
  // Parse command line arguments
  int timeout = 180;
  double threshold = 1.0;
  int top = 10;
  String? outputFile;
  String testPath = '';
  String format = 'table';

  for (int i = 0; i < arguments.length; i++) {
    switch (arguments[i]) {
      case '--timeout':
        if (i + 1 < arguments.length) {
          timeout = int.tryParse(arguments[++i]) ?? 180;
        }
        break;
      case '--threshold':
        if (i + 1 < arguments.length) {
          threshold = double.tryParse(arguments[++i]) ?? 1.0;
        }
        break;
      case '--top':
        if (i + 1 < arguments.length) {
          top = int.tryParse(arguments[++i]) ?? 10;
        }
        break;
      case '--output':
        if (i + 1 < arguments.length) {
          outputFile = arguments[++i];
        }
        break;
      case '--test-path':
        if (i + 1 < arguments.length) {
          testPath = arguments[++i];
        }
        break;
      case '--format':
        if (i + 1 < arguments.length) {
          final f = arguments[++i];
          if (['table', 'json', 'csv'].contains(f)) {
            format = f;
          }
        }
        break;
      case '--help':
        print('''
Flutter Test Performance Analyzer

Usage: dart run scripts/find_slow_tests.dart [options]

Options:
  --timeout SECONDS    Timeout for test execution (default: 180)
  --threshold SECONDS  Minimum duration to consider slow (default: 1)
  --top N             Number of top slow tests to show (default: 10)
  --output FILE       Output results to file (default: stdout)
  --test-path PATH    Specific test path to analyze (default: all tests)
  --format FORMAT     Output format: table, json, csv (default: table)

Examples:
  dart run scripts/find_slow_tests.dart
  dart run scripts/find_slow_tests.dart --threshold 2 --top 5
  dart run scripts/find_slow_tests.dart --test-path test/ui_system/
  dart run scripts/find_slow_tests.dart --format json --output slow_tests.json
''');
        exit(0);
    }
  }

  final analyzer = SlowTestAnalyzer(
    timeout: timeout,
    threshold: threshold,
    top: top,
    outputFile: outputFile,
    testPath: testPath,
    format: format,
  );

  await analyzer.analyze();
}