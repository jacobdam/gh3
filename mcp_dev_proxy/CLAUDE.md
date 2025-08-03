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

#### **Core Principles**

- Use 🚫 BLOCKING prefix for critical requirements that prevent proceeding
- Reference specific CLAUDE.md lines for rule traceability: "(MANDATORY - CLAUDE.md #[line])"
- Mark all mandatory workflow items as high priority
- Create sequential dependency structure ensuring proper workflow order

#### **Session Startup Template (MANDATORY)**

- 🚫 BLOCKING: Project Health Assessment - Check sprint status, handoff notes, git status (MANDATORY - CLAUDE.md #21-27)
- Improvement Analysis - Identify 1-3 system/design/process improvements (MANDATORY - CLAUDE.md #29-33)
- Session Planning - Create todos for selected focus with 10-15 min chunks (MANDATORY - CLAUDE.md #35-39)

#### **Task Development Template (CRITICAL)**

- 🚫 BLOCKING: Read task definition file BEFORE starting implementation (MANDATORY - CLAUDE.md #149)
- Verify task definition exists - create if missing (MANDATORY - CLAUDE.md #150)
- Break task into TodoWrite items to track all steps (MANDATORY - CLAUDE.md #151)
- Create todos for EACH acceptance criteria from task definition (MANDATORY - CLAUDE.md #157)

#### **Pre-Commit Checklist Template (CRITICAL)**

- 🚫 BLOCKING: Verify ALL acceptance criteria met from task definition (MANDATORY - CLAUDE.md #149, #157)
- 🚫 BLOCKING: Run static checks - dart analyze must show zero issues (MANDATORY - CLAUDE.md #165)
- 🚫 BLOCKING: Update sprint tracking BEFORE committing feature (MANDATORY - CLAUDE.md #153)
- Update task definition file to mark acceptance criteria completed (MANDATORY - CLAUDE.md #154)
- Run tests and code analysis - all must pass (MANDATORY - CLAUDE.md #93)
- 🚫 BLOCKING: Commit feature implementation AND sprint tracking together (MANDATORY - CLAUDE.md #155)

#### **Session Handoff Template (MANDATORY)**

- Review uncommitted files with git status (MANDATORY - CLAUDE.md #65)
- Clean up temporary files and ensure meaningful changes committed (MANDATORY - CLAUDE.md #66-67)
- Create handoff note in .dev-tracking/sessions/[date]-[session]-handoff.md (MANDATORY - CLAUDE.md #68)
- Update overall session progress in current-sprint.md (MANDATORY - CLAUDE.md #69)
- Leave clear next steps for subsequent agent sessions (MANDATORY - CLAUDE.md #71)

#### **Rule Enforcement Guidelines**

- Cannot proceed past 🚫 BLOCKING todos until completed
- All MANDATORY items must reference specific CLAUDE.md line numbers
- Mark todos in_progress when starting, completed when done
- Use TodoWrite tool to systematically prevent workflow violations

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

**Phase 1 Foundation Enhancement**: Enhance existing clean components

- TASK-004: Configurable timeout system (moved from Phase 0)
- Advanced timeout management with adaptive behavior
- Enhanced error classification with pattern recognition

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

## Quick Development Tips

- Run dart fix --apply for automate dart analyze fix
- **Dart Fix Formatting Note**: `dart fix` can cause format issues, it should run `dart format .` after that
