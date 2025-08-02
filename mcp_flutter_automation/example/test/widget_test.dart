// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mcp_flutter_example/main.dart';

void main() {
  testWidgets('Text toggle test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final GlobalKey repaintBoundaryKey = GlobalKey();
    await tester.pumpWidget(MCPFlutterExample(repaintBoundaryKey: repaintBoundaryKey));

    // Verify that our text starts with 'Hello MCP!'.
    expect(find.text('Hello MCP!'), findsOneWidget);
    expect(find.text('Text Toggled!'), findsNothing);

    // Tap the 'Toggle Text' button and trigger a frame.
    await tester.tap(find.text('Toggle Text'));
    await tester.pump();

    // Verify that our text has toggled.
    expect(find.text('Hello MCP!'), findsNothing);
    expect(find.text('Text Toggled!'), findsOneWidget);
  });
}
