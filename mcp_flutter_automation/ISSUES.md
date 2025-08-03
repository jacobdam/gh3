# Project Issues & Enhancement Tracking

This document tracks ongoing issues, enhancement requests, and technical debt across AI sessions.

## 🚨 Critical Issues

### 1. Uncommitted Files Management
**Status**: 🔴 Active  
**Priority**: High  
**Session**: Current  

**Problem**: 
- Large number of uncommitted screenshot files (`screenshot_*.png`)
- Test artifacts (`*_inspection.json`, `*_debug_*`)
- Binary files (`mcp_flutter_automation_binary`)
- Makes `git status` noisy and hard to track real changes

**Proposed Solution**: 
- Implement artifacts separation folder structure
- Enhanced `.gitignore` patterns
- Automated cleanup workflows

**Files**: See `ENHANCEMENTS.md` → "Artifacts Management System"

---

## ⚠️ Technical Debt

### 1. Missing Test Suite
**Status**: 🟡 Planned  
**Priority**: Medium  
**Session**: Previous cleanup removed all tests  

**Problem**:
- All test files were removed during widget inspector cleanup
- No test coverage for the 8 working MCP tools
- No integration tests for screenshot capture system

**Next Steps**:
- Rebuild test suite for working tools only
- Focus on MCP server integration tests
- Add screenshot capture validation tests

### 2. Flutter Driver Dependencies
**Status**: ✅ Resolved  
**Priority**: N/A  
**Session**: Current - removed heavy dependencies  

**Resolution**: 
- Removed Flutter Driver fallback from screenshot system
- Simplified to 2-tier approach (custom extension + direct VM)
- No additional dependencies required

---

## 🔄 Cross-Session Tracking

### Session Continuity Items
- **Artifacts folder structure** - needs implementation
- **Test suite rebuild** - needs planning and implementation  
- **Enhanced .gitignore** - needs comprehensive patterns
- **Development workflow** - needs automation scripts

### Knowledge Preservation
- **Widget Inspector Limitations**: 15-widget limit is architectural, not a bug
- **Screenshot Methods**: 2-tier system works reliably on iOS
- **VM Service Architecture**: DDS vs direct connection patterns documented
- **Working Tools**: 8 tools verified functional, 4 widget inspection tools removed

---

## 📝 Notes for Future Sessions

### Context for AI Agents
1. **DO NOT** attempt to restore widget inspection functionality
2. **Focus on** the 8 working MCP tools for any improvements
3. **Remember** that Flutter Driver was intentionally removed
4. **Prioritize** artifacts management before adding new features

### Human Collaboration Points
- Artifacts folder structure needs human approval on directory naming
- Test strategy should be discussed before implementation
- Git workflow changes need human review

---

**Last Updated**: 2025-01-15  
**Next Review**: When working on artifacts management