# MCP Integration Technical Design

## Overview

The MCP (Model Context Protocol) integration provides AI assistants with direct access to Flutter development tools, screenshot capabilities, and GitHub-specific automation. The system integrates with the existing Injectable DI framework and follows the modular architecture patterns established in the gh3 project.

## Architecture

### Service Layer Architecture

```
┌─────────────────────────────────────────────────┐
│                  AI Assistants                  │
│            (Claude, Cursor, etc.)               │
└─────────────────┬───────────────────────────────┘
                  │ MCP Protocol
┌─────────────────▼───────────────────────────────┐
│                MCP Services                     │
├─────────────────┬───────────────────────────────┤
│   McpService    │   McpGitHubTools              │
│   (Core)        │   (GitHub Integration)        │
├─────────────────┼───────────────────────────────┤
│ McpDevelopmentWorkflow                          │
│ (Workflow Automation)                           │
└─────────────────┬───────────────────────────────┘
                  │ Injectable DI
┌─────────────────▼───────────────────────────────┐
│            Existing Services                    │
│  AuthService │ GraphQL │ RouteCollection        │
└─────────────────────────────────────────────────┘
```

### Component Integration

```
┌─────────────────────────────────────────────────┐
│                 UI Layer                        │
├─────────────────┬───────────────────────────────┤
│ McpDebugOverlay │ McpScreenshotWidget           │
│ (Development)   │ (Screenshot Capture)          │
└─────────────────┬───────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────┐
│              Flutter App                        │
│            (Gh3App Widget)                      │
└─────────────────────────────────────────────────┘
```

## Core Services

### McpService (@lazySingleton)

**Purpose**: Core MCP functionality including screenshot capture and view inspection.

**Key Methods**:
- `initialize()`: Connect to MCP server and configure agent
- `takeScreenshot()`: Capture PNG screenshots with compression
- `getViewDetails()`: Extract screen dimensions and platform info
- `registerGitHubTool()`: Register custom GitHub-specific tools
- `sendMessage()`: Communicate with AI assistants

**Dependencies**: None (base service)

### McpGitHubTools (@injectable)

**Purpose**: GitHub-specific MCP tools leveraging existing GraphQL infrastructure.

**Key Methods**:
- `initialize()`: Register all GitHub tools
- `_handleRepositoryAnalysis()`: Analyze repository structure and insights
- `_handleUserProfile()`: Get user profiles with auth integration
- `_handleNavigation()`: Generate GoRouter-compatible navigation
- `_handleUIInspection()`: UI state inspection and screenshots

**Dependencies**: `McpService`, `AuthService`

### McpDevelopmentWorkflow (@injectable)

**Purpose**: Development workflow automation for build, test, and quality analysis.

**Key Methods**:
- `initialize()`: Register workflow automation tools
- `_handleBuildAnalysis()`: Analyze Flutter builds and dependencies
- `_handleTestAutomation()`: Run tests with coverage and auto-fix
- `_handleCodeQuality()`: Lint analysis and formatting
- `_handlePerformanceMonitoring()`: Monitor app performance metrics

**Dependencies**: `McpService`

## UI Components

### McpDebugOverlay

**Purpose**: Development overlay for testing MCP functionality.

**Features**:
- Floating action button toggle
- Debug panel with action buttons
- Real-time result display
- Error handling and formatting

**Integration**: Wraps the entire MaterialApp in gh3_app.dart

### McpScreenshotWidget

**Purpose**: Reusable screenshot capture widget.

**Features**:
- Loading state management
- Optional preview display
- Snackbar feedback
- Customizable icon and tooltip

**Integration**: Can be embedded in any UI component

## Data Flow

### Screenshot Capture Flow

```
1. User triggers screenshot (UI or MCP command)
2. McpScreenshotWidget calls McpService.takeScreenshot()
3. McpService captures current render view
4. Image converted to PNG with compression
5. Screenshot data returned as Uint8List
6. Success/error feedback provided to user
```

### GitHub Tool Flow

```
1. AI assistant sends GitHub operation request
2. McpGitHubTools receives and validates parameters
3. Service integrates with existing AuthService/GraphQL
4. Operation performed using established patterns
5. Structured response returned to AI assistant
6. Workflow history updated for tracking
```

### Development Workflow Flow

```
1. AI assistant requests workflow automation
2. McpDevelopmentWorkflow validates parameters
3. Appropriate handler method executed
4. Mock/real analysis performed based on environment
5. Results formatted with recommendations
6. History tracked for health monitoring
```

## Configuration

### Dependency Injection Setup

Services are registered using Injectable annotations:

```dart
@lazySingleton  // McpService - singleton for state management
@injectable     // McpGitHubTools - per-request instantiation
@injectable     // McpDevelopmentWorkflow - per-request instantiation
```

### Initialization Sequence

```dart
// In main.dart
1. configureDependencies() - Register all services
2. getIt<McpService>() - Retrieve MCP services
3. mcpService.initialize() - Connect to MCP server
4. mcpGitHubTools.initialize() - Register GitHub tools
5. App launch with MCP integration active
```

## Error Handling

### Service-Level Error Handling

- All MCP operations wrapped in try-catch blocks
- Structured error responses with timestamps
- Graceful degradation when MCP unavailable
- Debug logging for troubleshooting

### UI-Level Error Handling

- Loading states during MCP operations
- Snackbar feedback for user actions
- Debug panel error display
- Non-blocking error presentation

## Security Considerations

### Authentication Integration

- Leverages existing AuthService for GitHub operations
- No separate authentication required for MCP
- User session state checked before GitHub API calls

### Data Protection

- Screenshots handled in memory only
- Automatic cleanup of temporary files
- No sensitive data logged in debug output
- MCP server connections use configured endpoints

## Performance Optimizations

### Screenshot Optimization

- PNG compression for reduced size
- Configurable pixel ratio (default 3.0)
- Asynchronous capture to prevent UI blocking
- Automatic cleanup of old screenshots

### Service Efficiency

- Lazy singleton pattern for core service
- Injectable dependency injection for performance
- Health check monitoring (5-minute intervals)
- Workflow history limited to 50 entries

## Testing Strategy

### Service Testing

- Unit tests for all MCP service methods
- Mock MCP agent for testing
- Error condition testing
- Dependency injection testing

### UI Component Testing

- Widget tests for debug overlay
- Screenshot widget testing with mocks
- Integration tests for service interaction
- Error state testing

## Future Enhancements

### Planned Features

- Real-time widget tree inspection
- Advanced performance profiling
- Integration with existing testing framework
- Custom MCP tool registration API

### Extensibility

- Plugin architecture for custom tools
- Configurable MCP server endpoints
- Dynamic tool registration
- AI assistant compatibility expansion