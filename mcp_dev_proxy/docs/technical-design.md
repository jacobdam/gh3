# MCP Development Proxy - Technical Design

## Architecture Overview

The MCP Development Proxy is designed as a **layered, event-driven system** that provides intelligent intermediary capabilities between MCP clients and servers with a focus on **never blocking AI agents**.

```
┌─────────────────────────────────────────────────────────────────┐
│                        MCP Client                               │
│                     (Claude Code)                               │
└─────────────────────┬───────────────────────────────────────────┘
                      │ JSON-RPC over stdin/stdout
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                   MCP Development Proxy                         │
│  ┌─────────────────┬──────────────────┬──────────────────────┐  │
│  │ Request Router  │ Timeout Manager  │  Response Enhancer   │  │
│  │                 │                  │                      │  │
│  │ • Route to      │ • Method-based   │ • Add proxy metadata │  │
│  │   target/proxy  │   timeouts       │ • Enhance errors     │  │
│  │ • Handle proxy  │ • Cancel late    │ • Structure guidance │  │
│  │   tools         │   responses      │ • Add diagnostics    │  │
│  └─────────────────┼──────────────────┼──────────────────────┘  │
│  ┌─────────────────┴──────────────────┴──────────────────────┐  │
│  │                Process Manager                            │  │
│  │ • Start/stop target server                               │  │
│  │ • Monitor process health                                 │  │
│  │ • Capture crash details                                  │  │
│  │ • Handle restart lifecycle                               │  │
│  └─────────────────┬──────────────────┬──────────────────────┘  │
│  ┌─────────────────┴─────────┬────────┴──────────────────────┐  │
│  │     File Watcher          │    Tool Cycle Tracker         │  │
│  │ • Monitor binary changes  │ • Track tool_use requests     │  │
│  │ • Trigger restart         │ • Detect incomplete cycles    │  │
│  │ • Debounce changes        │ • Generate recovery guidance  │  │
│  └───────────────────────────┴────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────────┘
                      │ JSON-RPC over stdin/stdout  
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Target MCP Server                            │
│                   (User's Server)                               │
└─────────────────────────────────────────────────────────────────┘
```

## Core Components

### 1. MCPDevProxy (Main Orchestrator) - SIMPLIFIED

**Responsibility:** Lightweight coordinator that delegates to components. NO inline logic.

```dart
class MCPDevProxy {
  final ProcessManager _processManager;
  final TimeoutManager _timeoutManager;
  final ResponseEnhancer _responseEnhancer;
  final FileWatcher _fileWatcher;
  final ToolCycleTracker _toolCycleTracker;
  final RequestRouter _requestRouter;
  final ProxyState _state;
  
  // Core lifecycle (delegate to components)
  Future<void> start();
  Future<void> stop();
  
  // Main message handling (DELEGATE ONLY)
  Future<void> handleClientInput(String line) {
    final message = MCPProtocol.parseMessage(line);
    if (message == null) return;
    
    // Route through RequestRouter - NO inline logic
    await _requestRouter.routeRequest(message);
  }
  
  // State access for diagnostics
  ProxyState get currentState => _state;
}
```

**Key Features (REDUCED SCOPE):**
- **Delegates all work to components** - NO business logic
- **Routes all requests through RequestRouter** - NO inline handling
- **Provides ProxyState access** - Single source of truth
- **Manages component lifecycle only** - start/stop coordination

### 2. RequestRouter - EXPANDED RESPONSIBILITY

**Responsibility:** Handle ALL request routing and server unavailable scenarios.

