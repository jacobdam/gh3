# MCP Flutter Example (macOS)

A simple macOS Flutter app demonstrating integration with the MCP (Model Context Protocol) Flutter automation server.

## Features

- **MCP Screenshot Extension**: Registers `ext.gh3.screenshot` for automated screenshot capture
- **VM Service Integration**: Compatible with the MCP server's widget inspection capabilities
- **Simple UI**: Basic text and button to demonstrate state changes and UI interactions

## What This App Does

This minimal example app shows:
1. A text that toggles between "Hello MCP!" and "Text Toggled!"
2. A button that triggers the text change
3. MCP extensions registered for automation and testing

## Integration with MCP Server

### Key Components

1. **MCPScreenshotExtension** (`lib/extensions/mcp_screenshot_extension.dart`)
   - Registers `ext.gh3.screenshot` extension for VM service
   - Registers `ext.gh3.test` extension for connectivity testing
   - Handles screenshot capture via `RenderRepaintBoundary`

2. **MCPRepaintBoundary** 
   - Wraps the entire app in a `RepaintBoundary` for reliable screenshot capture
   - Provides a global key for the MCP server to reference

### Extensions Registered

- `ext.gh3.screenshot` - Captures app screenshots as base64 PNG
- `ext.gh3.test` - Simple connectivity test extension

## Requirements

- **macOS**: macOS 10.14 or later
- **Flutter**: Flutter 3.24.0 or later with macOS desktop support enabled
- **Xcode**: Latest version for macOS development

## Running the App

1. **Enable macOS desktop support** (if not already enabled):
   ```bash
   flutter config --enable-macos-desktop
   ```

2. **Install dependencies**:
   ```bash
   cd example
   flutter pub get
   ```

3. **Run the app on macOS**:
   ```bash
   flutter run -d macos --debug --host-vmservice-port=8182 --dds-port=8181 --enable-vm-service --disable-service-auth-codes
   ```

4. **Connect with MCP Server**:
   The MCP server can now connect to this app using the VM service ports and call the registered extensions.

## MCP Server Integration

To use this app with the MCP Flutter automation server:

```dart
// Launch the macOS app via MCP server
await flutterController.launchApp(
  appId: 'simple_example',
  projectPath: '/path/to/mcp_flutter_automation/example',
  deviceId: 'macos', // Specify macOS target
  vmServicePort: 8182,
  ddsPort: 8181,
);

// Capture screenshot
final screenshot = await flutterController.captureScreenshot('simple_example');

// Get widget tree
final widgetTree = await flutterController.getWidgetTree('simple_example');
```

## Project Structure

```
example/
├── lib/
│   ├── main.dart                           # Main app entry point
│   └── extensions/
│       └── mcp_screenshot_extension.dart   # MCP VM service extensions
├── macos/                                 # macOS platform files
├── pubspec.yaml                           # Dependencies (macOS only)
└── README.md                              # This file
```

## Key Features for MCP Integration

1. **Proper VM Service Setup**: App runs with VM service enabled and accessible
2. **Screenshot Capability**: Custom extension provides reliable screenshot capture
3. **Widget Tree Access**: Flutter's built-in inspector extensions available
4. **State Management**: Simple state changes for testing automation scenarios
5. **RepaintBoundary**: Ensures consistent screenshot capture boundaries

This macOS example serves as a foundation for building more complex Flutter desktop apps that integrate with MCP automation workflows. Support for other platforms (iOS, Android, Web, Windows, Linux) can be added later as needed.