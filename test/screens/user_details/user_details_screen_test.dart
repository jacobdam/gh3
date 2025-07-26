import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:gh3/src/screens/user_details/user_details_screen.dart';
import 'package:gh3/src/screens/user_details/user_details_viewmodel.dart';
import 'package:gh3/src/screens/user_details/__generated__/user_details_viewmodel.data.gql.dart';
import 'package:gh3/src/widgets/user_status_card/user_status_card.dart';
import 'package:gh3/src/widgets/skeleton_loading/skeleton_loading.dart';

import 'user_details_screen_test.mocks.dart';

@GenerateMocks([UserDetailsViewModel])
void main() {
  group('UserDetailsScreen', () {
    late MockUserDetailsViewModel mockUserDetailsViewModel;

    setUp(() {
      mockUserDetailsViewModel = MockUserDetailsViewModel();
      // Basic setup that all tests need
      when(mockUserDetailsViewModel.login).thenReturn('testuser');
      when(mockUserDetailsViewModel.isLoading).thenReturn(false);
      when(mockUserDetailsViewModel.error).thenReturn(null);
      when(mockUserDetailsViewModel.user).thenReturn(null);
      when(mockUserDetailsViewModel.isUserNotFoundError).thenReturn(false);
      when(mockUserDetailsViewModel.isNetworkError).thenReturn(false);
      when(mockUserDetailsViewModel.isAuthError).thenReturn(false);
      when(mockUserDetailsViewModel.statusMessage).thenReturn(null);
      when(mockUserDetailsViewModel.statusEmoji).thenReturn(null);
      when(mockUserDetailsViewModel.repositoriesCount).thenReturn(0);
      when(mockUserDetailsViewModel.starredRepositoriesCount).thenReturn(0);
      when(mockUserDetailsViewModel.organizationsCount).thenReturn(0);
      when(mockUserDetailsViewModel.isUserLoading).thenReturn(false);
    });

    testWidgets('shows skeleton loading screen when loading', (
      WidgetTester tester,
    ) async {
      when(mockUserDetailsViewModel.isLoading).thenReturn(true);
      when(mockUserDetailsViewModel.error).thenReturn(null);
      when(mockUserDetailsViewModel.user).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      // Verify skeleton loading structure
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.byType(SkeletonLoading), findsAtLeast(1));
      expect(find.byType(BackButton), findsOneWidget);

      // Verify specific skeleton components
      expect(find.text('Repositories'), findsOneWidget);
      expect(find.text('Starred'), findsOneWidget);
      expect(find.text('Organizations'), findsOneWidget);
    });

    group('Error Handling', () {
      testWidgets('shows user not found error', (WidgetTester tester) async {
        when(mockUserDetailsViewModel.isLoading).thenReturn(false);
        when(mockUserDetailsViewModel.error).thenReturn('User not found');
        when(mockUserDetailsViewModel.user).thenReturn(null);
        when(mockUserDetailsViewModel.isUserNotFoundError).thenReturn(true);
        when(mockUserDetailsViewModel.isNetworkError).thenReturn(false);
        when(mockUserDetailsViewModel.isAuthError).thenReturn(false);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.text('User Not Found'), findsAtLeast(1));
        expect(
          find.text(
            'The user "@testuser" does not exist or may have been deleted.',
          ),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.person_off), findsOneWidget);
        expect(find.text('Go Back'), findsOneWidget);
        // Should not show retry button for user not found
        expect(find.text('Try Again'), findsNothing);
      });

      testWidgets('shows network error with retry option', (
        WidgetTester tester,
      ) async {
        when(mockUserDetailsViewModel.isLoading).thenReturn(false);
        when(mockUserDetailsViewModel.error).thenReturn('Network error');
        when(mockUserDetailsViewModel.isNetworkError).thenReturn(true);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.text('Connection Problem'), findsAtLeast(1));
        expect(
          find.text('Please check your internet connection and try again.'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
        expect(find.text('Go Back'), findsOneWidget);
      });

      testWidgets('shows auth error', (WidgetTester tester) async {
        when(mockUserDetailsViewModel.isLoading).thenReturn(false);
        when(mockUserDetailsViewModel.error).thenReturn('Authentication error');
        when(mockUserDetailsViewModel.isAuthError).thenReturn(true);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.text('Access Denied'), findsAtLeast(1));
        expect(
          find.text('You don\'t have permission to view this user\'s profile.'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.lock), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
      });

      testWidgets('shows generic error', (WidgetTester tester) async {
        when(mockUserDetailsViewModel.isLoading).thenReturn(false);
        when(mockUserDetailsViewModel.error).thenReturn('Something went wrong');

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.text('Something Went Wrong'), findsAtLeast(1));
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
      });

      testWidgets('retry button calls refresh on viewModel', (
        WidgetTester tester,
      ) async {
        when(mockUserDetailsViewModel.isLoading).thenReturn(false);
        when(mockUserDetailsViewModel.error).thenReturn('Network error');
        when(mockUserDetailsViewModel.isNetworkError).thenReturn(true);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        await tester.tap(find.text('Try Again'));
        verify(mockUserDetailsViewModel.refresh()).called(1);
      });
    });

    testWidgets('shows user not found when user is null', (
      WidgetTester tester,
    ) async {
      when(mockUserDetailsViewModel.isLoading).thenReturn(false);
      when(mockUserDetailsViewModel.error).thenReturn(null);
      when(mockUserDetailsViewModel.user).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      expect(find.text('User not found'), findsAtLeast(1));
    });

    testWidgets('renders CustomScrollView with SliverAppBar structure', (
      WidgetTester tester,
    ) async {
      when(mockUserDetailsViewModel.isLoading).thenReturn(false);
      when(mockUserDetailsViewModel.error).thenReturn(null);
      when(mockUserDetailsViewModel.login).thenReturn('testuser');

      // Create user object using builder pattern
      final mockUser = GGetUserDetailsData_user(
        (b) => b
          ..G__typename = 'User'
          ..id = 'test-id'
          ..login = 'testuser'
          ..name = 'Test User'
          ..email = 'test@example.com'
          ..bio = 'Test bio'
          ..location = 'Test Location'
          ..company = 'Test Company'
          ..avatarUrl.value = ''
          ..url.value = 'https://github.com/testuser'
          ..repositories.G__typename = 'RepositoryConnection'
          ..repositories.totalCount = 42
          ..followers.G__typename = 'FollowerConnection'
          ..followers.totalCount = 123
          ..following.G__typename = 'FollowingConnection'
          ..following.totalCount = 456
          ..createdAt.value = '2020-01-01T00:00:00Z'
          ..updatedAt.value = '2024-01-01T00:00:00Z'
          ..starredRepositories.G__typename = 'StarredRepositoryConnection'
          ..starredRepositories.totalCount = 789
          ..organizations.G__typename = 'OrganizationConnection'
          ..organizations.totalCount = 10,
      );

      when(mockUserDetailsViewModel.user).thenReturn(mockUser);
      when(mockUserDetailsViewModel.repositoriesCount).thenReturn(42);
      when(mockUserDetailsViewModel.starredRepositoriesCount).thenReturn(789);
      when(mockUserDetailsViewModel.organizationsCount).thenReturn(10);
      when(mockUserDetailsViewModel.isUserLoading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      // Verify CustomScrollView and SliverAppBar are present
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.byType(SliverList), findsOneWidget);

      // Verify sticky title shows username (should find at least one)
      expect(find.text('@testuser'), findsAtLeast(1));

      // Verify flexible space content
      expect(find.text('Test User'), findsAtLeast(1));
      expect(find.byType(CircleAvatar), findsAtLeast(1));

      // Verify back button is present
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('calls init on ViewModel during initState', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      verify(mockUserDetailsViewModel.init()).called(1);
    });

    group('Lifecycle Management', () {
      testWidgets('should add listeners properly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        // Verify that the viewModel was set up with listeners
        verify(mockUserDetailsViewModel.addListener(any)).called(1);
      });

      testWidgets('should remove listeners when widget is disposed', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );
        await tester.pumpWidget(Container()); // Replace with empty widget

        verify(mockUserDetailsViewModel.removeListener(any)).called(1);
      });

      testWidgets('should dispose ViewModel when widget is disposed', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );
        await tester.pumpWidget(Container()); // Replace with empty widget

        // Verify that the ViewModel's dispose method was called
        verify(mockUserDetailsViewModel.dispose()).called(1);
      });
    });

    group('UserStatusCard Integration', () {
      testWidgets('shows status card when user has status', (
        WidgetTester tester,
      ) async {
        // Create user with status
        final mockUser = GGetUserDetailsData_user(
          (b) => b
            ..G__typename = 'User'
            ..id = 'test-id'
            ..login = 'testuser'
            ..name = 'Test User'
            ..email = 'test@example.com'
            ..bio = 'Test bio'
            ..location = 'Test Location'
            ..company = 'Test Company'
            ..avatarUrl.value = ''
            ..url.value = 'https://github.com/testuser'
            ..repositories.G__typename = 'RepositoryConnection'
            ..repositories.totalCount = 42
            ..followers.G__typename = 'FollowerConnection'
            ..followers.totalCount = 123
            ..following.G__typename = 'FollowingConnection'
            ..following.totalCount = 456
            ..createdAt.value = '2020-01-01T00:00:00Z'
            ..updatedAt.value = '2024-01-01T00:00:00Z'
            ..starredRepositories.G__typename = 'StarredRepositoryConnection'
            ..starredRepositories.totalCount = 789
            ..organizations.G__typename = 'OrganizationConnection'
            ..organizations.totalCount = 10,
        );

        when(mockUserDetailsViewModel.user).thenReturn(mockUser);
        when(
          mockUserDetailsViewModel.statusMessage,
        ).thenReturn('Working from home');
        when(mockUserDetailsViewModel.statusEmoji).thenReturn('🏠');
        when(mockUserDetailsViewModel.isUserLoading).thenReturn(false);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.byType(UserStatusCard), findsOneWidget);
        expect(find.text('Working from home'), findsOneWidget);
        expect(find.text('🏠'), findsOneWidget);
      });

      testWidgets('hides status card when user has no status', (
        WidgetTester tester,
      ) async {
        final mockUser = GGetUserDetailsData_user(
          (b) => b
            ..G__typename = 'User'
            ..id = 'test-id'
            ..login = 'testuser'
            ..name = 'Test User'
            ..email = 'test@example.com'
            ..bio = 'Test bio'
            ..location = 'Test Location'
            ..company = 'Test Company'
            ..avatarUrl.value = ''
            ..url.value = 'https://github.com/testuser'
            ..repositories.G__typename = 'RepositoryConnection'
            ..repositories.totalCount = 42
            ..followers.G__typename = 'FollowerConnection'
            ..followers.totalCount = 123
            ..following.G__typename = 'FollowingConnection'
            ..following.totalCount = 456
            ..createdAt.value = '2020-01-01T00:00:00Z'
            ..updatedAt.value = '2024-01-01T00:00:00Z'
            ..starredRepositories.G__typename = 'StarredRepositoryConnection'
            ..starredRepositories.totalCount = 789
            ..organizations.G__typename = 'OrganizationConnection'
            ..organizations.totalCount = 10,
        );

        when(mockUserDetailsViewModel.user).thenReturn(mockUser);
        when(mockUserDetailsViewModel.statusMessage).thenReturn(null);
        when(mockUserDetailsViewModel.statusEmoji).thenReturn(null);
        when(mockUserDetailsViewModel.isUserLoading).thenReturn(false);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.byType(UserStatusCard), findsNothing);
      });

      testWidgets('hides status card when status message is empty', (
        WidgetTester tester,
      ) async {
        final mockUser = GGetUserDetailsData_user(
          (b) => b
            ..G__typename = 'User'
            ..id = 'test-id'
            ..login = 'testuser'
            ..name = 'Test User'
            ..email = 'test@example.com'
            ..bio = 'Test bio'
            ..location = 'Test Location'
            ..company = 'Test Company'
            ..avatarUrl.value = ''
            ..url.value = 'https://github.com/testuser'
            ..repositories.G__typename = 'RepositoryConnection'
            ..repositories.totalCount = 42
            ..followers.G__typename = 'FollowerConnection'
            ..followers.totalCount = 123
            ..following.G__typename = 'FollowingConnection'
            ..following.totalCount = 456
            ..createdAt.value = '2020-01-01T00:00:00Z'
            ..updatedAt.value = '2024-01-01T00:00:00Z'
            ..starredRepositories.G__typename = 'StarredRepositoryConnection'
            ..starredRepositories.totalCount = 789
            ..organizations.G__typename = 'OrganizationConnection'
            ..organizations.totalCount = 10,
        );

        when(mockUserDetailsViewModel.user).thenReturn(mockUser);
        when(mockUserDetailsViewModel.statusMessage).thenReturn('');
        when(mockUserDetailsViewModel.statusEmoji).thenReturn('🏠');
        when(mockUserDetailsViewModel.isUserLoading).thenReturn(false);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.byType(UserStatusCard), findsNothing);
      });
    });
  });
}
