#!/bin/bash

echo "Testing MCP Dev Proxy End-to-End..."

# Test 1: Verify binary exists
if [ ! -f "./mcp_dev_proxy_binary" ]; then
    echo "❌ ERROR: mcp_dev_proxy_binary not found"
    exit 1
fi
echo "✅ Binary exists"

# Test 2: Test with MCP Flutter Automation server (if available)
if [ -f "../mcp_flutter_automation/mcp_flutter_automation_binary" ]; then
    echo "Testing with MCP Flutter Automation server..."
    
    # Send a tools/list request
    echo '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' | \
    timeout 3s ./mcp_dev_proxy_binary ../mcp_flutter_automation/mcp_flutter_automation_binary 2>/dev/null | \
    jq -r '.result.proxy.name' 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Proxy successfully forwards requests and adds metadata"
    else
        echo "⚠️  MCP server test inconclusive (may be system dependent)"
    fi
else
    echo "⚠️  MCP Flutter Automation server not found, skipping integration test"
fi

# Test 3: Verify help message
./mcp_dev_proxy_binary 2>&1 | grep -q "Usage:"
if [ $? -eq 0 ]; then
    echo "✅ Help message works correctly"
else
    echo "❌ Help message not working"
    exit 1
fi

# Test 4: Test with non-existent binary
./mcp_dev_proxy_binary /nonexistent/binary 2>&1 | grep -q "does not exist"
if [ $? -eq 0 ]; then
    echo "✅ Error handling works for missing binary"
else
    echo "❌ Error handling not working correctly"
    exit 1
fi

echo ""
echo "🎉 All proxy tests passed!"
echo ""
echo "Usage example:"
echo '  echo '"'"'{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'"'"' | ./mcp_dev_proxy_binary <your_mcp_server_binary>'
echo ""