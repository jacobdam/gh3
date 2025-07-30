import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:gh3/src/screens/home_screen/home_screen.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';
import 'package:gh3/src/widgets/user_card/__generated__/user_card.data.gql.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:go_router/go_router.dart';

import 'home_screen_integration_test.mocks.dart';

@GenerateMocks([HomeViewModel, AuthViewModel, GoRouter])
void main() {
  group('HomeScreen Integration', () {
    late MockHomeViewModel mockHomeViewModel;
    late MockAuthViewModel mockAuthViewModel;
    late GUserCardFragment realUserFragment;

    setUp(() {
      mockHomeViewModel = MockHomeViewModel();
      mockAuthViewModel = MockAuthViewModel();

      // Create real Ferry generated class instances instead of mocks
      realUserFragment = GUserCardFragmentData(
        (b) => b
          ..id = 'test-id'
          ..name = 'Test User'
          ..login = 'testuser'
          ..avatarUrl.value = 'https://example.com/avatar.jpg'
          ..bio = 'Test bio'
          ..repositories = (GUserCardFragmentData_repositoriesBuilder()
            ..totalCount = 10)
          ..followers = (GUserCardFragmentData_followersBuilder()
            ..totalCount = 5),
      );

      // Setup default mock behavior for new HomeViewModel
      when(mockHomeViewModel.isLoading).thenReturn(false);
      when(mockHomeViewModel.error).thenReturn(null);
      when(mockHomeViewModel.currentUser).thenReturn(realUserFragment);
    });

    testWidgets(
      'should display SliverAppBar with Home title and logout button',
      (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: HomeScreen(
                authViewModel: mockAuthViewModel,
                homeViewModel: mockHomeViewModel,
              ),
            ),
          );

          // Check SliverAppBar title
          expect(find.text('Home'), findsOneWidget);

          // Check logout button
          expect(find.byIcon(Icons.logout), findsOneWidget);
        });
      },
    );

    testWidgets('should display My profile section with user card', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: HomeScreen(
              authViewModel: mockAuthViewModel,
              homeViewModel: mockHomeViewModel,
            ),
          ),
        );

        // Check My profile section
        expect(find.text('My profile'), findsOneWidget);

        // Check user information is displayed
        expect(find.text('Test User'), findsOneWidget);
        expect(find.text('@testuser'), findsOneWidget);
      });
    });

    testWidgets('should display My work section with all work items', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: HomeScreen(
              authViewModel: mockAuthViewModel,
              homeViewModel: mockHomeViewModel,
            ),
          ),
        );

        // Check My work section
        expect(find.text('My work'), findsOneWidget);

        // Scroll to make sure all items are visible
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
        await tester.pump();

        // Check all 7 work items are displayed
        expect(find.text('Issues'), findsOneWidget);
        expect(find.text('Pull requests'), findsOneWidget);
        expect(find.text('Discussions'), findsOneWidget);
        expect(find.text('Projects'), findsOneWidget);
        expect(find.text('Repositories'), findsOneWidget);
        expect(find.text('Organizations'), findsOneWidget);
        expect(find.text('Starred'), findsOneWidget);

        // Check some key icons are displayed (not all to avoid over-testing)
        expect(find.byIcon(Icons.bug_report), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });
    });

    testWidgets('should be scrollable when content exceeds screen height', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: HomeScreen(
              authViewModel: mockAuthViewModel,
              homeViewModel: mockHomeViewModel,
            ),
          ),
        );

        // Check that CustomScrollView is present
        expect(find.byType(CustomScrollView), findsOneWidget);
        expect(find.byType(SliverAppBar), findsOneWidget);
        expect(find.byType(SliverPadding), findsOneWidget);
        expect(find.byType(SliverList), findsOneWidget);
      });
    });

    testWidgets('should handle logout button tap', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: HomeScreen(
              authViewModel: mockAuthViewModel,
              homeViewModel: mockHomeViewModel,
            ),
          ),
        );

        // Tap logout button
        await tester.tap(find.byIcon(Icons.logout));
        await tester.pump();

        // Verify logout was called
        verify(mockAuthViewModel.logout()).called(1);
      });
    });

    testWidgets('should display user card with avatar when provided', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: HomeScreen(
              authViewModel: mockAuthViewModel,
              homeViewModel: mockHomeViewModel,
            ),
          ),
        );

        // Check that CircleAvatar is displayed
        expect(find.byType(CircleAvatar), findsOneWidget);
      });
    });

    testWidgets('should navigate to user details when profile card is tapped', (
      tester,
    ) async {
      // Create a mock GoRouter (unused but kept for future navigation testing)

      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => HomeScreen(
                    authViewModel: mockAuthViewModel,
                    homeViewModel: mockHomeViewModel,
                  ),
                ),
                GoRoute(
                  path: '/:login',
                  builder: (context, state) =>
                      const Scaffold(body: Text('User Details')),
                ),
              ],
            ),
          ),
        );

        // Find and tap the user card
        final userCard = find.byType(Card).first;
        await tester.tap(userCard);
        await tester.pumpAndSettle();

        // Verify navigation occurred by checking if we're on the user details page
        expect(find.text('User Details'), findsOneWidget);
      });
    });

    testWidgets('should handle null currentUser gracefully', (tester) async {
      when(mockHomeViewModel.currentUser).thenReturn(null);

      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: HomeScreen(
              authViewModel: mockAuthViewModel,
              homeViewModel: mockHomeViewModel,
            ),
          ),
        );

        // Should display "No user data" card
        expect(find.text('No user data'), findsOneWidget);
        expect(find.text('Unable to load user information'), findsOneWidget);

        // Should handle work item taps gracefully
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
        await tester.pump();

        final repositoriesItem = find.text('Repositories');
        expect(repositoriesItem, findsOneWidget);

        await tester.tap(repositoriesItem);
        await tester.pump();

        // Should still be on home screen
        expect(find.text('Home'), findsOneWidget);
      });
    });

    testWidgets('should navigate to repositories when work item is tapped', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => HomeScreen(
                    authViewModel: mockAuthViewModel,
                    homeViewModel: mockHomeViewModel,
                  ),
                ),
                GoRoute(
                  path: '/:login/@repositories',
                  builder: (context, state) =>
                      const Scaffold(body: Text('User Repositories')),
                ),
              ],
            ),
          ),
        );

        await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
        await tester.pump();

        final repositoriesItem = find.text('Repositories');
        expect(repositoriesItem, findsOneWidget);

        await tester.tap(repositoriesItem);
        await tester.pumpAndSettle();

        expect(find.text('User Repositories'), findsOneWidget);
      });
    });
  });
}
