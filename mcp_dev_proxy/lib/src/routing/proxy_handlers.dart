/// Request handlers for proxy tool calls
library;

import "dart:io";
import "request_router.dart";
import "../../mcp_dev_proxy.dart";

/// Handler for proxy_status tool calls
class ProxyStatusHandler extends RequestHandler {
  final MCPDevProxy _proxy;

  ProxyStatusHandler(this._proxy);

  @override
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    return {
      "content": [
        {
          "type": "text",
          "text": _buildProxyStatusReport(),
        }
      ]
    };
  }

  String _buildProxyStatusReport() {
    final targetBinary = _proxy.targetBinary;
    final startupError = _proxy.startupError;
    final binaryMonitorTimer = _proxy.binaryMonitorTimer;

    final binaryExists = File(targetBinary).existsSync();
    final status = binaryExists
        ? "Binary exists but process failed to start"
        : "Binary not found";

    return """
# MCP Dev Proxy Status

**Target Binary:** `$targetBinary`
**Status:** $status
**Process Running:** ${_proxy.isProcessRunning}
**Monitoring Active:** ${binaryMonitorTimer != null}

## Current State
${startupError != null ? "⚠️ Startup Error: $startupError" : "✅ Proxy running normally"}

## Next Steps
${binaryExists ? "Binary exists but failed to start. Check if it\"s executable and implements MCP protocol." : "Compile your MCP server binary: `dart compile exe bin/your_server.dart -o ${targetBinary.split("/").last}`"}

## Proxy Capabilities
- 🔄 Crash Recovery: Auto-restart on crashes
- 🔥 Hot Reload: Detect binary changes and restart  
- 📦 Error Buffering: Handle pending requests during restarts
- 🔍 Debug Info: Enhanced error messages with context
""";
  }
}

/// Handler for proxy_help tool calls
class ProxyHelpHandler extends RequestHandler {
  ProxyHelpHandler(MCPDevProxy proxy);

  @override
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    return {
      "content": [
        {
          "type": "text",
          "text": _buildProxyHelpText(),
        }
      ]
    };
  }

  String _buildProxyHelpText() {
    return """
# MCP Development Proxy Help

The MCP Development Proxy helps with MCP server development by providing:

## Core Features
- **Crash Recovery**: Automatically restarts your server when it crashes
- **Hot Reload**: Detects binary changes and restarts the server
- **Error Context**: Provides detailed error information for debugging
- **Tool Tracking**: Monitors incomplete tool_use cycles

## Available Tools
- `proxy_status`: Get current proxy and target server status
- `proxy_help`: Show this help information
- `proxy_check_tool_cycles`: Check for incomplete tool_use cycles

## Common Issues & Solutions

### Binary Not Found
1. Compile your server: `dart compile exe bin/server.dart -o server_binary`
2. Check the binary path is correct
3. Ensure the binary has execute permissions

### Server Crashes on Startup
1. Test your binary directly: `./your_binary`
2. Check for missing dependencies
3. Verify MCP protocol implementation

### Hot Reload Not Working
1. Ensure your build process updates the binary file
2. Check file watcher permissions
3. The proxy monitors the exact binary path provided

## Development Workflow
1. Start the proxy pointing to your binary
2. Make code changes
3. Rebuild your binary
4. Proxy detects changes and restarts automatically
5. Test your changes through the MCP client

For more details, check the proxy logs and use `proxy_status` for current state.
""";
  }
}

/// Handler for proxy_check_tool_cycles tool calls
class ProxyToolCycleHandler extends RequestHandler {
  final MCPDevProxy _proxy;

  ProxyToolCycleHandler(this._proxy);

  @override
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    return {
      "content": [
        {
          "type": "text",
          "text": _buildToolCycleReport(),
        }
      ]
    };
  }

  String _buildToolCycleReport() {
    final pendingToolUses = _proxy.pendingToolUses;

    if (pendingToolUses.isEmpty) {
      return """
# Tool Cycle Check

✅ **No incomplete tool cycles detected**

All tool_use requests have been properly completed with tool_result responses.
""";
    }

    final pendingList = pendingToolUses.map((id) => "- `$id`").join("\n");

    return """
# Tool Cycle Check

⚠️ **${pendingToolUses.length} incomplete tool cycle(s) detected**

## Pending Tool Uses
$pendingList

## What This Means
These tool_use requests were sent but never received corresponding tool_result responses.
This can cause:
- API errors when clients expect responses
- Memory usage accumulation
- Confused client state

## Recommended Actions
1. Check your tool implementation for proper error handling
2. Ensure all tool calls return responses (success or error)
3. Restart the proxy to clear pending state if needed
4. Review server logs for exceptions during tool execution

## Prevention
- Always send tool_result for every tool_use
- Implement proper exception handling in tool code
- Use timeouts for long-running tool operations
""";
  }
}

/// Handler for initialize requests when target is unavailable
class InitializeHandler extends RequestHandler {
  final MCPDevProxy _proxy;

  InitializeHandler(this._proxy);

  @override
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    final targetBinary = _proxy.targetBinary;
    final binaryExists = File(targetBinary).existsSync();
    final proxyState = _proxy.proxyState;

    String status;
    String actionNeeded;

    if (!binaryExists) {
      status = "Binary not found";
      actionNeeded =
          "Compile your MCP server binary: dart compile exe bin/your_server.dart -o ${targetBinary.split("/").last}";
    } else if (proxyState.startupError != null) {
      status = "Binary exists but failed to start: ${proxyState.startupError}";
      actionNeeded =
          "Check if binary is executable and implements MCP protocol";
    } else if (_proxy.isProcessStarting) {
      status = "Target MCP server is starting up";
      actionNeeded = "Please wait for the server to start";
    } else {
      status = "Target MCP server is not running";
      actionNeeded = "Check if your MCP server process crashed";
    }

    final instructionsText = """
Target MCP server is not available.

Expected Binary: $targetBinary
Status: $status
Action Needed: $actionNeeded

Proxy Capabilities:
- Crash Recovery: Auto-restart on crashes  
- Hot Reload: Detect binary changes and restart
- Error Buffering: Handle pending requests during restarts
- Debug Info: Enhanced error messages with context

Use the "proxy_status" tool for detailed information and "proxy_help" for guidance.
""";

    return {
      "protocolVersion": "2024-11-05",
      "capabilities": {
        "tools": <String, dynamic>{},
        "resources": <String, dynamic>{},
        "prompts": <String, dynamic>{},
      },
      "serverInfo": {
        "name": "mcp_dev_proxy",
        "version": "1.0.0",
      },
      "instructions": instructionsText,
    };
  }
}

/// Handler for tools/list requests when target is unavailable
class ToolsListHandler extends RequestHandler {
  ToolsListHandler(MCPDevProxy proxy);

  @override
  Future<Map<String, dynamic>> handle(
    Map<String, dynamic> params,
    RequestContext context,
  ) async {
    return {
      "tools": [
        {
          "name": "proxy_status",
          "description":
              "Get current proxy status and target binary information",
          "inputSchema": {
            "type": "object",
            "properties": <String, dynamic>{},
          },
        },
        {
          "name": "proxy_help",
          "description": "Get help on how to work with the MCP dev proxy",
          "inputSchema": {
            "type": "object",
            "properties": <String, dynamic>{},
          },
        },
        {
          "name": "proxy_check_tool_cycles",
          "description":
              "Check for incomplete tool_use cycles that may cause API errors",
          "inputSchema": {
            "type": "object",
            "properties": <String, dynamic>{},
          },
        },
      ],
    };
  }
}
