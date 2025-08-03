# Project TODO & Next Actions

This document tracks actionable items for future development sessions.

## 🔥 High Priority (Next Session)

### 1. Artifacts Management System
**Status**: 📋 Ready for Implementation  
**Estimated Effort**: 2-3 hours  
**Dependencies**: Human approval on folder structure  

**Implementation Steps**:
- [ ] Create `.artifacts/` directory structure with subdirectories
- [ ] Update `.gitignore` to exclude `.artifacts/` completely  
- [ ] Modify `FlutterController.captureScreenshot()` to save to `.artifacts/screenshots/`
- [ ] Update binary compilation paths to `.artifacts/binaries/`
- [ ] Create `.artifacts-config.yaml` with retention policies
- [ ] Add cleanup scripts in `scripts/` directory
- [ ] Update README with artifacts management documentation

**Files to Modify**:
- `.gitignore`
- `lib/src/flutter_controller.dart`
- `README.md`
- Create: `.artifacts-config.yaml`, `scripts/clean-artifacts.sh`

---

## 🧪 Medium Priority

### 2. Test Suite Reconstruction  
**Status**: 📋 Planned  
**Estimated Effort**: 4-6 hours  
**Dependencies**: Artifacts system (for test outputs)

**Implementation Steps**:
- [ ] Create `tests/` directory structure
- [ ] Implement unit tests for `FlutterController`
- [ ] Add MCP server protocol compliance tests
- [ ] Create screenshot capture validation tests
- [ ] Add integration tests for full MCP workflows
- [ ] Set up test utilities and fixtures

**Focus Areas**:
- MCP tool functionality (8 working tools)
- Screenshot capture reliability
- Flutter app lifecycle management
- Error handling and edge cases

### 3. Development Workflow Improvements
**Status**: 📋 Planned  
**Estimated Effort**: 2-3 hours  
**Dependencies**: None

**Implementation Steps**:
- [ ] Create development setup scripts
- [ ] Add automation commands for common tasks
- [ ] Enhance documentation for contributors
- [ ] Set up pre-commit hooks for artifact cleanup

---

## 🚀 Future Enhancements

### 4. Platform Support Expansion
**Status**: 📋 Future  
**Estimated Effort**: 6-8 hours per platform  
**Dependencies**: Stable artifacts system and test suite

**Platforms to Add**:
- [ ] Android device support (high priority)
- [ ] Desktop support (macOS/Windows/Linux)
- [ ] Web platform reliability improvements

### 5. Advanced Features
**Status**: 📋 Someday  
**Estimated Effort**: Variable  

**Potential Features**:
- [ ] Multiple device management
- [ ] Screenshot comparison tools
- [ ] Automated UI testing workflows
- [ ] Performance monitoring integration

---

## ✅ Completed (Current Session)

### Major Refactoring (2025-01-15)
- [x] Remove Flutter Driver dependencies
- [x] Simplify screenshot system to 2-tier approach
- [x] Delete widget inspector functionality (architectural limitations)
- [x] Clean up broken test files
- [x] Fix deprecated API usage
- [x] Update documentation to reflect current state
- [x] Ensure static analysis passes cleanly
- [x] Verify 8 working tools functionality

---

## 🎯 Success Criteria

### For Artifacts Management:
- [ ] `git status` shows only meaningful changes
- [ ] Screenshots automatically saved to organized structure
- [ ] Automatic cleanup of old artifacts
- [ ] Clear documentation for developers

### For Test Suite:
- [ ] All 8 MCP tools have test coverage
- [ ] Screenshot capture validated on iOS
- [ ] Integration tests for full workflows
- [ ] CI/CD ready test suite

### For Development Workflow:
- [ ] One-command setup for new developers
- [ ] Automated artifact management
- [ ] Clear contributor guidelines
- [ ] Streamlined development experience

---

## 📝 Notes

### Before Starting Next Session:
1. **Review** this TODO with human for priorities
2. **Confirm** artifacts folder structure proposal
3. **Decide** on retention policies and cleanup automation
4. **Ensure** development environment is ready

### Context Preservation:
- All architectural decisions documented in `SESSION_NOTES.md`
- Technical details preserved in `ENHANCEMENTS.md`
- Cross-session issues tracked in `ISSUES.md`

**Next Action**: Implement artifacts management system per `ENHANCEMENTS.md` specification

**Last Updated**: 2025-01-15