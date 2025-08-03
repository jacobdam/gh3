# MCP Development Proxy - Technical Design

## Architecture Overview

The MCP Development Proxy is designed as a **layered, event-driven system** that provides intelligent intermediary capabilities between MCP clients and servers with a focus on **never blocking AI agents** and **enabling autonomous problem resolution**.

**Phase 2 Focus**: Agent Autonomy - The architecture supports agents that can diagnose and resolve 90% of development issues independently through enhanced diagnostic tools, graceful degradation, and advanced session recovery.

```
┌─────────────────────────────────────────────────────────────────┐
│                        MCP Client                               │
│                  (AI Agent - Claude Code)                       │
└─────────────────────┬───────────────────────────────────────────┘
                      │ JSON-RPC over stdin/stdout
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                   MCP Development Proxy                         │
│                    **ALWAYS AVAILABLE**                         │
│  ┌─────────────────┬──────────────────┬──────────────────────┐  │
│  │ Request Router  │ Timeout Manager  │  Response Enhancer   │  │
│  │                 │                  │                      │  │
│  │ • Route to      │ • Method-based   │ • Agent-optimized    │  │
│  │   target/proxy  │   timeouts       │   error messages     │  │
│  │ • Handle proxy  │ • Cancel late    │ • Autonomous guidance │  │
│  │   diagnostic    │   responses      │ • Recovery workflows │  │
│  │   tools         │ • Adaptive       │ • Session recovery   │  │
│  │ • Graceful      │   behavior       │   instructions       │  │
│  │   degradation   │                  │                      │  │
│  └─────────────────┼──────────────────┼──────────────────────┘  │
│  ┌─────────────────┴──────────────────┴──────────────────────┐  │
│  │                Process Manager                            │  │
│  │ • Advanced health monitoring                             │  │
│  │ • Intelligent restart strategies                         │  │
│  │ • Context-aware crash analysis                           │  │
│  │ • Environment diagnostics                                │  │
│  └─────────────────┬──────────────────┬──────────────────────┘  │
│  ┌─────────────────┴─────────┬────────┴──────────────────────┐  │
│  │     File Watcher          │   Enhanced Tool Cycle         │  │
│  │ • Smart change detection  │        Tracker                │  │
│  │ • Build-aware triggers    │ • Session recovery guidance   │  │
│  │ • Development workflow    │ • /resume command generation  │  │
│  │   optimization            │ • API validation prevention   │  │
│  └───────────────────────────┼────────────────────────────────┘  │
│  ┌───────────────────────────┴────────────────────────────────┐  │
│  │              Diagnostic Tool Suite                          │  │
│  │ • proxy_status - Comprehensive system state                │  │
│  │ • proxy_help - Autonomous troubleshooting guide            │  │
│  │ • proxy_restart - Controlled restart with validation       │  │
│  │ • proxy_check_tool_cycles - Session recovery analysis      │  │
│  └─────────────────────────────────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────────┘
                      │ JSON-RPC over stdin/stdout  
                      ▼ (Optional - Proxy works without target)
┌─────────────────────────────────────────────────────────────────┐
│                    Target MCP Server                            │
│                   (User's Server)                               │
│                 **MAY BE UNAVAILABLE**                          │
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

### 7. Enhanced ToolCycleTracker - PHASE 2 UPGRADE

**Responsibility:** Advanced tool cycle management with session recovery and autonomous troubleshooting guidance.

```dart
class EnhancedToolCycleTracker {
  final Map<String, AdvancedToolCycleInfo> _pendingCycles = {};
  final List<SessionRecoveryEvent> _recoveryHistory = [];
  Timer? _cleanupTimer;
  
  // Enhanced cycle tracking
  void startToolCycle(String toolCallId, DateTime timestamp, Map<String, dynamic>? context);
  void completeToolCycle(String toolCallId);
  void markCycleInterrupted(String toolCallId, String reason, ErrorContext context);
  
  // Phase 2: Session recovery features
  SessionRecoveryReport generateRecoveryReport();
  String generateResumeCommandGuidance();
  List<RecoveryAction> getAutonomousRecoveryActions();
  
  // Phase 2: Pattern analysis
  void analyzeFailurePatterns();
  Map<String, dynamic> getSessionHealthMetrics();
  
  // Enhanced diagnostic reporting
  AdvancedToolCycleReport getDetailedReport();
  
  // Cleanup with context preservation
  void sendErrorsForPendingCycles(String reason, ErrorContext context);
  void preserveContextForRecovery(List<String> toolIds);
}

class AdvancedToolCycleInfo {
  final String id;
  final DateTime startTime;
  final ToolCycleStatus status;
  final String? interruptionReason;
  final Map<String, dynamic>? operationContext; // Tool name, params, etc.
  final Duration? estimatedDuration;
  final int retryCount;
}

class SessionRecoveryReport {
  final int totalInterrupted;
  final List<String> recoverableOperations;
  final String resumeCommandText;
  final bool requiresHumanIntervention;
  final List<RecoveryAction> autonomousActions;
}

