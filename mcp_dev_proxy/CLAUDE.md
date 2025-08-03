# MCP Development Proxy

## Project Context
Development proxy for MCP servers with crash reporting and hot-reload capabilities. This project is being implemented following a structured plan to transform it into a comprehensive AI agent development tool.

## Current Implementation Status
- ✅ Basic proxy functionality
- ✅ Process management with restart
- ✅ File watching with hot reload
- ✅ Basic timeout handling
- 🚧 Enhanced error messages (in progress)
- 📋 Tool cycle tracking (planned)
- 📋 Multi-runtime support (planned)

## Development Workflow

### Starting a New Session
1. **Check Current Status**
   ```bash
   # Review current tasks
   cat .dev-tracking/tasks/current-sprint.md
   
   # Check latest handoff notes
   cat .dev-tracking/sessions/latest-handoff.md
   
   # Verify build status
   dart test && dart analyze --fatal-infos --fatal-warnings
   ```

2. **Select a Task**
   - Continue "In Progress" tasks first
   - Pick from "Ready for Development" queue
   - Check task definition in `.dev-tracking/tasks/definitions/TASK-XXX.md`

3. **Development Process**
   - Create feature branch: `feature/[task-id]-description`
   - Follow TDD: Write tests → Implement → Refactor
   - Make regular commits with task progress
   - Update task status in sprint tracking during development

4. **Task Completion Process (CRITICAL)**
   - **BEFORE committing feature**: Update sprint tracking to mark task as completed
   - Include task completion details (commit hash, features implemented)
   - Update any dependent tasks to show resolved dependencies
   - Commit feature implementation AND sprint tracking updates together
   - Run final tests and code analysis
   - Verify all acceptance criteria are met

5. **Before Ending Session**
   - Review all uncommitted files: `git status`
   - Clean up any temporary files or experiments
   - Ensure all relevant changes are committed
   - Create handoff note in `.dev-tracking/sessions/[date]-[session]-handoff.md`
   - Update overall session progress in `.dev-tracking/tasks/current-sprint.md`
   - Commit all changes with clear messages
   - Verify no unintended files are left uncommitted

### Key Implementation Details
- **Restart Fix**: `_scheduleRestart()` sends error responses to pending requests before restart to prevent hanging
- **Stdio Injection**: Constructor accepts `stdinStream`/`stdoutSink` parameters with smart defaults
- **File Watcher**: Detects binary changes and triggers automatic restart
- **Clean Code**: Follow principles outlined in `docs/technical-design.md`

### TodoWrite Workflow (MANDATORY)
- **Start Session**: Create todos for session planning and task selection
- **Task Development**: Break complex tasks into smaller todo items
- **Progress Tracking**: Mark todos as in_progress when starting, completed when done
- **Sprint Updates**: Include "Update sprint tracking" as a todo for every task completion
- **Commit Preparation**: Use todos to ensure all steps are completed before committing
- **Session Handoff**: Create todo for session handoff documentation

### Testing Requirements
- Unit tests must achieve >90% coverage
- All tests must pass before committing
- Integration tests for end-to-end workflows
- Performance benchmarks for critical paths

### Documentation
- **Requirements**: `docs/requirements.md` - What we're building
- **Technical Design**: `docs/technical-design.md` - How it's architected
- **Implementation Plan**: `docs/implementation-plan.md` - Detailed task breakdown
- **Test Cases**: `docs/test-cases.md` - Comprehensive test scenarios
- **Agent Workflow**: `docs/agent-workflow-guide.md` - How to work on this project

## Quick Commands

### Compile Binary
```bash
dart compile exe bin/mcp_dev_proxy.dart -o mcp_dev_proxy_binary
```

### Run Tests
```bash
dart test
dart test --coverage
```

### Code Quality
```bash
dart analyze --fatal-infos --fatal-warnings
dart format .
```

### Create PR
```bash
gh pr create --title "feat: [component] description" \
  --body "$(cat .dev-tracking/templates/pr-template.md)"
```

## Current Priority
Focus on Phase 1 (Core Infrastructure) tasks:
1. TimeoutManager implementation
2. ResponseEnhancer for structured errors
3. Component extraction following SRP

See `.dev-tracking/tasks/current-sprint.md` for specific task assignments.

## CRITICAL WORKFLOW REQUIREMENTS
⚠️ **MANDATORY PROCESS** - Failure to follow will result in project management issues:

1. **ALWAYS update sprint tracking BEFORE committing completed tasks**
2. **Use TodoWrite tool to track all development steps and ensure nothing is missed**
3. **Include sprint tracking updates in the same commit as feature implementation**
4. **Mark dependent tasks as ready when dependencies are satisfied**
5. **Verify all acceptance criteria are met before marking tasks complete**