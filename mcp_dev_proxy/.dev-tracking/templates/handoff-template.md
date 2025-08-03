# Session Handoff: [DATE]-[SESSION]

## Task: TASK-XXX - [Task Title]

### Session Duration
- Start: [Time]
- End: [Time]
- Total: [X hours]

### Pre-Handoff Cleanup
```bash
# Review uncommitted files
git status

# Clean up temporary files
rm -f *.tmp *.log *.bak

# Ensure all changes are committed
git add -A
git commit -m "chore: session cleanup and handoff preparation"
```

### Completed
<!-- What was fully completed in this session -->
- ✅ 
- ✅ 

### In Progress
<!-- What was started but not completed -->
- 🔄 
- 🔄 

### Blocked/Issues
<!-- Any blockers encountered -->
- ⚠️ 

### Code Changes
<!-- Key files modified/created -->
- Created: 
- Modified: 
- Deleted: 

### Test Status
```bash
# Last test run results
dart test: [PASS/FAIL]
dart analyze: [PASS/FAIL]
Coverage: XX%
```

### Important Discoveries
<!-- Any important findings, edge cases, or decisions made -->
- 
- 

### Next Steps
<!-- Specific next actions for the next session -->
1. 
2. 
3. 

### Branch Status
- Branch: feature/[task-id]-description
- Last commit: [hash] "[message]"
- Ready for PR: [YES/NO]

### Time Estimate
- Remaining work: [X hours]
- Blockers to resolve: [X hours]

### Notes for Next Session
<!-- Any context that would help the next agent -->