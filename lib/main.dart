import 'package:flutter/material.dart';
import 'package:gh3/src/init.dart';
// ...existing imports...
import 'package:go_router/go_router.dart';
import 'package:gh3/src/screens/home_screen.dart';
import 'package:gh3/src/screens/login_screen.dart';
import 'package:gh3/src/screens/loading_screen.dart';
import 'package:gh3/src/viewmodels/auth_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  // Initialize AuthViewModel to load auth state
  final authVM = getIt<AuthViewModel>();
  await authVM.init();

  runApp(MyApp(authVM: authVM));
}

// Removed top-level router; instantiate inside MyApp

/// Main app widget using GoRouter
class MyApp extends StatelessWidget {
  final AuthViewModel authVM;
  const MyApp({super.key, required this.authVM});

  @override
  Widget build(BuildContext context) {
    // Configure GoRouter
    final router = GoRouter(
      refreshListenable: authVM,
      initialLocation: '/loading',
      routes: [
        GoRoute(
          path: '/loading',
          builder: (context, state) => const LoadingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      ],
      redirect: (context, state) {
        if (authVM.loading) {
          return '/loading';
        }
        final loc = state.uri.path;
        if (!authVM.loggedIn && loc != '/login') {
          return '/login';
        }
        if (authVM.loggedIn && (loc == '/login' || loc == '/loading')) {
          return '/';
        }
        return null;
      },
    );
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      routerConfig: router,
    );
  }
}
