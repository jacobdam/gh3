import 'package:flutter/material.dart';
import 'package:gh3/src/init.dart';
// ...existing imports...
import 'package:go_router/go_router.dart';
import 'package:gh3/src/screens/home_screen.dart';
import 'package:gh3/src/screens/login_screen.dart';
import 'package:gh3/src/screens/loading_screen.dart';
import 'package:gh3/src/viewmodels/auth_viewmodel.dart';
import 'package:gh3/src/viewmodels/login_viewmodel.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/services/github_auth_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  // Get services from dependency injection
  final authService = getIt<AuthService>();
  final githubAuthClient = getIt<GithubAuthClient>();

  // Create ViewModels manually with their dependencies
  final authVM = AuthViewModel(authService);
  await authVM.init();

  runApp(
    MyApp(
      authViewModel: authVM,
      authService: authService,
      githubAuthClient: githubAuthClient,
    ),
  );
}

// Removed top-level router; instantiate inside MyApp

/// Main app widget using GoRouter
class MyApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final AuthService authService;
  final GithubAuthClient githubAuthClient;

  const MyApp({
    super.key,
    required this.authViewModel,
    required this.authService,
    required this.githubAuthClient,
  });

  @override
  Widget build(BuildContext context) {
    // Configure GoRouter
    final router = GoRouter(
      refreshListenable: authViewModel,
      initialLocation: '/loading',
      routes: [
        GoRoute(
          path: '/loading',
          builder: (context, state) => const LoadingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(
            viewModel: LoginViewModel(
              githubAuthClient,
              authService,
              authViewModel,
            ),
          ),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => HomeScreen(authViewModel: authViewModel),
        ),
      ],
      redirect: (context, state) {
        if (authViewModel.loading) {
          return '/loading';
        }
        final loc = state.uri.path;
        if (!authViewModel.loggedIn && loc != '/login') {
          return '/login';
        }
        if (authViewModel.loggedIn && (loc == '/login' || loc == '/loading')) {
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
