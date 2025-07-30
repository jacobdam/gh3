import 'package:flutter/material.dart';
import '../theme/gh_theme.dart';
import 'navigation_service.dart';

/// Main UI System demo application
class UISystemApp extends StatefulWidget {
  const UISystemApp({super.key});

  @override
  State<UISystemApp> createState() => _UISystemAppState();
}

class _UISystemAppState extends State<UISystemApp> {
  final ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GitHub UI System Demo - Phase 4',
      theme: GHTheme.lightTheme(),
      darkTheme: GHTheme.darkTheme(),
      themeMode: _themeMode,
      routerConfig: NavigationService.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
