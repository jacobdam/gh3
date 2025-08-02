# MCP Flutter Automation Development

## Project Context
This is an MCP server for Flutter automation, designed for AI code agents to interact with Flutter apps through automated testing, widget inspection, and screenshot analysis.

## Important Documents
- `README.md` - Complete feature documentation and tool reference
- `lib/src/flutter_controller.dart` - Core app lifecycle management
- `lib/src/widget_inspector.dart` - Widget boundary detection and analysis
- `.mcp.json` - MCP development proxy configuration

## Bash Commands
- `dart format .` - Format all Dart code
- `flutter analyze --fatal-infos --fatal-warnings` - Static analysis (must pass)
- `flutter test` - Run all tests
- `flutter pub get` - Install dependencies

## Code Style
- Follow existing Dart/Flutter conventions
- Use proper async/await patterns for VM service calls
- Add comprehensive error handling for MCP tool methods
- Include detailed logging for debugging

## Development Setup
- Uses MCP development proxy (`mcp_dev_proxy`) for crash recovery and enhanced logging
- Primary testing platform: iPhone (iOS) - most stable
- Web platform has known limitations with widget inspector

## Workflow
- Always run static analysis before committing changes
- Test with example Flutter app for widget inspection workflows
- Focus on widget boundary detection and coordinate mapping issues
- Use MCP tools discovery at start of each session