```dart
class RequestRouter {
  final ProcessManager _processManager;
  final TimeoutManager _timeoutManager;
  final ResponseEnhancer _responseEnhancer;
  final ToolCycleTracker _toolCycleTracker;
  final ProxyState _state;
  
  // Main routing method - handles ALL scenarios
  Future<void> routeRequest(MCPMessage message) async {
    // Track tool cycles
    if (message.method == 'tools/call') {
      _toolCycleTracker.startToolCycle(message.id.toString());
    }
    
    // Start timeout for all requests
    if (message.isRequest) {
      _timeoutManager.startTimeout(message.id.toString(), message.method, 
        () => _handleTimeout(message));
    }
    
    // Route based on server availability and request type
    if (!_processManager.isRunning) {
      await _handleServerUnavailable(message);
    } else if (_isProxyTool(message)) {
      await _handleProxyTool(message);
    } else {
      await _forwardToTarget(message);
    }
  }
  
  // Handle all server unavailable scenarios (moved from MCPDevProxy)
  Future<void> _handleServerUnavailable(MCPMessage message);
  
  // Handle proxy tools
  Future<void> _handleProxyTool(MCPMessage message);
  
  // Forward to target with timeout management
  Future<void> _forwardToTarget(MCPMessage message);
}
```

**Key Features (EXPANDED):**
- **Handles ALL request scenarios** - Server available/unavailable, proxy tools, forwarding
- **Integrates timeout management** - No separate timeout handling in MCPDevProxy
- **Integrates tool cycle tracking** - Automatic tracking for all tools/call requests
- **Uses ErrorContext for all errors** - No hardcoded error building

### 3. TimeoutManager

**Responsibility:** Enforce method-specific timeouts and generate timeout errors with actionable guidance.

```dart
class TimeoutManager {
  static const Map<String, Duration> methodTimeouts = {
    'initialize': Duration(seconds: 15),
    'tools/list': Duration(seconds: 10),
    'resources/list': Duration(seconds: 10),
    'prompts/list': Duration(seconds: 10),
    'tools/call': Duration(seconds: 90),
    '_default': Duration(seconds: 30),
  };
  
  // Allow configurable timeouts for long-running operations
  Map<String, Duration> customTimeouts = {};
  
  // Get timeout for specific operation
  Duration getTimeout(String method, Map<String, dynamic>? params) {
    // Check for custom timeout configuration
    if (customTimeouts.containsKey(method)) {
      return customTimeouts[method]!;
    }
    // Check for operation-specific hints (e.g., build operations)
    if (method == 'tools/call' && _isLongRunningOperation(params)) {
      return Duration(seconds: 300); // 5 minutes for builds, complex tests
    }
    return methodTimeouts[method] ?? methodTimeouts['_default']!;
  }
  
  // Start timeout for request
  Timer startTimeout(
    String requestId,
    String method,
    Function onTimeout
  );
  
  // Cancel timeout when response received
  void cancelTimeout(String requestId);
  
  // Generate timeout error with context-aware guidance
  Map<String, dynamic> createTimeoutError(
    String requestId,
    String method,
    Duration timeout,
    Map<String, dynamic>? operationContext
  );
}
```

**Key Features:**
- Method-specific timeout durations
- Automatic timeout error generation
- Late response filtering
- Actionable timeout guidance based on method type

### 4. ProcessManager

**Responsibility:** Manage target server process lifecycle with crash detection and recovery.

```dart
class ProcessManager {
  ProcessState _currentState = ProcessState.notStarted;
  Process? _currentProcess;
  String? _lastCrashDetails;
  int _restartCount = 0;
  
  // Process lifecycle
  Future<bool> startTarget();
  Future<void> stopTarget();
  Future<void> restartTarget();
  
  // State monitoring
  ProcessState get currentState;
  bool get isHealthy;
  String? get lastError;
  
  // Health checking
  Future<bool> checkHealth();
  
  // Crash handling
  void _handleCrash(int exitCode, String stderr);
}

enum ProcessState {
  notStarted,
  starting,
  running,
  crashed,
  stopping
}
```

**Key Features:**
- Automatic crash detection with exit code and stderr capture
- Exponential backoff for restart attempts
- Health monitoring and status reporting
- Graceful shutdown handling

### 5. ResponseEnhancer

**Responsibility:** Transform generic errors into structured, actionable guidance for AI agents.