class RecoveryAction {
  final String actionType; // 'restart', 'retry', 'skip', 'resume'
  final String description;
  final Map<String, dynamic> parameters;
  final bool isAutonomous;
}
```

**Phase 2 Key Features:**
- **Session recovery guidance** with /resume command generation
- **Pattern analysis** for failure prediction and prevention
- **Context preservation** across interruptions
- **Autonomous recovery actions** for common scenarios
- **Advanced diagnostic reporting** with actionable insights
- **API validation error prevention** through proactive cycle management

### 8. Diagnostic Tool Suite - PHASE 2 NEW COMPONENT

**Responsibility:** Comprehensive autonomous troubleshooting and system diagnostics for AI agents.

```dart
class DiagnosticToolSuite {
  final ProcessManager _processManager;
  final ProxyState _state;
  final EnhancedToolCycleTracker _toolCycleTracker;
  final RuntimeDetector _runtimeDetector;
  
  // Core diagnostic tools
  Future<Map<String, dynamic>> executeProxyStatus();
  Future<Map<String, dynamic>> executeProxyHelp();
  Future<Map<String, dynamic>> executeProxyRestart(Map<String, dynamic> params);
  Future<Map<String, dynamic>> executeProxyCheckToolCycles();
  
  // Phase 2: Advanced diagnostics
  Future<Map<String, dynamic>> executeEnvironmentAnalysis();
  Future<Map<String, dynamic>> executeRecoveryGuidance(ErrorContext context);
  Future<Map<String, dynamic>> executeSessionHealth();
  
  // Autonomous troubleshooting workflows
  Future<List<DiagnosticAction>> generateTroubleshootingPlan(ErrorType errorType);
  Future<Map<String, dynamic>> executeAutonomousRecovery(String recoveryPlan);
  
  // Tool registration and discovery
  List<ProxyTool> getAvailableTools();
  bool isToolAvailable(String toolName);
}

class ProxyStatusTool extends ProxyTool {
  @override
  String get name => 'proxy_status';
  
  @override
  String get description => 'Comprehensive system state and autonomous guidance';
  
  @override
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> arguments,
    ProxyState state
  ) async {
    return {
      // Basic status
      'binary_path': state.binaryPath,
      'binary_status': _getBinaryStatus(state),
      'process_state': state.processState.toString(),
      
      // Phase 2: Enhanced diagnostics
      'environment': await _analyzeEnvironment(state),
      'health_metrics': _calculateHealthMetrics(state),
      'session_status': _getSessionStatus(state),
      
      // Autonomous guidance
      'autonomous_actions': _generateAutonomousActions(state),
      'recovery_options': _getRecoveryOptions(state),
      'next_steps': _generateContextualNextSteps(state),
      
      // Learning and adaptation
      'failure_patterns': _analyzeFailurePatterns(state),
      'optimization_suggestions': _getOptimizationSuggestions(state),
    };
  }
}

class ProxyHelpTool extends ProxyTool {
  @override
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> arguments,
    ProxyState state
  ) async {
    return {
      'usage_guide': _generateUsageGuide(),
      'troubleshooting_workflows': _getTroubleshootingWorkflows(),
      'autonomous_recovery_guide': _getAutonomousRecoveryGuide(),
      'common_patterns': _getCommonPatterns(),
      'environment_setup': _getEnvironmentSetupGuide(state),
      'session_recovery': _getSessionRecoveryGuide(),
    };
  }
}

class ProxyCheckToolCyclesTool extends ProxyTool {
  @override
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> arguments,
    ProxyState state
  ) async {
    final report = _toolCycleTracker.generateRecoveryReport();
    return {
      'pending_cycles': report.totalInterrupted,
      'recoverable_operations': report.recoverableOperations,
      'resume_command': report.resumeCommandText,
      'autonomous_recovery': report.autonomousActions,
      'session_health': _getSessionHealthScore(),
      'recovery_guidance': _generateStepByStepRecovery(report),
    };
  }
}
```

**Phase 2 Key Features:**
- **Comprehensive system diagnostics** for autonomous troubleshooting
- **Environment analysis** with runtime-specific guidance
- **Session health monitoring** and recovery recommendations
- **Autonomous action generation** for common failure scenarios
- **Pattern recognition** for predictive guidance
- **Step-by-step recovery workflows** optimized for AI agents

## Data Flow Architecture - PHASE 2 ENHANCED

### 1. Normal Request Flow (Target Available)

```
Client Request → RequestRouter → TimeoutManager → Target Server
                      ↓                ↓
                 DiagnosticTools    Context Tracking
                      ↓                ↓
Client ← ResponseEnhancer ← [Enhanced Response] ← Target Server
```

### 2. Graceful Degradation Flow (Target Unavailable)

```
Client Request → RequestRouter → DiagnosticToolSuite
                      ↓               ↓
                 Always Available  Autonomous
                 Proxy Response    Guidance
                      ↓               ↓
