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

### Agent Session Startup (MANDATORY - 5 minutes)

**Every new code agent session MUST follow this protocol for consistency and scalability:**

1. **Project Health Assessment** (2 minutes)
   ```bash
   # Check current status
   cat .dev-tracking/tasks/current-sprint.md
   cat .dev-tracking/sessions/latest-handoff.md  
   git status
   ```

2. **Improvement Analysis** (3 minutes)
   Analyze codebase and propose 1-3 improvements from these categories:
   - **System**: Performance bottlenecks, architecture issues, technical debt
   - **Design**: Component extraction opportunities, SOLID principle violations  
   - **Process**: Documentation gaps, workflow inefficiencies, missing tooling

3. **Session Planning** (TodoWrite)
   Create todos for selected focus:
   - Task from backlog OR improvement work
   - Break work into 10-15 minute chunks
   - Include verification and handoff steps

### Task Selection Priority
   - Continue "In Progress" tasks first
   - Address critical system/design issues
   - Pick from "Ready for Development" queue
   - **MANDATORY**: Check task definition in `.dev-tracking/tasks/definitions/TASK-XXX.md`
   - If task definition doesn't exist, create it before starting implementation

### Development Process
   - Create feature branch: `feature/[task-id]-description` or `improvement/[component]-[description]`
   - Follow TDD: Write tests → Implement → Refactor
   - Make regular commits with task progress (every 10-15 minutes)
   - Update task status in sprint tracking during development
   - **Check against task definition file** throughout implementation

### Task Completion Process (CRITICAL)
   - **Verify all acceptance criteria from task definition file are met**
   - **BEFORE committing feature**: Update sprint tracking to mark task as completed
   - Include task completion details (commit hash, features implemented)
   - Update any dependent tasks to show resolved dependencies
   - **Update task definition file** to mark acceptance criteria as completed
   - Commit feature implementation AND sprint tracking updates together
   - Run final tests and code analysis

### Session Handoff Protocol (MANDATORY)
   - Review all uncommitted files: `git status`
   - Clean up any temporary files or experiments
   - Ensure all meaningful changes are committed
   - Create handoff note in `.dev-tracking/sessions/[date]-[session]-handoff.md`
   - Update overall session progress in `.dev-tracking/tasks/current-sprint.md`
   - Commit all changes with clear messages
   - **Leave clear next steps** for subsequent agent sessions

### Key Implementation Details
- **Restart Fix**: `_scheduleRestart()` sends error responses to pending requests before restart to prevent hanging
- **Stdio Injection**: Constructor accepts `stdinStream`/`stdoutSink` parameters with smart defaults
- **File Watcher**: Detects binary changes and triggers automatic restart
- **Clean Code**: Follow principles outlined in `docs/technical-design.md`

### TodoWrite Workflow (MANDATORY)
- **Start Session**: Create todos for session planning and task selection
- **Task Definition Check**: Always include "Read task definition file" as first todo
- **Task Development**: Break complex tasks into smaller todo items
- **Progress Tracking**: Mark todos as in_progress when starting, completed when done
- **Definition Verification**: Include "Verify against task definition" todos throughout development
- **Acceptance Criteria**: Create todos for each acceptance criteria item
- **Sprint Updates**: Include "Update sprint tracking" as a todo for every task completion
- **Definition Updates**: Include "Update task definition file with completion status" todo
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

### Git Workflow
```bash
# Quick branch for improvements
git checkout -b improvement/[component]-[description]

# Standard commit message format
git commit -m "feat: [component] description

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Current Priority
**Phase 1 Core Infrastructure**: Extract remaining components following SRP
- TASK-003: RequestRouter class
- TASK-004: Configurable timeout system  
- TASK-005: ErrorContext classification

**System Improvements Needed**: Performance, architecture, process optimizations

See `.dev-tracking/tasks/current-sprint.md` for current status and task assignments.

## CRITICAL WORKFLOW REQUIREMENTS
⚠️ **MANDATORY PROCESS** - Failure to follow will result in project management issues:

1. **ALWAYS read task definition file BEFORE starting any implementation**
2. **Create task definition file if it doesn't exist before proceeding**
3. **Use TodoWrite tool to track all development steps and ensure nothing is missed**
4. **Verify against task definition throughout development**
5. **ALWAYS update sprint tracking BEFORE committing completed tasks**
6. **Update task definition file to mark acceptance criteria as completed**
7. **Include sprint tracking updates in the same commit as feature implementation**
8. **Mark dependent tasks as ready when dependencies are satisfied**
9. **Verify ALL acceptance criteria are met before marking tasks complete**