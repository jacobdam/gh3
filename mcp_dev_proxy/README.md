# MCP Development Proxy

A development proxy for MCP servers with crash reporting and hot-reload capabilities. Specifically designed to improve the development workflow for MCP server development by providing automatic restart and detailed error reporting.

## Features

- **Transparent Proxy**: Drop-in replacement for any MCP server - no client-side changes needed
- **Crash Reporting**: Returns detailed error responses with stderr logs and exit codes when the target server crashes
- **Hot Reload**: Automatically restarts the target server when the binary file changes
- **Development Metadata**: All responses include proxy information to indicate this is a development environment
- **Stdio Protocol**: JSON-RPC communication over stdin/stdout only

## Quick Start

### Installation

1. Clone and build the proxy:
```bash
cd mcp_dev_proxy
dart pub get
dart compile exe bin/mcp_dev_proxy.dart -o mcp_dev_proxy_binary
```

### Basic Usage

Replace your MCP server command in `.mcp.json`:

```json
{
  "mcpServers": {
    "your-server": {
      "command": "./mcp_dev_proxy_binary",
      "args": ["./path/to/your/mcp_server_binary"]
    }
  }
}
```

### Example Configuration

For the MCP Flutter Automation server:

```json
{
  "mcpServers": {
    "flutter-automation": {
      "command": "./mcp_dev_proxy/mcp_dev_proxy_binary",
      "args": ["./mcp_flutter_automation/mcp_flutter_automation_binary"]
    }
  }
}
```

## How It Works

### Normal Operation
- Forwards JSON-RPC messages bidirectionally between client and target server
- Adds proxy metadata to all successful responses:
```json
{
  "result": {
    "...": "original response data",
    "proxy": {
      "name": "mcp_dev_proxy",
      "version": "1.0.0",
      "target": "mcp_flutter_automation"
    }
  }
}
```

### Crash Handling
When the target server crashes, the proxy immediately returns an error response:
```json
{
  "jsonrpc": "2.0",
  "id": 123,
  "error": {
    "code": -32603,
    "message": "MCP server crashed (exit code: 1)",
    "data": {
      "stderr": "full stderr output from crashed process",
      "exit_code": 1,
      "proxy": "mcp_dev_proxy"
    }
  }
}
```

### Hot Reload
- Watches the target binary file for changes
- When the file is modified (e.g., after recompilation):
  1. Kills the current process
  2. Starts a new process with the updated binary
  3. Next successful response includes restart notification:
```json
{
  "result": {
    "...": "response data",
    "proxy": {
      "name": "mcp_dev_proxy",
      "version": "1.0.0",
      "target": "mcp_flutter_automation",
      "event": "restarted",
      "reason": "binary_updated"
    }
  }
}
```

## Development Workflow

1. **Start Development**: Use the proxy in your `.mcp.json`
2. **Code & Test**: Make changes to your MCP server code
3. **Compile**: Rebuild your MCP server binary
4. **Automatic Restart**: Proxy detects the new binary and restarts automatically
5. **Continue Testing**: No need to restart Claude Code or the MCP client

## Command Line Usage

```bash
./mcp_dev_proxy_binary <target_binary> [target_args...]
```

### Examples

```bash
# Basic usage
./mcp_dev_proxy_binary ./my_mcp_server

# With arguments
./mcp_dev_proxy_binary ./my_mcp_server --debug --port 8080

# Flutter automation example
./mcp_dev_proxy_binary ./mcp_flutter_automation/mcp_flutter_automation_binary
```

## Error Scenarios

### Target Binary Not Found
```bash
Error: Target binary does not exist: ./nonexistent_binary
```

### Target Server Unavailable
When requests are sent but the target process isn't running:
```json
{
  "error": {
    "code": -32603,
    "message": "MCP server unavailable",
    "data": {"proxy": "mcp_dev_proxy"}
  }
}
```

## Testing

Run the test suite:
```bash
dart test
```

Test structure:
- `test/unit/` - Unit tests for individual components
- `test/integration/` - Integration tests for the full proxy

## Architecture

The proxy consists of several key components:

- **MCPDevProxy**: Main orchestrator class
- **ProcessManager**: Handles target process lifecycle
- **FileWatcher**: Monitors binary file changes
- **MCPProtocol**: JSON-RPC message parsing and formatting

## Logging

The proxy uses structured logging. Set log level via environment:
```bash
# Set log level (OFF, SEVERE, WARNING, INFO, CONFIG, FINE, FINER, FINEST, ALL)
export LOG_LEVEL=INFO
./mcp_dev_proxy_binary ./target_binary
```

## Limitations

- **Stdio Only**: Currently only supports stdio-based MCP communication
- **Single Process**: One target process per proxy instance
- **File System Events**: Hot reload depends on file system change notifications

## Troubleshooting

### Binary Not Restarting
- Ensure the binary file is actually being replaced/modified
- Check file permissions
- Verify the proxy has permission to kill/start processes

### Messages Not Forwarding
- Verify the target binary accepts JSON-RPC over stdin/stdout
- Check that both proxy and target use the same MCP protocol version
- Enable debug logging to see message flow

### Performance Issues
- The proxy adds minimal latency (< 1ms per request)
- File watching uses efficient OS-level notifications
- Process restart typically takes < 100ms

## Contributing

1. Follow Dart code style guidelines
2. Add tests for new features
3. Update documentation for user-facing changes
4. Ensure all tests pass: `dart test`

## License

This project follows the same license as the parent repository.