Client ← ResponseEnhancer ← [Diagnostic Response + Recovery Actions]
```

### 3. Autonomous Troubleshooting Flow

```
Error Detection → DiagnosticToolSuite → Environment Analysis
       ↓                 ↓                      ↓
Pattern Analysis → Recovery Planning → Autonomous Actions
       ↓                 ↓                      ↓
Client ← Enhanced Response ← [Structured Guidance + Next Steps]
```

### 4. Advanced Session Recovery Flow

```
Server Interruption → EnhancedToolCycleTracker → Context Preservation
        ↓                       ↓                        ↓
Pending Cycle Analysis → Recovery Planning → /resume Generation
        ↓                       ↓                        ↓
Client ← SessionRecoveryReport ← [Recovery Actions + Guidance]
```

### 5. Progressive Enhancement Flow

```
    Target Unavailable        Target Becomes Available
           ↓                           ↓
    Proxy-Only Mode  →  Seamless Transition  →  Full Proxy+Target Mode
           ↓                           ↓                    ↓
  Diagnostic Tools         State Sync           Enhanced Forwarding
           ↓                           ↓                    ↓
    Client ← Basic Proxy Response | Full Enhanced Response
```

### 6. Failure Pattern Learning Flow

```
Failure Event → Pattern Analysis → Learning Update → Guidance Enhancement
      ↓               ↓                 ↓                  ↓
Context Capture → Correlation → Knowledge Base → Improved Responses
      ↓               ↓                 ↓                  ↓
Client ← Immediate Response + Future Guidance Improvement
```

## State Management - PHASE 2 ENHANCED

### Enhanced Proxy State Model

```dart
class EnhancedProxyState {
  // Core state
  final ProcessState processState;
  final String binaryPath;
  final bool binaryExists;
  final bool binaryExecutable;
  final DateTime? lastRestart;
  final int restartCount;
  final String? lastError;
  final bool monitoringActive;
  final int pendingRequests;
  
  // Phase 2: Agent autonomy state
  final AdvancedToolCycleReport toolCycles;
  final AutonomyLevel currentAutonomyLevel;
  final SessionHealth sessionHealth;
  final Map<String, dynamic> environmentDiagnostics;
  final List<RecoveryAction> availableRecoveryActions;
  final FailurePatternAnalysis patternAnalysis;
  
  // Phase 2: Graceful degradation state
  final OperationalMode operationalMode; // proxy_only, target_available, degraded
  final List<String> availableProxyTools;
  final DiagnosticCapabilities diagnosticCapabilities;
  
  // Phase 2: Learning and adaptation
  final AdaptationMetrics adaptationMetrics;
  final Map<String, double> successProbabilities;
}

enum OperationalMode {
  proxyOnly,        // Target unavailable, proxy provides diagnostics
  targetAvailable,  // Normal operation with target
  degraded,         // Partial functionality due to issues
  recovery,         // Actively recovering from failures
}

enum AutonomyLevel {
  high,    // Agent can resolve 90%+ of issues independently
  medium,  // Agent can resolve common issues with guidance
  low,     // Agent requires significant guidance
  blocked, // Agent cannot proceed without human intervention
}

class SessionHealth {
  final double healthScore; // 0.0 - 1.0
  final int consecutiveSuccesses;
  final int recentFailures;
  final Duration avgResponseTime;
  final bool sessionContinuityRisk;
  final List<String> healthWarnings;
}

class DiagnosticCapabilities {
  final bool canAnalyzeEnvironment;
  final bool canExecuteRecovery;
  final bool canPreserveContext;
  final bool canGenerateGuidance;
  final List<String> availableAnalyses;
}
```

### Enhanced State Transitions

```
[Missing Binary] → [Environment Analysis] → [Autonomous Compilation]
        ↑                    ↓                        ↓
[Pattern Learning] ←─ [Enhanced Error] → [Binary Created] → [Starting]
        ↑                    ↓                        ↓        ↓
[Adaptation] ←───────── [Recovery] ←────────── [Crashed] ← [Running]
        ↓                    ↓                        ↓        ↓
[Improved Guidance] → [Auto Restart] → [Session Recovery] → [Enhanced Response]
                           ↓                        ↓              ↓
                    [Context Preservation] → [Continuity Maintained] → [Agent Success]
```

### Graceful Degradation State Flow

```
    Target Available                    Target Unavailable
           ↓                                   ↓
    [Full Operation]  ←─ Transition ─→  [Proxy-Only Mode]
           ↓                                   ↓
    Enhanced Forwarding                 Diagnostic Tools
           ↓                                   ↓
    Full Tool Suite                     Recovery Guidance
           ↓                                   ↓
    Agent Development  ←─ Seamless ─→  Autonomous Troubleshooting