```dart
class ResponseEnhancer {
  // Enhance error responses
  Map<String, dynamic> enhanceError(
    Map<String, dynamic> originalError,
    ErrorContext context
  );
  
  // Add proxy metadata to successful responses  
  Map<String, dynamic> addProxyMetadata(
    Map<String, dynamic> response,
    ProxyMetadata metadata
  );
  
  // Generate structured guidance
  Map<String, dynamic> generateGuidance(
    ErrorType errorType,
    ErrorContext context
  );
}

class ErrorContext {
  final ProcessState processState;
  final String? binaryPath;
  final String? lastError;
  final int restartCount;
  final bool fileExists;
  final bool fileExecutable;
  final String? detectedRuntime; // node, python, dart, etc.
  final Map<String, dynamic>? operationContext; // Tool name, params, etc.
}
```

**Key Features:**
- Context-aware error enhancement
- Structured guidance generation
- Machine-readable error format
- Recovery instruction generation

### 6. FileWatcher

**Responsibility:** Monitor target binary for changes and trigger automatic restarts.

```dart
class FileWatcher {
  StreamSubscription? _fileWatchSubscription;
  Timer? _pollingTimer;
  DateTime? _lastModified;
  Timer? _debounceTimer;
  
  // Start monitoring
  Future<void> startWatching(String filePath);
  
  // Stop monitoring
  Future<void> stopWatching();
  
  // Change detection
  void _onFileChanged();
  void _debounceRestart();
  
  // Fallback polling
  void _pollForChanges();
}
```

**Key Features:**
- OS-level file system events with polling fallback
- Debounced restart triggers to prevent rapid restarts
- Detection of file creation when initially missing
- Comprehensive error handling for file system issues

### 7. ToolCycleTracker

**Responsibility:** Track incomplete tool_use → tool_result cycles to prevent Claude session breaks.

```dart
class ToolCycleTracker {
  final Map<String, ToolCycleInfo> _pendingCycles = {};
  Timer? _cleanupTimer;
  
  // Cycle tracking
  void startToolCycle(String toolCallId, DateTime timestamp);
  void completeToolCycle(String toolCallId);
  void markCycleInterrupted(String toolCallId, String reason);
  
  // Diagnostic reporting
  ToolCycleReport getReport();
  
  // Cleanup
  void sendErrorsForPendingCycles(String reason);
  void clearAllCycles();
}

class ToolCycleInfo {
  final String id;
  final DateTime startTime;
  final ToolCycleStatus status;
  final String? interruptionReason;
}

class ToolCycleReport {
  final int totalPending;
  final List<String> pendingIds;
  final String recoveryGuidance;
  final bool hasApiRisk;
}
```

**Key Features:**
- Automatic tracking of all tool_call requests
- Detection of incomplete cycles during restart
- Generation of recovery guidance including /resume command
- Cleanup of stale tracking data

## Data Flow Architecture

### 1. Normal Request Flow

```
Client Request → RequestRouter → TimeoutManager → Target Server
                                      ↓
Client ← ResponseEnhancer ← [Response] ← Target Server
```

### 2. Timeout Error Flow

```
Client Request → RequestRouter → TimeoutManager → Target Server
                                      ↓ (timeout)
Client ← ResponseEnhancer ← TimeoutError ← TimeoutManager
```

### 3. Proxy Tool Flow

```
Client Request → RequestRouter → ProxyToolHandler
                      ↓
Client ← ResponseEnhancer ← [Tool Result] ← ProxyToolHandler
```

### 4. Crash Recovery Flow

```
Target Server Crash → ProcessManager → ToolCycleTracker
                           ↓               ↓
                    Error Enhancement ← Pending Cycles Cleanup
                           ↓
                    Client ← Enhanced Error Response
```

## State Management

### Proxy State Model

```dart
class ProxyState {
  final ProcessState processState;
  final String binaryPath;
  final bool binaryExists;
  final bool binaryExecutable;
  final DateTime? lastRestart;
  final int restartCount;
  final String? lastError;
  final bool monitoringActive;
  final int pendingRequests;
  final ToolCycleReport toolCycles;
}
```

### State Transitions

```
[Missing Binary] → [Binary Created] → [Starting] → [Running]
        ↑               ↓                ↓           ↓
        └─── [Error] ←──┴────── [Crashed] ←─────────┘
                ↓                    ↓
            [Enhanced Error] → [Auto Restart]
```

