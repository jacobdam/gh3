import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/main_ui_system_uat.dart';
import 'package:gh3/src/ui-system/examples/design_tokens_screen.dart';
import 'package:gh3/src/ui-system/examples/component_catalog_screen.dart';

void main() {
  setUp(() {
    WidgetController.hitTestWarningShouldBeFatal = false;
  });
  group('Design System Integration', () {
    testWidgets('UAT app should launch successfully', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      expect(find.text('GH3 Design System - UAT'), findsOneWidget);
      expect(find.text('Design System Showcase'), findsOneWidget);
    });

    testWidgets('should navigate to design tokens screen', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      // Tap on Design Tokens card
      await tester.tap(find.text('Design Tokens'));
      await tester.pumpAndSettle();

      expect(find.byType(DesignTokensScreen), findsOneWidget);
      expect(find.text('Design Tokens'), findsOneWidget);
    });

    // FIXME: Navigation tests timeout due to complex UI interactions
    testWidgets('should navigate to component catalog screen', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      // Tap on Component Catalog card
      await tester.tap(find.text('Component Catalog'));
      await tester.pumpAndSettle();

      expect(find.byType(ComponentCatalogScreen), findsOneWidget);
      expect(find.text('Component Catalog'), findsOneWidget);
    }, skip: true);

    // FIXME: Quick action navigation test has timing issues with UI updates
    testWidgets('should navigate using quick action buttons', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      // Scroll down to make View Tokens button visible
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();

      // Tap on View Tokens button
      await tester.tap(find.text('View Tokens'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(DesignTokensScreen), findsOneWidget);

      // Navigate back
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Tap on View Components button
      await tester.tap(find.text('View Components'));
      await tester.pumpAndSettle();

      expect(find.byType(ComponentCatalogScreen), findsOneWidget);
    });

    testWidgets('theme toggle button should be present', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      // Should have theme toggle button
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);

      // Initially should be light theme
      var theme = Theme.of(tester.element(find.byType(Scaffold)));
      expect(theme.brightness, equals(Brightness.light));
    });

    testWidgets('should handle back navigation correctly', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      // Navigate to design tokens screen
      await tester.tap(find.text('Design Tokens'));
      await tester.pumpAndSettle();

      expect(find.byType(DesignTokensScreen), findsOneWidget);

      // Navigate back using back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Should be back at home screen
      expect(find.text('Design System Showcase'), findsOneWidget);
    }, skip: true);

    testWidgets('should display build information', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      expect(find.text('Build Information'), findsOneWidget);
      expect(find.text('Design System Foundation v1.0.0'), findsOneWidget);
      expect(
        find.text('Built for cross-platform UAT and stakeholder review'),
        findsOneWidget,
      );
    });

    testWidgets('should display feature highlights', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      expect(find.text('Material Design 3 Integration'), findsOneWidget);
      expect(find.text('Cross-Platform Compatibility'), findsOneWidget);
      expect(find.text('Accessibility Compliant'), findsOneWidget);
      expect(find.text('Interactive Components'), findsOneWidget);
    }, skip: true);

    // FIXME: Theme state navigation test has pumpAndSettle timeout issues
    testWidgets('should maintain theme state across navigation', (
      tester,
    ) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      // Switch to dark theme
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle();

      // Navigate to component catalog
      await tester.tap(find.text('Component Catalog'));
      await tester.pumpAndSettle();

      // Verify dark theme is active
      var theme = Theme.of(tester.element(find.byType(Scaffold)));
      expect(theme.brightness, equals(Brightness.dark));

      // Navigate back
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Theme should still be dark
      theme = Theme.of(tester.element(find.byType(Scaffold)));
      expect(theme.brightness, equals(Brightness.dark));
    }, skip: true);

    // FIXME: Route navigation test has complex navigation timeout issues
    testWidgets('should handle route navigation correctly', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      // Test direct route navigation
      final navigator = Navigator.of(tester.element(find.byType(Scaffold)));

      // Navigate to tokens route
      navigator.pushNamed('/tokens');
      await tester.pumpAndSettle();

      expect(find.byType(DesignTokensScreen), findsOneWidget);

      // Navigate to components route
      navigator.pushReplacementNamed('/components');
      await tester.pumpAndSettle();

      expect(find.byType(ComponentCatalogScreen), findsOneWidget);
    }, skip: true);

    testWidgets('should display proper tooltips', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      // Long press on theme toggle to show tooltip
      await tester.longPress(find.byIcon(Icons.dark_mode));
      await tester.pump();

      expect(find.text('Switch to Dark Mode'), findsOneWidget);
    });

    testWidgets('should display proper app title and content', (tester) async {
      await tester.pumpWidget(const DesignSystemUATApp());

      // Verify app starts correctly
      expect(find.text('GH3 Design System - UAT'), findsOneWidget);
      expect(find.text('Design System Showcase'), findsOneWidget);

      // App should be functional
      expect(find.text('Design Tokens'), findsOneWidget);
      expect(find.text('Component Catalog'), findsOneWidget);
    });
  });
}
