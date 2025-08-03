# Development Tracking

This directory contains project management artifacts for the MCP Development Proxy implementation.

## Directory Structure

```
dev-tracking/
├── tasks/
│   ├── current-sprint.md      # Active sprint task tracking
│   └── definitions/           # Detailed task definitions
│       └── TASK-XXX.md
├── sessions/
│   └── [date]-[session]-handoff.md  # Session handoff notes
├── issues/
│   └── ISSUE-XXX.md          # Bug reports and issues
└── templates/
    ├── pr-template.md         # Pull request template
    └── handoff-template.md    # Session handoff template
```

## Workflow

### For Claude Code Agents

1. **Start Session**: Check `current-sprint.md` and latest handoff
2. **Pick Task**: Select from "Ready for Development" or continue "In Progress"
3. **Work**: Follow task definition, make regular commits
4. **Update**: Keep sprint tracking current with progress
5. **Handoff**: Create detailed handoff note before ending

### Task States

- **Ready for Development**: Available to start
- **In Progress**: Currently being worked on
- **Blocked**: Waiting on dependencies
- **Completed**: Done and merged

### Best Practices

- One task per session for clear focus
- Update status immediately when starting/stopping
- Create comprehensive handoff notes
- Reference task IDs in all commits
- Keep sprint tracking accurate

## Quick Links

- [Current Sprint](./tasks/current-sprint.md)
- [PR Template](./templates/pr-template.md)
- [Handoff Template](./templates/handoff-template.md)