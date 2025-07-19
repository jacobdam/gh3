import 'package:flutter/material.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';
import 'package:gh3/src/screens/home_screen/home_screen.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart';
import 'package:gh3/src/screens/loading_screen/loading_screen.dart';
import 'package:gh3/src/screens/login_screen/login_screen.dart';
import 'package:gh3/src/screens/login_screen/login_viewmodel.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/services/github_api_service.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:go_router/go_router.dart';

class Gh3App extends StatelessWidget {
  final AuthViewModel authViewModel;
  final AuthService authService;
  final GithubAuthClient githubAuthClient;
  final GitHubApiService githubApiService;
  final HomeViewModel homeViewModel;

  const Gh3App({
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
          builder: (context, state) =>
              LoadingScreen(authViewModel: authViewModel),
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
