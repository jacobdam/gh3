import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../example_screens/home_screen_example.dart';
import '../example_screens/user_profile_example.dart';
import 'example_routes.dart';

/// Navigation service for the UI system example screens
class NavigationService {
  static final GoRouter router = GoRouter(
    initialLocation: ExampleRoutes.home,
    routes: [
      GoRoute(
        path: ExampleRoutes.home,
        builder: (context, state) => const HomeScreenExample(),
      ),
      GoRoute(
        path: ExampleRoutes.userProfile,
        builder: (context, state) {
          final username = state.pathParameters['username']!;
          return UserProfileExample(username: username);
        },
      ),
      GoRoute(
        path: ExampleRoutes.repository,
        builder: (context, state) {
          final owner = state.pathParameters['owner']!;
          final name = state.pathParameters['name']!;
          return _buildPlaceholderScreen('Repository: $owner/$name');
        },
      ),
      GoRoute(
        path: ExampleRoutes.repositoryTree,
        builder: (context, state) {
          final owner = state.pathParameters['owner']!;
          final name = state.pathParameters['name']!;
          return _buildPlaceholderScreen('Repository Tree: $owner/$name');
        },
      ),
      GoRoute(
        path: ExampleRoutes.repositoryFile,
        builder: (context, state) {
          final owner = state.pathParameters['owner']!;
          final name = state.pathParameters['name']!;
          return _buildPlaceholderScreen('Repository File: $owner/$name');
        },
      ),
      GoRoute(
        path: ExampleRoutes.issues,
        builder: (context, state) {
          final owner = state.pathParameters['owner']!;
          final name = state.pathParameters['name']!;
          return _buildPlaceholderScreen('Issues: $owner/$name');
        },
      ),
      GoRoute(
        path: ExampleRoutes.issueDetail,
        builder: (context, state) {
          final owner = state.pathParameters['owner']!;
          final name = state.pathParameters['name']!;
          final number = state.pathParameters['number']!;
          return _buildPlaceholderScreen('Issue #$number: $owner/$name');
        },
      ),
      GoRoute(
        path: ExampleRoutes.pulls,
        builder: (context, state) {
          final owner = state.pathParameters['owner']!;
          final name = state.pathParameters['name']!;
          return _buildPlaceholderScreen('Pull Requests: $owner/$name');
        },
      ),
      GoRoute(
        path: ExampleRoutes.pullDetail,
        builder: (context, state) {
          final owner = state.pathParameters['owner']!;
          final name = state.pathParameters['name']!;
          final number = state.pathParameters['number']!;
          return _buildPlaceholderScreen('Pull Request #$number: $owner/$name');
        },
      ),
      GoRoute(
        path: ExampleRoutes.search,
        builder: (context, state) => _buildPlaceholderScreen('Search'),
      ),
      GoRoute(
        path: ExampleRoutes.trending,
        builder: (context, state) => _buildPlaceholderScreen('Trending'),
      ),
      GoRoute(
        path: ExampleRoutes.starred,
        builder: (context, state) => _buildPlaceholderScreen('Starred'),
      ),
    ],
  );

  /// Navigation helper methods
  static void navigateToUser(String username) {
    router.go(ExampleRoutes.userProfilePath(username));
  }

  static void navigateToRepository(String owner, String name) {
    router.go(ExampleRoutes.repositoryPath(owner, name));
  }

  static void navigateToRepositoryTree(String owner, String name) {
    router.go(ExampleRoutes.repositoryTreePath(owner, name));
  }

  static void navigateToRepositoryFile(String owner, String name) {
    router.go(ExampleRoutes.repositoryFilePath(owner, name));
  }

  static void navigateToIssues(String owner, String name) {
    router.go(ExampleRoutes.issuesPath(owner, name));
  }

  static void navigateToIssue(String owner, String name, int number) {
    router.go(ExampleRoutes.issueDetailPath(owner, name, number));
  }

  static void navigateToPulls(String owner, String name) {
    router.go(ExampleRoutes.pullsPath(owner, name));
  }

  static void navigateToPull(String owner, String name, int number) {
    router.go(ExampleRoutes.pullDetailPath(owner, name, number));
  }

  static void navigateToSearch() {
    router.go(ExampleRoutes.search);
  }

  static void navigateToTrending() {
    router.go(ExampleRoutes.trending);
  }

  static void navigateToStarred() {
    router.go(ExampleRoutes.starred);
  }

  /// Build placeholder screen for routes not yet implemented
  static Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This screen is under construction',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
