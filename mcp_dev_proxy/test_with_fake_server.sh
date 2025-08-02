#!/bin/bash

echo "🧪 Testing MCP Dev Proxy with Fake Server..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROXY="./mcp_dev_proxy_binary"
FAKE_SERVER="./test_server/fake_mcp_server"

# Test counter
TESTS_RUN=0
TESTS_PASSED=0

run_test() {
    local test_name="$1"
    local request="$2"
    local expected_check="$3"
    local server_args="$4"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    echo -n "Testing: $test_name... "
    
    local response
    response=$(echo "$request" | timeout 3s $PROXY $FAKE_SERVER $server_args 2>/dev/null)
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}FAILED${NC} (proxy exited with code $exit_code)"
        return 1
    fi
    
    if echo "$response" | jq -e "$expected_check" >/dev/null 2>&1; then
        echo -e "${GREEN}PASSED${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}FAILED${NC}"
        echo "Response: $response"
        echo "Expected check: $expected_check"
        return 1
    fi
}

# Check prerequisites
if [ ! -f "$PROXY" ]; then
    echo -e "${RED}Error: Proxy binary not found at $PROXY${NC}"
    exit 1
fi

if [ ! -f "$FAKE_SERVER" ]; then
    echo -e "${RED}Error: Fake server not found at $FAKE_SERVER${NC}"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}Warning: jq not found, skipping JSON validation tests${NC}"
    exit 0
fi

echo "✅ Prerequisites check passed"
echo ""

# Test 1: Basic tools/list request
run_test "tools/list request" \
    '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' \
    '.result.tools[0].name == "fake_tool" and .result.proxy.name == "mcp_dev_proxy"'

# Test 2: Ping request
run_test "ping request" \
    '{"jsonrpc":"2.0","id":2,"method":"ping","params":{}}' \
    '.result.status == "pong" and .result.proxy.name == "mcp_dev_proxy"'

# Test 3: Unknown method
run_test "unknown method handling" \
    '{"jsonrpc":"2.0","id":3,"method":"unknown_method","params":{}}' \
    '.result.echo == "unknown_method" and .result.fake_server == true and .result.proxy.name == "mcp_dev_proxy"'

# Test 4: Server crash
run_test "server crash handling" \
    '{"jsonrpc":"2.0","id":4,"method":"crash_test","params":{}}' \
    '.error.code == -32603 and (.error.message | contains("crashed")) and .error.data.exit_code == 42' \
    "--crash"

# Test 5: Server error forwarding
run_test "server error forwarding" \
    '{"jsonrpc":"2.0","id":5,"method":"error_test","params":{}}' \
    '.error.code == -32601 and .error.message == "Method not found"' \
    "--error"

# Test 6: Resources list
run_test "resources/list request" \
    '{"jsonrpc":"2.0","id":6,"method":"resources/list","params":{}}' \
    '.result.resources[0].uri == "fake://test-resource" and .result.proxy.name == "mcp_dev_proxy"'

echo ""
echo "📊 Test Results:"
echo "Tests run: $TESTS_RUN"
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $((TESTS_RUN - TESTS_PASSED))"

if [ $TESTS_PASSED -eq $TESTS_RUN ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi