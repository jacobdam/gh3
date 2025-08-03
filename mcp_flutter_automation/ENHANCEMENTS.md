# Enhancement Proposals

This document contains detailed enhancement proposals that can be implemented in future sessions.

## 🗂️ Artifacts Management System

### Problem Statement
Currently, MCP Flutter automation generates many temporary files during development:
- Screenshots: `screenshot_*.png`, `latest_screenshot.png`
- Debug outputs: `*_inspection.json`, `*_debug_*`
- Test artifacts: `test_screenshot_*`, `debug_*`
- Binary files: `mcp_flutter_automation_binary`

These files clutter `git status` and make it hard to track meaningful changes.

### Proposed Solution: Separation Folder Structure

#### Directory Structure
```
mcp_flutter_automation/
├── .artifacts/                    # Main artifacts directory (gitignored)
│   ├── screenshots/              # All screenshot outputs
│   │   ├── latest.png           # Current screenshot
│   │   ├── timestamped/         # Archived screenshots  
│   │   └── debug/               # Debug screenshots
│   ├── debug/                   # Debug outputs and logs
│   │   ├── inspections/         # Widget inspection JSON files
│   │   ├── logs/               # Debug logs
│   │   └── traces/             # Stack traces and diagnostics
│   ├── binaries/               # Compiled outputs
│   │   ├── mcp_server          # Main binary
│   │   └── test_binaries/      # Test executables
│   └── temp/                   # Temporary session files
├── src/                        # Source code (clean)
├── tests/                      # Test files (when rebuilt)
└── docs/                       # Documentation
```

#### Implementation Plan

**Phase 1: Directory Setup**
- Create `.artifacts/` directory structure
- Update `.gitignore` to exclude entire `.artifacts/` folder
- Add `.artifacts/.gitkeep` files to preserve structure

**Phase 2: Code Changes**
- Modify `FlutterController.captureScreenshot()` to save to `.artifacts/screenshots/`
- Update binary compilation to output to `.artifacts/binaries/`
- Redirect all debug outputs to `.artifacts/debug/`

**Phase 3: Developer Experience**
- Add cleanup scripts (`scripts/clean-artifacts.sh`)
- Create development commands in `package.json` equivalent
- Add artifact management to README

#### Configuration File: `.artifacts-config.yaml`
```yaml
artifacts:
  retention:
    screenshots: 30d        # Keep screenshots for 30 days
    debug_files: 7d        # Keep debug files for 7 days  
    binaries: 1d           # Keep binaries for 1 day
    temp_files: 1h         # Clean temp files hourly
  
  auto_cleanup: true       # Enable automatic cleanup
  
  paths:
    screenshots: ".artifacts/screenshots"
    debug: ".artifacts/debug"
    binaries: ".artifacts/binaries"
    temp: ".artifacts/temp"
```

#### Benefits
- **Clean Repository**: `git status` only shows meaningful changes
- **Organized Artifacts**: Easy to find screenshots, logs, debug files
- **Automatic Cleanup**: Configurable retention policies
- **Development Friendly**: Artifacts preserved during development session
- **CI/CD Ready**: Artifacts directory can be cached or archived

---

## 🧪 Test Suite Reconstruction

### Problem Statement
All test files were removed during widget inspector cleanup. Need to rebuild test coverage for the 8 working MCP tools.

### Proposed Test Structure
```
tests/
├── unit/
│   ├── flutter_controller_test.dart    # Core controller tests
│   ├── mcp_server_test.dart           # MCP protocol tests
│   └── screenshot_test.dart           # Screenshot capture tests
├── integration/
│   ├── full_workflow_test.dart        # End-to-end MCP workflows
│   └── ios_device_test.dart          # Device-specific tests
└── test_utils/
    ├── mock_flutter_app.dart         # Test utilities
    └── test_fixtures.dart            # Test data
```

### Test Priorities
1. **High**: MCP server protocol compliance
2. **High**: Screenshot capture on iOS 
3. **Medium**: Flutter app lifecycle management
4. **Low**: Error handling and edge cases

---

## 🔧 Development Workflow Improvements

### Enhanced .gitignore Patterns
```gitignore
# Current patterns
.claude/
mcp_flutter_automation_binary

# Proposed additions
.artifacts/
screenshot_*.png
*_inspection.json
*_debug_*
*.log
latest_screenshot.png
debug_*
test_screenshot_*
*_test_output/
*.tmp
temp_*
```

### Development Scripts
- `scripts/setup-dev.sh` - Initialize development environment
- `scripts/clean-all.sh` - Clean artifacts and reset workspace  
- `scripts/test-mcp.sh` - Quick MCP server testing
- `scripts/build-release.sh` - Build production binaries

---

## 📱 Platform Support Expansion

### Current Status
- **iPhone (iOS)**: ✅ Fully functional
- **Chrome (Web)**: ⚠️ Limited (connection timeouts)
- **Android**: 🔲 Not tested
- **Desktop**: 🔲 Not tested

### Enhancement Plan
1. **Phase 1**: Stabilize Android support
2. **Phase 2**: Improve web platform reliability  
3. **Phase 3**: Add desktop platform support (macOS/Windows/Linux)

---

**Implementation Priority**: 
1. 🗂️ Artifacts Management System (addresses immediate pain point)
2. 🧪 Test Suite Reconstruction (technical debt)
3. 🔧 Development Workflow Improvements (developer experience)
4. 📱 Platform Support Expansion (feature growth)

**Next Session**: Focus on implementing artifacts management system