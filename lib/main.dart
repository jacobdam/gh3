import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gh3/src/init.dart';
import 'package:gh3/src/screens/app/gh3_app.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/github_api_service.dart';

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
    Gh3App(
      authViewModel: authVM,
      authService: authService,
      githubAuthClient: githubAuthClient,
      githubApiService: githubApiService,
      homeViewModel: homeViewModel,
    ),
  );
}

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
    return Gh3App(
      authViewModel: authViewModel,
      authService: authService,
      githubAuthClient: githubAuthClient,
      githubApiService: githubApiService,
      homeViewModel: homeViewModel,
    );
  }
}