```

## Error Enhancement Strategy - PHASE 2 AGENT AUTONOMY

### Enhanced Error Classification

```dart
enum ErrorType {
  // Core errors
  binaryMissing,        // Target binary not found
  binaryNotExecutable,  // Permission or format issues
  processStartFailed,   // Failed to start process
  processCrashed,       // Process exited unexpectedly
  processTimeout,       // Request timeout
  processUnresponsive,  // Health check failed
  fileSystemError,      // File watching failed
  protocolError,        // MCP protocol issues
  
  // Phase 2: Agent-specific errors
  sessionInterrupted,   // Tool cycle interrupted
  environmentMismatch,  // Runtime/dependency issues
  autonomousRecoveryFailed, // Self-healing attempt failed
  contextLoss,          // Development context lost
  workflowBlocked,      // Development flow interrupted
}
```

### Agent-Optimized Enhancement Pipeline

1. **Smart Error Detection** - AI-aware error classification with context
2. **Environment Analysis** - Runtime, dependencies, development state
3. **Autonomous Action Planning** - Generate executable recovery steps
4. **Pattern-Based Guidance** - Learn from previous failures
5. **Session Context Preservation** - Maintain development continuity
6. **Recovery Workflow Generation** - Step-by-step autonomous resolution
7. **Structured Delivery** - Machine-readable format optimized for agents

### Agent Autonomy Guidance Templates

```dart
class AgentAutonomyGuidanceTemplates {
  static const Map<ErrorType, AgentGuidanceTemplate> templates = {
    ErrorType.binaryMissing: AgentGuidanceTemplate(
      problem: "Target MCP server binary not found",
      severity: "blocking",
      autonomyLevel: "high", // Agent can resolve independently
      context: {
        "expected_path": "{binary_path}",
        "detected_runtime": "{runtime}",
        "environment_status": "{env_analysis}"
      },
      autonomousActions: [
        {
          "action": "detect_source_files",
          "command": "find . -name '*.dart' -o -name '*.js' -o -name '*.py'",
          "success_criteria": "source_files_found"
        },
        {
          "action": "compile_binary",
          "command": "dart compile exe {main_file} -o {binary_path}",
          "runtime_specific": true,
          "success_criteria": "binary_created"
        },
        {
          "action": "verify_executable",
          "command": "chmod +x {binary_path} && ls -la {binary_path}",
          "success_criteria": "executable_verified"
        }
      ],
      fallbackActions: [
        "use_proxy_status_for_diagnosis",
        "check_environment_setup",
        "request_human_intervention"
      ],
      recoveryWorkflow: {
        "steps": [
          "1. Execute source file detection",
          "2. Compile using detected runtime",
          "3. Verify binary permissions",
          "4. Test proxy connection",
          "5. Resume development workflow"
        ],
        "estimated_time": "30-60 seconds",
        "success_probability": 0.95
      },
      nextSteps: ["execute_autonomous_recovery", "verify_resolution", "continue_development"],
      proxyTools: ["proxy_status", "proxy_help", "proxy_restart"]
    ),
    
    ErrorType.sessionInterrupted: AgentGuidanceTemplate(
      problem: "Development session interrupted by server restart",
      severity: "moderate",
      autonomyLevel: "high",
      context: {
        "interrupted_cycles": "{cycle_count}",
        "recoverable_operations": "{recoverable_list}",
        "session_duration": "{session_time}"
      },
      autonomousActions: [
        {
          "action": "analyze_interrupted_cycles",
          "tool": "proxy_check_tool_cycles",
          "success_criteria": "cycles_analyzed"
        },
        {
          "action": "execute_session_recovery",
          "command": "/resume",
          "context_preservation": true,
          "success_criteria": "session_restored"
        }
      ],
      recoveryWorkflow: {
        "steps": [
          "1. Check tool cycle status",
          "2. Identify recoverable operations",
          "3. Execute /resume command",
          "4. Verify session continuity",
          "5. Continue development from last stable state"
        ],
        "estimated_time": "5-10 seconds",
        "success_probability": 0.98
      }
    )
  };
}

class AgentGuidanceTemplate {
  final String problem;
  final String severity; // blocking, moderate, minor
  final String autonomyLevel; // high, medium, low
  final Map<String, dynamic> context;
  final List<Map<String, dynamic>> autonomousActions;
  final List<String> fallbackActions;
  final Map<String, dynamic> recoveryWorkflow;
  final List<String> nextSteps;
  final List<String> proxyTools;
}
```

### Autonomous Recovery Engine

```dart
class AutonomousRecoveryEngine {
  final DiagnosticToolSuite _diagnostics;
  final Map<ErrorType, List<RecoveryStrategy>> _strategies;
  
  // Execute autonomous recovery
  Future<RecoveryResult> executeRecovery(
    ErrorType errorType,
    ErrorContext context
  ) async {
    final strategies = _strategies[errorType] ?? [];
    
    for (final strategy in strategies) {
      final result = await _attemptRecovery(strategy, context);
      if (result.success) {
        return result;
      }
    }
    
    return RecoveryResult.failed('All autonomous recovery attempts failed');
  }
  
  // Generate recovery plan
  Future<RecoveryPlan> generateRecoveryPlan(
    ErrorType errorType,
    ErrorContext context
  ) async {
    return RecoveryPlan(
      steps: _generateRecoverySteps(errorType, context),
      estimatedDuration: _estimateRecoveryTime(errorType),
      successProbability: _calculateSuccessProbability(errorType, context),
      fallbackOptions: _getFallbackOptions(errorType)
    );
  }
}
```

## Extension Points - PHASE 2 ENHANCED

### 1. Agent-Optimized Error Enhancers

```dart
abstract class AgentErrorEnhancer {
  bool canHandle(ErrorType errorType, ErrorContext context);
  Future<Map<String, dynamic>> enhance(
    Map<String, dynamic> error, 
    ErrorContext context
  );
  
  // Phase 2: Autonomous recovery capabilities
  bool canProvideAutonomousRecovery(ErrorType errorType);
  Future<List<RecoveryAction>> generateRecoveryActions(
    ErrorType errorType, 
    ErrorContext context
  );
}

// Example: Flutter/Dart autonomous enhancer
class FlutterAutonomousEnhancer extends AgentErrorEnhancer {
  @override
  bool canHandle(ErrorType errorType, ErrorContext context) {
    return context.detectedRuntime == 'dart' || 
           context.detectedRuntime == 'flutter';
  }
  
  @override
  Future<Map<String, dynamic>> enhance(
    Map<String, dynamic> error,
    ErrorContext context
  ) async {
    final flutterDiagnostics = await _runFlutterDoctor();
    final dartAnalysis = await _analyzeDartProject(context.binaryPath);
    
    return {
      ...error,
      'flutter_diagnostics': flutterDiagnostics,
      'dart_analysis': dartAnalysis,
      'autonomous_actions': await generateRecoveryActions(
        context.errorType, 
        context
      ),
      'build_guidance': _generateBuildGuidance(context),
      'dependency_status': await _checkDependencies(context),
    };
  }
  
  @override
  bool canProvideAutonomousRecovery(ErrorType errorType) {
    return [ErrorType.binaryMissing, ErrorType.processStartFailed, 
            ErrorType.processCrashed].contains(errorType);
  }
  
  @override
  Future<List<RecoveryAction>> generateRecoveryActions(
    ErrorType errorType, 
    ErrorContext context
  ) async {
    switch (errorType) {
      case ErrorType.binaryMissing:
        return [
          RecoveryAction(
            actionType: 'compile',
            description: 'Compile Dart project to binary',
            parameters: {
              'command': 'dart compile exe bin/main.dart -o ${context.binaryPath}',
              'working_directory': context.projectRoot,
            },
            isAutonomous: true,
          ),
          RecoveryAction(
            actionType: 'verify',
            description: 'Verify binary creation and permissions',
            parameters: {
              'command': 'ls -la ${context.binaryPath}',
            },
            isAutonomous: true,
          ),
        ];
      default:
        return [];
    }
  }
}
```

### 2. Enhanced Diagnostic Tools

```dart
abstract class AdvancedProxyTool extends ProxyTool {
  // Phase 2: Autonomous execution capabilities
  bool get supportsAutonomousExecution;
  Future<bool> canExecuteAutonomously(Map<String, dynamic> context);
  
  // Phase 2: Learning and adaptation
  void recordExecutionOutcome(bool success, Map<String, dynamic> context);
  double getSuccessProbability(Map<String, dynamic> context);
  
  // Phase 2: Progressive enhancement
  Future<Map<String, dynamic>> executeWithFallback(
    Map<String, dynamic> arguments,
    ProxyState state
  );
}

// Example: Autonomous environment analyzer
class EnvironmentAnalyzerTool extends AdvancedProxyTool {
  @override
  String get name => 'proxy_analyze_environment';
  
  @override
  bool get supportsAutonomousExecution => true;
  
  @override
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> arguments,
    ProxyState state
  ) async {
    final analysis = await _performComprehensiveAnalysis(state);
    
    return {
      'runtime_environment': analysis.runtimeInfo,
      'dependency_status': analysis.dependencies,
      'development_tools': analysis.devTools,
      'common_issues': analysis.detectedIssues,
      'autonomous_fixes': analysis.autonomousFixes,
      'environment_score': analysis.healthScore,
      'optimization_suggestions': analysis.optimizations,
    };
  }
  
  @override
  Future<bool> canExecuteAutonomously(Map<String, dynamic> context) async {
    // Check if environment analysis can be performed safely
    return _hasRequiredPermissions() && _isEnvironmentStable();
  }
}
```

### 3. Graceful Degradation Handlers

```dart
abstract class DegradationHandler {
  bool canHandle(OperationalMode fromMode, OperationalMode toMode);
  Future<void> handleTransition(
    OperationalMode fromMode, 
    OperationalMode toMode,
    ProxyState state
  );
  Future<Map<String, dynamic>> getCapabilitiesInMode(OperationalMode mode);
}

class AlwaysAvailableHandler extends DegradationHandler {
  @override
  bool canHandle(OperationalMode fromMode, OperationalMode toMode) {
    return toMode == OperationalMode.proxyOnly;
  }
  
  @override
  Future<void> handleTransition(
    OperationalMode fromMode, 
    OperationalMode toMode,
    ProxyState state
  ) async {
    // Ensure proxy remains fully functional
    await _enableProxyOnlyMode(state);
    await _activateAllDiagnosticTools();
    await _preserveSessionContext(state);
  }
  
  @override
  Future<Map<String, dynamic>> getCapabilitiesInMode(
    OperationalMode mode
  ) async {
    return {
      'available_tools': _getAvailableProxyTools(),
      'diagnostic_capabilities': _getDiagnosticCapabilities(),
      'autonomous_recovery': _getRecoveryCapabilities(),
      'session_preservation': _getSessionCapabilities(),
    };
  }
}
```

### 2. Phase 2 Enhanced Proxy Tools

```dart
// Phase 2: All proxy tools support autonomous execution
abstract class ProxyTool {
  String get name;
  String get description;
  Map<String, dynamic> get schema;
  
  // Phase 2: Autonomous execution support
  bool get supportsAutonomousExecution => false;
  
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> arguments,
    ProxyState state
  );
  
  // Phase 2: Progressive enhancement
  Future<Map<String, dynamic>> executeWithGracefulDegradation(
    Map<String, dynamic> arguments,
    ProxyState state
  ) async {
    try {
      return await execute(arguments, state);
    } catch (e) {
      return _generateFallbackResponse(e, arguments, state);
    }
  }
}

// Enhanced proxy tools for Phase 2
class EnhancedProxyStatusTool extends ProxyTool {
  @override
  String get name => 'proxy_status';
  
  @override
  String get description => 'Comprehensive system diagnostics and autonomous guidance';
  
  @override
  bool get supportsAutonomousExecution => true;
  
  @override
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> arguments,
    ProxyState state
  ) async {
    final environmentAnalysis = await _analyzeEnvironment(state);
    final sessionHealth = await _calculateSessionHealth(state);
    final autonomousActions = await _generateAutonomousActions(state);
    
    return {
      // Basic status (Phase 0)
      'binary_path': state.binaryPath,
      'binary_status': _getBinaryStatus(state),
      'process_state': state.processState.toString(),
      
      // Phase 2: Enhanced diagnostics
      'operational_mode': state.operationalMode.toString(),
      'autonomy_level': state.currentAutonomyLevel.toString(),
      'session_health': sessionHealth.toJson(),
      'environment_analysis': environmentAnalysis,
      
      // Phase 2: Autonomous capabilities
      'available_autonomous_actions': autonomousActions,
      'recovery_options': await _getRecoveryOptions(state),
      'pattern_analysis': state.patternAnalysis.toJson(),
      
      // Phase 2: Agent-optimized guidance
      'next_steps': _generateContextualNextSteps(state),
      'success_probabilities': state.successProbabilities,
      'estimated_resolution_time': _estimateResolutionTime(state),
    };
  }
}

class SessionRecoveryTool extends ProxyTool {
  @override
  String get name => 'proxy_recover_session';
  
  @override
  String get description => 'Advanced session recovery with context preservation';
  
  @override
  bool get supportsAutonomousExecution => true;
  
