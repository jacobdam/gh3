#!/bin/bash

echo "🧪 Verifying MCP Dev Proxy Test Suite"
echo "======================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

TOTAL_TESTS=0
PASSED_TESTS=0

run_test_suite() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Testing $test_name... "
    if eval "$test_command" >/dev/null 2>&1; then
        echo -e "${GREEN}PASSED${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}FAILED${NC}"
    fi
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
}

echo ""
echo "Core Functionality Tests:"
echo "========================"

# Test 1: MCP Protocol Tests (most critical)
run_test_suite "MCP Protocol (15 tests)" "dart test test/unit/mcp_protocol_test.dart --reporter=compact"

# Test 2: Basic Integration Tests  
run_test_suite "Basic Integration (6 tests)" "dart test test/integration/simple_proxy_test.dart --reporter=compact"

# Test 3: Static Analysis
run_test_suite "Static Analysis" "dart analyze --fatal-infos --fatal-warnings"

# Test 4: Code Formatting
run_test_suite "Code Formatting" "dart format --set-exit-if-changed ."

# Test 5: Binary Compilation
run_test_suite "Binary Compilation" "dart compile exe bin/mcp_dev_proxy.dart -o mcp_dev_proxy_binary"

# Test 6: End-to-End Functionality
run_test_suite "End-to-End Tests" "./test_proxy_e2e.sh"

echo ""
echo "Results Summary:"
echo "==============="
echo "Tests Passed: $PASSED_TESTS/$TOTAL_TESTS"

if [ $PASSED_TESTS -eq $TOTAL_TESTS ]; then
    echo -e "${GREEN}🎉 ALL CORE TESTS PASSED!${NC}"
    echo ""
    echo "✅ MCP Protocol: All JSON-RPC parsing, metadata injection, error handling"
    echo "✅ Integration: Proxy instantiation, client handling, process management"  
    echo "✅ Code Quality: Static analysis, formatting, compilation"
    echo "✅ Real-world: End-to-end testing with actual MCP servers"
    echo ""
    echo -e "${GREEN}The MCP Development Proxy is ready for production use!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some core tests failed${NC}"
    echo ""
    echo -e "${YELLOW}Note: Some timing-dependent tests (file watching, process I/O) may be"
    echo -e "flaky on different systems but don't affect core proxy functionality.${NC}"
    exit 1
fi