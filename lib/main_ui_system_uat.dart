import 'package:flutter/material.dart';
import 'src/ui-system/theme/gh_theme.dart';
import 'src/ui-system/examples/design_tokens_screen.dart';
import 'src/ui-system/examples/component_catalog_screen.dart';
import 'src/ui-system/examples/uat_home_screen.dart';

/// UAT-specific main entry point for design system demonstration.
///
/// This entry point is specifically designed for User Acceptance Testing
/// and stakeholder review of the design system. It provides easy access
/// to all design system components and tokens.
///
/// Usage:
/// - Web: flutter run -d chrome --target=lib/main_ui_system_uat.dart
/// - iOS: flutter run -d ios --target=lib/main_ui_system_uat.dart
/// - Android: flutter run -d android --target=lib/main_ui_system_uat.dart
void main() {
  runApp(const DesignSystemUATApp());
}

/// The main application widget for design system UAT.
///
/// This app provides a complete Material Design 3 experience with
/// GitHub theming and navigation to all design system showcase screens.
class DesignSystemUATApp extends StatefulWidget {
  const DesignSystemUATApp({super.key});

  @override
  State<DesignSystemUATApp> createState() => _DesignSystemUATAppState();
}

class _DesignSystemUATAppState extends State<DesignSystemUATApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GH3 Design System - UAT',
      debugShowCheckedModeBanner: false,
      theme: GHTheme.lightTheme(),
      darkTheme: GHTheme.darkTheme(),
      themeMode: _themeMode,
      home: UATHomeScreen(onThemeToggle: _toggleTheme),
      routes: {
        '/tokens': (context) => const DesignTokensScreen(),
        '/components': (context) => const ComponentCatalogScreen(),
      },
    );
  }
}
