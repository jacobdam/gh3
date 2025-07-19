import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gh3/src/init.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart';
// ...existing imports...
import 'package:go_router/go_router.dart';
import 'package:gh3/src/screens/home_screen/home_screen.dart';
import 'package:gh3/src/screens/login_screen/login_screen.dart';
import 'package:gh3/src/screens/loading_screen/loading_screen.dart';
import 'package:gh3/src/screens/repository_details_screen.dart';
import 'package:gh3/src/screens/user_details_screen.dart';
import 'package:gh3/src/viewmodels/auth_viewmodel.dart';
import 'package:gh3/src/screens/login_screen/login_viewmodel.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/github_api_service.dart';
import 'package:gh3/src/viewmodels/user_details_viewmodel.dart';
import 'package:gh3/src/viewmodels/repository_details_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  // Get services from dependency injection
  final authService = getIt<AuthService>();
  final githubAuthClient = getIt<GithubAuthClient>();
  final githubApiService = getIt<GitHubApiService>();
  final homeViewModel = await GetIt.instance.getAsync<HomeViewModel>();

  // Create ViewModels manually with their dependencies
  final authVM = AuthViewModel(authService);
  await authVM.init();

  runApp(
    MyApp(
      authViewModel: authVM,
      authService: authService,
      githubAuthClient: githubAuthClient,
      githubApiService: githubApiService,
      homeViewModel: homeViewModel,
    ),
  );
}

// Removed top-level router; instantiate inside MyApp

/// Main app widget using GoRouter
class MyApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final AuthService authService;
  final GithubAuthClient githubAuthClient;
  final GitHubApiService githubApiService;
  final HomeViewModel homeViewModel;

  const MyApp({
    super.key,
    required this.authViewModel,
    required this.authService,
    required this.githubAuthClient,
    required this.githubApiService,
    required this.homeViewModel,
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
          builder: (context, state) => LoadingScreen(
            authViewModel: authViewModel,
          ),
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
          builder: (context, state) => HomeScreen(
            authViewModel: authViewModel,
            homeViewModel: homeViewModel,
          ),
        ),
        GoRoute(
          path: '/:login/:repo',
          builder: (context, state) {
            final login = state.pathParameters['login']!;
            final repo = state.pathParameters['repo']!;
            return RepositoryDetailsScreen(
              login: login,
              repo: repo,
              viewModel: RepositoryDetailsViewModel(
                githubApiService,
                login,
                repo,
              ),
            );
          },
        ),
        GoRoute(
          path: '/:login',
          builder: (context, state) {
            final login = state.pathParameters['login']!;
            return UserDetailsScreen(
              login: login,
              viewModel: UserDetailsViewModel(githubApiService, login),
            );
          },
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
