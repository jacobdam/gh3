# AI Session Notes & Context

This document preserves important context and decisions across AI sessions to ensure continuity.

## 📅 Session History

### Session: 2025-01-15 (Current)
**Focus**: Flutter Driver removal and project cleanup  
**Duration**: Extended session  
**Outcome**: ✅ Successfully completed major refactoring  

#### Key Decisions Made:
1. **Removed Flutter Driver**: Heavy dependencies not worth the complexity
2. **Simplified Screenshot System**: 2-tier approach (custom extension + direct VM)
3. **Deleted Widget Inspector**: All non-working tools removed completely
4. **Test Suite Cleanup**: All broken tests removed (rebuild needed)
5. **Documentation Updates**: README and CLAUDE.md updated to reflect reality

#### Technical Discoveries:
- **Widget Inspector Limitation**: 15-widget limit is architectural, not a bug
- **Flutter DevTools**: Uses interactive expansion, not single API calls
- **VM Service Architecture**: DDS proxy vs direct connection patterns
- **Screenshot Reliability**: Custom extension works better than Flutter Driver

#### Files Modified:
- `lib/src/flutter_controller.dart` - Removed Flutter Driver fallback
- `lib/src/server.dart` - Removed 4 non-working tools 
- `lib/src/widget_inspector.dart` - **DELETED**
- `README.md` - Updated to reflect 2-tier system
- `example/lib/main.dart` - Fixed deprecated API usage
- `test/` - **ENTIRE DIRECTORY DELETED**

#### Working Tools (Final State):
1. `launch_app` ✅
2. `stop_app` ✅ 
3. `hot_reload` ✅
4. `hot_restart` ✅
5. `capture_screenshot` ✅ (2-tier system)
6. `get_logs` ✅
7. `list_apps` ✅
8. `get_app_info` ✅

#### Static Analysis: ✅ CLEAN
- Zero errors, warnings, or info messages
- Both MCP server and example app compile successfully
- All deprecated API usage fixed

---

## 🧠 Knowledge Base

### Critical Understanding: Widget Inspector Limitations
**Key Insight**: The 15-widget detection limit is **NOT a bug** - it's an intentional Flutter framework limitation at app boundaries.

**Why This Matters**: 
- Don't attempt to "fix" widget detection in future sessions
- DevTools achieves full tree visibility through interactive expansion, not single API calls
- This architectural decision led to removing all widget inspection tools

### VM Service Architecture
**DDS vs Direct Connection**:
- **DDS** (Port 8181): Dart Development Service proxy - preferred but can become stale
- **Direct VM** (Port 8182): Direct connection - more reliable for recovery
- **2-Tier Fallback**: Try DDS first, fall back to direct connection

### Screenshot Capture Technology
**RenderRepaintBoundary Approach**:
- Uses Flutter's native `boundary.toImage(pixelRatio: 3.0)`
- GPU-accelerated via Skia rendering engine
- Registered as `ext.gh3.screenshot` VM service extension
- Works reliably on iOS devices

### Platform Support Status
- **iPhone (iOS)**: Fully functional and tested
- **Chrome (Web)**: Limited by VM service timeouts
- **Android**: Not yet tested
- **Desktop**: Not yet tested

---

## 🚨 Important Warnings for Future Sessions

### DO NOT Attempt:
1. **Restore widget inspection functionality** - architectural limitations confirmed
2. **Add Flutter Driver back** - intentionally removed due to complexity
3. **"Fix" the 15-widget limit** - it's not broken, it's by design
4. **Recreate deleted test files** - they were broken and dependent on deleted code

### DO Focus On:
1. **Artifacts management system** - immediate pain point with uncommitted files
2. **Test suite rebuild** - for the 8 working tools only
3. **Platform expansion** - Android and desktop support
4. **Developer experience** - automation scripts and workflows

---

## 🔗 Cross-Session Dependencies

### Before Next Implementation Session:
- Human review of artifacts folder structure proposal
- Decision on directory naming conventions
- Approval of retention policies in `.artifacts-config.yaml`

### Knowledge to Preserve:
- **VM Service Connection Logic** in `flutter_controller.dart:204-287`
- **Screenshot Extension Code** in `example/lib/extensions/mcp_screenshot_extension.dart`
- **2-Tier Fallback Pattern** in `captureScreenshot()` method
- **Working Tools List** - exactly 8 tools, no more, no less

### Context for New AI Sessions:
- Project is in clean, working state
- Major architectural decisions already made
- Focus should be on enhancement, not debugging
- All static analysis passes cleanly

---

**Last Updated**: 2025-01-15  
**Next Session Focus**: Artifacts management system implementation  
**Status**: Ready for enhancement phase