# Test Performance Scripts

This directory contains scripts for analyzing Flutter test performance and identifying bottlenecks.

## find_slow_tests.dart

A comprehensive Dart script that analyzes Flutter test execution times to identify the slowest tests.

### Features

- **Single-threaded test execution** for accurate timing
- **Configurable thresholds** to define what constitutes a "slow" test
- **Multiple output formats**: table, JSON, CSV
- **Timeout handling** for long-running test suites
- **Detailed statistics** and optimization suggestions
- **File path extraction** and test description parsing

### Usage

#### Basic Usage
```bash
# Find top 10 slowest tests (default)
dart run scripts/find_slow_tests.dart
```

#### Advanced Options
```bash
# Find tests taking 2+ seconds, show top 5
dart run scripts/find_slow_tests.dart --threshold 2 --top 5

# Analyze only UI system tests with 60s timeout
dart run scripts/find_slow_tests.dart --test-path test/ui_system/ --timeout 60

# Output results to JSON file
dart run scripts/find_slow_tests.dart --format json --output slow_tests.json

# Get CSV format for spreadsheet analysis
dart run scripts/find_slow_tests.dart --format csv --output slow_tests.csv
```

#### Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--timeout SECONDS` | Timeout for test execution | 180 |
| `--threshold SECONDS` | Minimum duration to consider slow | 1.0 |
| `--top N` | Number of top slow tests to show | 10 |
| `--output FILE` | Output results to file | stdout |
| `--test-path PATH` | Specific test path to analyze | all tests |
| `--format FORMAT` | Output format: table, json, csv | table |
| `--help` | Show help message | - |

### Output Formats

#### Table Format (Default)
```
🐌 Top 3 Slowest Tests:
================================================================================

1. 🚨 10.0s
   📁 test/integration/auth_integration_test.dart
   🧪 OAuth Device Flow with slow down then success

2. 🔥 5.0s
   📁 test/integration/auth_integration_test.dart
   🧪 OAuth Device Flow with authorization pending then success

3. ⚠️ 2.0s
   📁 test/screens/home_screen/home_route_provider_test.dart
   🧪 HomeRouteProvider dependency injection test

================================================================================
📊 Summary:
   • Total slow tests: 3
   • Total slow time: 17.0s
   • Average slow time: 5.7s
   • Potential optimization target: 11.9s savings
```

#### JSON Format
```json
{
  "timestamp": "2025-07-30T15:30:00.000Z",
  "total_slow_tests": 3,
  "threshold_seconds": 1.0,
  "top_tests": [
    {
      "rank": 1,
      "duration_seconds": 10.0,
      "test_name": "test/integration/auth_integration_test.dart: OAuth Device Flow with slow down then success",
      "file_path": "test/integration/auth_integration_test.dart",
      "description": "OAuth Device Flow with slow down then success"
    }
  ]
}
```

#### CSV Format
```csv
Rank,Duration (s),Test Name,File Path
1,10.0,"OAuth Device Flow with slow down then success","test/integration/auth_integration_test.dart"
2,5.0,"OAuth Device Flow with authorization pending then success","test/integration/auth_integration_test.dart"
```

### Emoji Legend

- 🚨 **Critical** (≥10s): Needs immediate attention
- 🔥 **Very Slow** (≥5s): High priority for optimization  
- ⚠️ **Slow** (≥2s): Medium priority for optimization
- 🐌 **Moderate** (≥1s): Low priority for optimization

### Exit Codes

- `0`: Success (no slow tests or ≤5 slow tests)
- `1`: Warning (>5 slow tests found)

### Integration with CI/CD

You can integrate this script into your CI/CD pipeline to track test performance:

```yaml
# GitHub Actions example
- name: Analyze Test Performance
  run: |
    dart run scripts/find_slow_tests.dart --format json --output test_performance.json
    # Upload artifacts or send to monitoring system
```

### Tips for Optimization

1. **Mock external dependencies** instead of using real network calls
2. **Use fake timers** for time-dependent tests
3. **Reduce widget tree complexity** in widget tests
4. **Cache expensive setup operations** across related tests
5. **Consider parallel execution** for independent test suites

## Requirements

- **Dart SDK** (included with Flutter)
- **Flutter** installed and in PATH

## Contributing

When adding new test performance scripts:

1. Follow the existing naming convention
2. Include comprehensive help documentation
3. Support multiple output formats when applicable
4. Add appropriate exit codes for CI/CD integration
5. Update this README with usage examples