## Error Enhancement Strategy

### Error Classification

```dart
enum ErrorType {
  binaryMissing,        // Target binary not found
  binaryNotExecutable,  // Permission or format issues
  processStartFailed,   // Failed to start process
  processCrashed,       // Process exited unexpectedly
  processTimeout,       // Request timeout
  processUnresponsive,  // Health check failed
  fileSystemError,      // File watching failed
  protocolError         // MCP protocol issues
}
```

### Enhancement Pipeline

1. **Error Detection** - Identify error type and gather context
2. **Context Analysis** - Examine process state, file system, history
3. **Guidance Generation** - Create structured, actionable instructions
4. **Format Enhancement** - Apply machine-readable structure
5. **Delivery** - Send enhanced error to client

### Guidance Templates

```dart
class GuidanceTemplates {
  static const Map<ErrorType, GuidanceTemplate> templates = {
    ErrorType.binaryMissing: GuidanceTemplate(
      problem: "Target MCP server binary not found",
      context: "Expected at: {binary_path}",
      guidance: [
        "Compile your MCP server (examples based on runtime):",
        "  - Dart: dart compile exe {source_path} -o {binary_path}",
        "  - Node.js: Ensure script is executable",
        "  - Python: Ensure script has shebang and is executable",
        "Verify the binary path in your .mcp.json configuration",
        "Use proxy_status tool to check current binary status"
      ],
      nextSteps: ["compile_binary", "check_path", "verify_config"],
      proxyTools: ["proxy_status", "proxy_help"]
    ),
    // ... more templates
  };
}
```

## Extension Points

### 1. Custom Error Enhancers

```dart
abstract class ErrorEnhancer {
  bool canHandle(ErrorType errorType, ErrorContext context);
  Map<String, dynamic> enhance(
    Map<String, dynamic> error, 
    ErrorContext context
  );
}

// Example: Runtime-specific enhancer
class RuntimeSpecificEnhancer extends ErrorEnhancer {
  @override
  bool canHandle(ErrorType errorType, ErrorContext context) {
    return context.detectedRuntime != null;
  }
  
  @override
  Map<String, dynamic> enhance(
    Map<String, dynamic> error,
    ErrorContext context
  ) {
    // Add runtime-specific guidance
    switch (context.detectedRuntime) {
      case 'dart':
        // Add Flutter/Dart specific guidance
        return _enhanceForDart(error, context);
      case 'python':
        // Add Python specific guidance
        return _enhanceForPython(error, context);
      default:
        return error;
    }
  }
}
```

### 2. Additional Proxy Tools

```dart
abstract class ProxyTool {
  String get name;
  String get description;
  Map<String, dynamic> get schema;
  
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> arguments,
    ProxyState state
  );
}

// Built-in proxy tools
class ProxyStatusTool extends ProxyTool {
  @override
  String get name => 'proxy_status';
  
  @override
  String get description => 'Get current proxy and target server status';
  
  @override
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> arguments,
    ProxyState state
  ) async {
    return {
      'binary_path': state.binaryPath,
      'binary_status': _getBinaryStatus(state),
      'process_state': state.processState.toString(),
      'environment': _detectEnvironment(state),
      'last_error': state.lastError,
      'uptime': _calculateUptime(state),
      'restart_count': state.restartCount,
      'monitoring_active': state.monitoringActive,
      'next_steps': _generateNextSteps(state)
    };
  }
}
```

### 3. Custom Process Monitors

```dart
abstract class ProcessMonitor {
  Future<ProcessHealthInfo> checkHealth(Process process);
  bool shouldRestart(ProcessHealthInfo health);
}
```

## Performance Considerations

### Memory Management
- **Bounded collections** for pending requests and tool cycles
- **TTL cleanup** for stale tracking data
- **Efficient file watching** with OS-level events
- **Lazy loading** of diagnostic data

### Latency Optimization
- **Direct forwarding** when target is healthy (< 1ms overhead)
- **Async processing** for non-critical operations
- **Cached responses** for proxy tools
- **Minimal JSON parsing** overhead

