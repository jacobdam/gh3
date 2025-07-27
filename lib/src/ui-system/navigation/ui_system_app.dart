import 'package:flutter/material.dart';
import '../theme/gh_theme.dart';
import 'navigation_service.dart';

/// Main UI System demo application
class UISystemApp extends StatelessWidget {
  const UISystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GitHub UI System Demo',
      theme: GHTheme.lightTheme(),
      darkTheme: GHTheme.darkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: NavigationService.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
