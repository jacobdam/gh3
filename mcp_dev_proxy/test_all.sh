#!/bin/bash

echo "🧪 Running MCP Dev Proxy Tests"
echo "=============================="

# Ensure binary is compiled
echo "📦 Compiling proxy binary..."
dart compile exe bin/mcp_dev_proxy.dart -o mcp_dev_proxy_binary
if [ $? -ne 0 ]; then
    echo "❌ Failed to compile proxy binary"
    exit 1
fi

echo "✅ Proxy binary compiled successfully"
echo ""

# Run unit tests
echo "🔬 Running unit tests..."
dart test test/mcp_dev_proxy_test.dart
UNIT_RESULT=$?

echo ""

# Run integration tests
echo "🔗 Running integration tests..."
dart test test/integration_test.dart
INTEGRATION_RESULT=$?

echo ""

# Run tool cycle tests
echo "🔄 Running tool cycle tests..."
dart test test/tool_cycle_test.dart
TOOL_CYCLE_RESULT=$?

echo ""

# Run restart/recovery tests
echo "♻️ Running restart and recovery tests..."
dart test test/restart_recovery_test.dart
RESTART_RESULT=$?

echo ""

# Run error handling tests
echo "⚠️ Running error handling tests..."
dart test test/error_handling_test.dart
ERROR_HANDLING_RESULT=$?

echo ""
echo "📊 Test Results Summary"
echo "======================"

if [ $UNIT_RESULT -eq 0 ]; then
    echo "✅ Unit tests: PASSED"
else
    echo "❌ Unit tests: FAILED"
fi

if [ $INTEGRATION_RESULT -eq 0 ]; then
    echo "✅ Integration tests: PASSED"
else
    echo "❌ Integration tests: FAILED"
fi

if [ $TOOL_CYCLE_RESULT -eq 0 ]; then
    echo "✅ Tool cycle tests: PASSED"
else
    echo "❌ Tool cycle tests: FAILED"
fi

if [ $RESTART_RESULT -eq 0 ]; then
    echo "✅ Restart/recovery tests: PASSED"
else
    echo "❌ Restart/recovery tests: FAILED"
fi

if [ $ERROR_HANDLING_RESULT -eq 0 ]; then
    echo "✅ Error handling tests: PASSED"
else
    echo "❌ Error handling tests: FAILED"
fi

# Calculate overall result
TOTAL_FAILURES=$((UNIT_RESULT + INTEGRATION_RESULT + TOOL_CYCLE_RESULT + RESTART_RESULT + ERROR_HANDLING_RESULT))

echo ""
if [ $TOTAL_FAILURES -eq 0 ]; then
    echo "🎉 All tests PASSED!"
    exit 0
else
    echo "💥 Some tests FAILED (exit codes: $UNIT_RESULT, $INTEGRATION_RESULT, $TOOL_CYCLE_RESULT, $RESTART_RESULT, $ERROR_HANDLING_RESULT)"
    exit 1
fi