### Concurrency Model
- **Single-threaded** event loop for request handling
- **Async I/O** for all network and file operations
- **Non-blocking** timeout management
- **Concurrent** process monitoring and file watching

## Testing Strategy

### Unit Testing
- **Component isolation** with dependency injection
- **State transition testing** for process management
- **Error enhancement verification** for all error types
- **Timeout accuracy testing** with mock timers

### Integration Testing
- **End-to-end request flows** with real processes
- **File watching scenarios** with actual file changes
- **Crash recovery testing** with controlled failures
- **MCP protocol compliance** verification

### Performance Testing
- **Latency benchmarks** for request forwarding
- **Memory usage monitoring** under load
- **Timeout accuracy** under system stress
- **File watching efficiency** with rapid changes

## Clean Code Principles

While maintaining pragmatic development practices, the codebase follows clean code principles where feasible:

### Single Responsibility Principle (SRP)
- **Each component has one clear responsibility**
  - TimeoutManager: Only handles timeout logic
  - ProcessManager: Only manages process lifecycle
  - ResponseEnhancer: Only enhances responses
- **Separation of concerns** between request routing, error handling, and process management

### Open/Closed Principle
- **Extension points** for custom error enhancers and proxy tools
- **Abstract base classes** allow adding new functionality without modifying core code
- **Strategy pattern** for runtime-specific behavior

### Dependency Inversion
- **Components depend on abstractions** (interfaces/abstract classes)
- **Dependency injection** for testability and flexibility
- **Loose coupling** between major components

### Code Organization
```dart
// Clear, descriptive naming
class ToolCycleTracker {  // Not: TCT or ToolTracker
  void startToolCycle()   // Not: start() or beginCycle()
  void completeToolCycle() // Not: complete() or endCycle()
}

// Meaningful constants
static const Duration defaultTimeout = Duration(seconds: 30);
// Not: static const Duration dt = Duration(seconds: 30);

// Self-documenting code with minimal comments
Future<bool> isHealthy() {
  return _currentState == ProcessState.running && 
         _lastHealthCheck.isAfter(DateTime.now().subtract(healthCheckInterval));
}
```

### Error Handling Philosophy
- **Fail fast with clear errors** rather than silent failures
- **Structured error responses** over generic error messages
- **Defensive programming** at component boundaries

### Testing as Documentation
- **Test names describe behavior** clearly
- **Tests serve as usage examples** for components
- **Test structure follows Arrange-Act-Assert** pattern

### Pragmatic Approach
- **Clarity over cleverness** - Simple, readable code preferred
- **Performance where it matters** - Optimize critical paths only
- **Refactor when needed** - Not premature optimization
- **Comments for "why", not "what"** - Code should be self-explanatory

Example of clean code in practice:
```dart
// BAD: Unclear intent, magic numbers
if (rc > 0 && t > 10000) {
  return makeErr(-32603, "timeout");
}

// GOOD: Clear intent, named constants
if (restartCount > 0 && elapsedTime > methodTimeout) {
  return createTimeoutError(
    requestId: request.id,
    method: request.method,
    timeout: methodTimeout,
    context: currentContext
  );
}
```

## Multi-Runtime Support

The proxy is designed to support various MCP server runtimes:

### Runtime Detection
```dart
class RuntimeDetector {
  static String? detectRuntime(String binaryPath) {
    final extension = path.extension(binaryPath);
    final firstLine = _readFirstLine(binaryPath);
    
    if (extension == '.js' || firstLine?.contains('node') == true) {
      return 'node';
    } else if (extension == '.py' || firstLine?.contains('python') == true) {
      return 'python';
    } else if (extension == '.dart' || binaryPath.endsWith('_binary')) {
      return 'dart';
    }
    // Add more runtime detection logic
    return null;
  }
}
```

### Runtime-Specific Features
- **Compilation guidance** adapted to detected runtime
- **Error messages** with runtime-specific troubleshooting
- **Environment validation** for runtime dependencies
- **Timeout defaults** based on typical runtime performance