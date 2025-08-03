# Agent Workflow Guide

## Purpose
This guide provides detailed instructions for code agents (Claude) working on the MCP Development Proxy project. It ensures consistency, scalability, and high-quality outputs across all agent sessions.

## Session Startup Protocol (MANDATORY)

### 1. Health Check (30 seconds)
```bash
# Run the project health check script
.dev-tracking/scripts/health-check.sh
```

### 2. Context Review (2 minutes)
```bash
# Read current project state
cat .dev-tracking/tasks/current-sprint.md
cat .dev-tracking/sessions/latest-handoff.md
git status
```

### 3. Improvement Analysis (3 minutes)
Analyze the codebase and identify 1-3 improvements:

**System Improvements:**
- Performance bottlenecks (profiling, caching, algorithms)
- Architecture issues (coupling, cohesion, dependencies)
- Technical debt (deprecated patterns, outdated libraries)
- Resource management (memory leaks, file handles)

**Design Improvements:**
- Component extraction opportunities (large files >200 lines)
- SOLID principle violations (SRP, OCP, DIP violations)
- Code duplication and reusability
- Interface design and abstractions

**Process Improvements:**
- Documentation gaps (missing docs, outdated instructions)
- Workflow inefficiencies (manual steps, repetitive tasks)
- Missing tooling (scripts, automation, validation)
- Development experience (setup, debugging, testing)

### 4. Session Planning (TodoWrite)
Create a focused session plan:
- Select 1 primary focus (task or improvement)
- Break work into 10-15 minute chunks
- Include verification and testing steps
- Plan session handoff documentation

## Work Estimation Guidelines

**Simple Fixes (5-10 minutes):**
- Typo corrections, comment updates
- Simple refactoring (rename, extract method)
- Configuration changes
- Documentation updates

**Component Work (15-30 minutes):**
- Extract class from large file
- Implement small feature
- Write comprehensive tests
- Add error handling

**Feature Implementation (30-60 minutes):**
- New component with full testing
- Complex refactoring across multiple files
- Integration between components
- Performance optimizations

**System Changes (1-2 hours - rare):**
- Architecture modifications
- Major API changes
- Cross-cutting concerns
- Complex debugging

## Quality Standards

### Code Quality
- Follow existing code style and patterns
- Maintain >90% test coverage for new code
- All tests must pass before committing
- Run `dart analyze --fatal-infos --fatal-warnings`
- Format code with `dart format .`

### Documentation Quality
- Update relevant documentation files
- Add code comments only when necessary
- Keep CLAUDE.md instructions current
- Document architectural decisions

### Process Quality
- Use TodoWrite for all session work
- Commit frequently (every 10-15 minutes)
- Update sprint tracking for completed tasks
- Create detailed handoff notes

## Common Patterns

### Component Extraction
```dart
// Before: Large class with multiple responsibilities
class MCPDevProxy {
  // 300+ lines mixing concerns
}

// After: Extracted components
class MCPDevProxy {
  final TimeoutManager _timeoutManager;
  final ResponseEnhancer _responseEnhancer;
  final RequestRouter _requestRouter;
}
```

### Test-Driven Development
```dart
// 1. Write failing test
test('should timeout after configured duration', () {
  // Arrange, Act, Assert
});

// 2. Implement minimal code to pass
class TimeoutManager {
  Duration getTimeout(String method) => Duration(seconds: 30);
}

// 3. Refactor and improve
```

### Error Handling
```dart
// Structured error responses
Map<String, dynamic> createErrorResponse(dynamic error) {
  return {
    'jsonrpc': '2.0',
    'error': {
      'code': ErrorClassifier.getCode(error),
      'message': ErrorClassifier.getMessage(error),
      'data': {
        'proxy_metadata': {
          'error_type': error.runtimeType.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        }
      }
    }
  };
}
```

## Session Handoff Requirements

### What to Include
- **Work Completed**: Specific features, fixes, or improvements implemented
- **Current State**: Branch status, uncommitted changes, test results
- **Next Steps**: Clear priority actions for next agent session
- **Blockers**: Any issues encountered that need resolution
- **Learning**: Insights about codebase, patterns, or improvements identified

### Handoff Template
```markdown
# Session Handoff: [Date] - [Focus Area]

## Completed This Session
- ✅ [Specific achievement 1]
- ✅ [Specific achievement 2]

## Current State  
- Branch: [current-branch]
- Tests: [passing/failing status]
- Uncommitted: [none/list files]

## Next Session Priority
1. [Highest priority item]
2. [Secondary priority]
3. [Optional improvement]

## Notes
- [Key insights or decisions]
- [Any blockers or issues]
```

## Best Practices

### Do
- Follow the mandatory startup protocol every session
- Propose improvements proactively
- Break work into small, manageable chunks
- Commit frequently with clear messages
- Update documentation as you work
- Leave clear handoff notes

### Don't
- Skip the health check and context review
- Work on multiple complex tasks simultaneously
- Leave uncommitted experimental code
- Skip tests or ignore test failures
- Make changes without understanding existing patterns
- End sessions without proper handoff documentation

## Troubleshooting

### Common Issues
- **Missing task definition**: Create it following existing patterns
- **Test failures**: Fix before proceeding with new work
- **Merge conflicts**: Resolve immediately, don't accumulate
- **Large uncommitted changes**: Commit incrementally, don't batch

### Getting Help
- Check existing documentation in `docs/` directory
- Review similar implementations in the codebase
- Run health check script for automated suggestions
- Refer to handoff notes for recent context

## Tool Integration

### TodoWrite Usage
- Always use for session planning and tracking
- Mark items in_progress when starting work
- Complete items immediately when finished
- Break complex work into smaller todos

### Git Workflow
- Create feature branches for substantial changes
- Use improvement branches for quick fixes
- Commit with descriptive messages including emoji
- Keep main branch stable and tested

This guide ensures every agent session contributes effectively to the project's goals while maintaining high quality and consistency standards.