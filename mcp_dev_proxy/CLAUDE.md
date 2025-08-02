# MCP Development Proxy

## Project Context
Development proxy for MCP servers with crash reporting and hot-reload capabilities.

## Key Implementation
- **Restart Fix**: `_scheduleRestart()` sends error responses to pending requests before restart to prevent hanging
- **Stdio Injection**: Constructor accepts `stdinStream`/`stdoutSink` parameters with smart defaults
- File watcher detects binary changes and triggers automatic restart

## Compile Binary
```bash
dart compile exe bin/mcp_dev_proxy.dart -o mcp_dev_proxy_binary
```