  @override
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> arguments,
    ProxyState state
  ) async {
    final recoveryReport = await _toolCycleTracker.generateRecoveryReport();
    final contextAnalysis = await _analyzeSessionContext(state);
    
    return {
      'recovery_status': recoveryReport.toJson(),
      'session_context': contextAnalysis,
      'resume_command': recoveryReport.resumeCommandText,
      'autonomous_recovery_actions': recoveryReport.autonomousActions,
      'context_preservation_score': _calculateContextScore(state),
      'recovery_workflow': _generateRecoveryWorkflow(recoveryReport),
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

## Phase 2 Quality Gates and Success Criteria

### Agent Autonomy Metrics
- **90% autonomous resolution** - Agents resolve issues without human intervention
- **< 5 second diagnostic feedback** - Fast problem identification and guidance
- **100% actionable errors** - Every error includes executable recovery steps
- **Zero session breaks** - All tool cycles complete or provide recovery guidance
- **Seamless degradation** - Proxy remains useful when target completely fails

### Operational Excellence
- **Always-available guarantee** - Proxy never becomes unresponsive
- **Context preservation** - Development progress maintained through failures
- **Progressive enhancement** - Smooth transitions between operational modes
- **Learning adaptation** - Guidance quality improves based on failure patterns

## Clean Code Principles - PHASE 2 ENHANCED

While maintaining pragmatic development practices, the Phase 2 codebase follows clean code principles optimized for AI agent development:

### Single Responsibility Principle (SRP) - Phase 2 Enhanced
- **Each component has one clear responsibility optimized for agent autonomy**
  - DiagnosticToolSuite: Autonomous troubleshooting and system analysis
  - EnhancedToolCycleTracker: Session recovery and context preservation
  - GracefulDegradationManager: Always-available proxy functionality
  - AutonomousRecoveryEngine: Independent problem resolution
- **Clear separation** between diagnostic, recovery, and operational concerns
- **Agent-centric design** with components optimized for autonomous operation

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

## Graceful Degradation Architecture - PHASE 2 CORE FEATURE

**Objective**: Ensure the proxy remains useful and provides autonomous guidance even when the target server is completely unavailable.

### Always-Available Proxy Design

```dart
class GracefulDegradationManager {
  final DiagnosticToolSuite _diagnostics;
  final OperationalMode _currentMode;
  final Map<OperationalMode, Set<String>> _modeCapabilities;
  
  // Core degradation management
  Future<void> transitionToMode(OperationalMode newMode, ErrorContext context);
  OperationalMode determineOptimalMode(ProxyState state);
  
  // Always-available proxy responses
  Future<Map<String, dynamic>> handleInitializeRequest(
    Map<String, dynamic> request,
    ProxyState state
  ) async {
    return {
      'capabilities': {
        'tools': await _getAvailableTools(state.operationalMode),
        'resources': [], // Proxy doesn't provide resources
        'prompts': [],   // Proxy doesn't provide prompts
        'experimental': {
          'proxy_mode': state.operationalMode.toString(),
          'autonomous_recovery': state.currentAutonomyLevel.toString(),
        }
      },
      'server_info': {
        'name': 'MCP Development Proxy',
        'version': '2.0.0-phase2',
        'mode': state.operationalMode.toString(),
        'target_status': _getTargetStatus(state),
        'diagnostic_capabilities': state.diagnosticCapabilities.toJson(),
      },
      'proxy_guidance': await _generateInitializationGuidance(state),
    };
  }
  
  Future<Map<String, dynamic>> handleToolsListRequest(
    ProxyState state
  ) async {
    final availableTools = await _getAvailableTools(state.operationalMode);
    
    return {
      'tools': availableTools.map((tool) => {
        'name': tool.name,
        'description': tool.description,
        'inputSchema': tool.schema,
      }).toList(),
      'proxy_metadata': {
        'operational_mode': state.operationalMode.toString(),
        'total_tools': availableTools.length,
        'autonomous_tools': availableTools.where((t) => t.supportsAutonomousExecution).length,
        'target_available': state.operationalMode == OperationalMode.targetAvailable,
      }
    };
  }
}
```

### Progressive Enhancement Strategy

```dart
class ProgressiveEnhancementEngine {
  // Seamless transitions between operational modes
  Future<void> handleTargetAvailabilityChange(
    bool targetAvailable,
    ProxyState currentState
  ) async {
    if (targetAvailable && currentState.operationalMode == OperationalMode.proxyOnly) {
      await _transitionToTargetAvailable(currentState);
    } else if (!targetAvailable && currentState.operationalMode == OperationalMode.targetAvailable) {
      await _transitionToProxyOnly(currentState);
    }
  }
  
  Future<void> _transitionToTargetAvailable(ProxyState state) async {
    // 1. Verify target server is responsive
    final isHealthy = await _verifyTargetHealth();
    if (!isHealthy) return;
    
    // 2. Synchronize state
    await _synchronizeProxyState(state);
    
    // 3. Enable full tool suite
    await _enableFullToolSuite();
    
    // 4. Preserve any ongoing diagnostic context
    await _preserveDiagnosticContext(state);
    
    // 5. Notify client of enhanced capabilities
    await _notifyCapabilityEnhancement();
  }
  
  Future<void> _transitionToProxyOnly(ProxyState state) async {
    // 1. Preserve session context
    await _preserveSessionContext(state);
    
    // 2. Send errors for pending requests
    await _handlePendingRequestsGracefully(state);
    
    // 3. Activate diagnostic-only mode
    await _activateDiagnosticMode();
    
    // 4. Generate recovery guidance
    await _generateRecoveryGuidance(state);
  }
}
```

### Operational Mode Capabilities Matrix

```dart
class OperationalModeCapabilities {
  static const Map<OperationalMode, ModeCapabilities> capabilities = {
    OperationalMode.proxyOnly: ModeCapabilities(
      availableTools: [
        'proxy_status',
        'proxy_help', 
        'proxy_restart',
        'proxy_check_tool_cycles',
        'proxy_analyze_environment',
        'proxy_recover_session',
      ],
      canForwardRequests: false,
      canProvideTargetInfo: false,
      canExecuteAutonomousRecovery: true,
      canPreserveSessionContext: true,
      agentGuidanceLevel: AutonomyLevel.high,
      description: 'Full diagnostic and recovery capabilities without target',
    ),
    
    OperationalMode.targetAvailable: ModeCapabilities(
      availableTools: [
        // All proxy tools PLUS target server tools
        'proxy_status',
        'proxy_help',
        'proxy_restart', 
        'proxy_check_tool_cycles',
        // ... plus all target server tools via forwarding
      ],
      canForwardRequests: true,
      canProvideTargetInfo: true,
      canExecuteAutonomousRecovery: true,
      canPreserveSessionContext: true,
      agentGuidanceLevel: AutonomyLevel.high,
      description: 'Full proxy + target capabilities with enhanced monitoring',
    ),
    
    OperationalMode.degraded: ModeCapabilities(
      availableTools: [
        'proxy_status',
        'proxy_help',
        'proxy_restart',
        // Limited tool set due to partial failure
      ],
      canForwardRequests: false,
      canProvideTargetInfo: true, // Cached info
      canExecuteAutonomousRecovery: true,
      canPreserveSessionContext: true,
      agentGuidanceLevel: AutonomyLevel.medium,
      description: 'Reduced capabilities during recovery from partial failures',
    ),
  };
}
```

### Agent Continuity Preservation

```dart
class AgentContinuityManager {
  // Maintain development workflow continuity
  Future<void> preserveWorkflowContext(
    ProxyState state,
    List<String> activeOperations
  ) async {
    final context = WorkflowContext(
      activeOperations: activeOperations,
      developmentPhase: _detectDevelopmentPhase(state),
      lastSuccessfulOperations: _getRecentSuccesses(state),
      failurePatterns: _analyzeFailurePatterns(state),
    );
    
    await _storeContext(context);
    await _generateContinuityGuidance(context);
  }
  
  // Generate guidance for seamless workflow resumption
  Future<Map<String, dynamic>> generateResumptionGuidance(
    WorkflowContext context
  ) async {
    return {
      'workflow_state': context.developmentPhase,
      'recommended_next_steps': _generateNextSteps(context),
      'context_preservation_score': _calculatePreservationScore(context),
      'autonomous_resumption_actions': _getResumptionActions(context),
      'estimated_resumption_time': _estimateResumptionTime(context),
    };
  }
}
```

## Multi-Runtime Support - PHASE 2 ENHANCED

The proxy is designed to support various MCP server runtimes with intelligent autonomous guidance:

### Enhanced Runtime Detection
```dart
class EnhancedRuntimeDetector {
  static Future<RuntimeAnalysis> analyzeRuntime(String binaryPath) async {
    final extension = path.extension(binaryPath);
    final firstLine = await _readFirstLine(binaryPath);
    final directoryAnalysis = await _analyzeProjectStructure(binaryPath);
    
    final runtime = _detectPrimaryRuntime(extension, firstLine, directoryAnalysis);
    final dependencies = await _analyzeDependencies(binaryPath, runtime);
    final buildTools = await _detectBuildTools(binaryPath, runtime);
    
    return RuntimeAnalysis(
      primaryRuntime: runtime,
      version: await _detectVersion(runtime),
      buildSystem: buildTools,
      dependencies: dependencies,
      compilationRequired: _requiresCompilation(runtime),
      autonomousCompilationSupported: _supportsAutonomousCompilation(runtime),
      environmentValidation: await _validateEnvironment(runtime),
    );
  }
  
  static Map<String, List<String>> get runtimeSpecificCommands => {
    'dart': [
      'dart compile exe {source} -o {binary}',
      'dart analyze',
      'dart test',
      'dart pub get',
    ],
    'flutter': [
      'dart compile exe {source} -o {binary}',
      'flutter analyze', 
      'flutter test',
      'flutter doctor',
      'flutter pub get',
    ],
    'python': [
      'chmod +x {binary}',
      'python -m py_compile {source}',
      'pip install -r requirements.txt',
    ],
    'node': [
      'chmod +x {binary}',
      'npm install',
      'npm test',
    ],
  };
}
```

### Runtime-Specific Autonomous Features
- **Intelligent compilation** with autonomous build command generation
- **Environment validation** with automatic dependency checking
- **Error pattern recognition** specific to each runtime
- **Performance optimization** based on runtime characteristics
- **Development workflow adaptation** for each ecosystem

## Phase 2 Architecture Summary

**Core Principle**: The proxy is **always available** and **maximally helpful** regardless of target server state.

### Key Architectural Enhancements:
1. **Always-Available Design** - Never fails to provide useful responses
2. **Progressive Enhancement** - Seamless transitions between operational modes
3. **Autonomous Recovery** - AI agents can resolve 90% of issues independently
4. **Session Continuity** - Development context preserved through all failures
5. **Intelligent Adaptation** - Learning from patterns to improve guidance
6. **Runtime Intelligence** - Deep understanding of development environments

### Agent Development Workflow Support:
- **Never-blocking operations** - All requests complete with actionable results
- **Autonomous problem resolution** - Agents fix issues without human intervention
- **Continuous development flow** - Hot reload and recovery without manual steps
- **Session recovery** - /resume command and context preservation
- **Learning guidance** - Error messages improve over time based on patterns