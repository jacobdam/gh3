import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:gh3/src/screens/user_details/user_details_screen.dart';
import 'package:gh3/src/screens/user_details/user_details_viewmodel.dart';
import 'package:gh3/src/screens/user_details/__generated__/user_details_viewmodel.data.gql.dart';
import 'package:gh3/src/widgets/user_status_card/user_status_card.dart';
import 'package:gh3/src/widgets/user_stats_row/user_stats_row.dart';
import 'package:gh3/src/widgets/user_profile/user_profile.dart';

import 'user_details_screen_test.mocks.dart';

@GenerateMocks([UserDetailsViewModel])
void main() {
  group('UserDetailsScreen Integration Tests', () {
    late MockUserDetailsViewModel mockUserDetailsViewModel;

    setUp(() {
      mockUserDetailsViewModel = MockUserDetailsViewModel();
      when(mockUserDetailsViewModel.login).thenReturn('testuser');
      when(mockUserDetailsViewModel.isLoading).thenReturn(false);
      when(mockUserDetailsViewModel.error).thenReturn(null);
      when(mockUserDetailsViewModel.user).thenReturn(null);
      when(mockUserDetailsViewModel.isUserLoading).thenReturn(false);
      when(mockUserDetailsViewModel.isUserNotFoundError).thenReturn(false);
      when(mockUserDetailsViewModel.isNetworkError).thenReturn(false);
      when(mockUserDetailsViewModel.isAuthError).thenReturn(false);
      when(mockUserDetailsViewModel.statusMessage).thenReturn(null);
      when(mockUserDetailsViewModel.statusEmoji).thenReturn(null);
      when(mockUserDetailsViewModel.repositoriesCount).thenReturn(0);
      when(mockUserDetailsViewModel.starredRepositoriesCount).thenReturn(0);
      when(mockUserDetailsViewModel.organizationsCount).thenReturn(0);
    });

    testWidgets('complete user details flow with all components', (
      WidgetTester tester,
    ) async {
      final mockUser = GGetUserDetailsData_user(
        (b) => b
          ..G__typename = 'User'
          ..id = 'test-id'
          ..login = 'testuser'
          ..name = 'Test User'
          ..email = 'test@example.com'
          ..bio = 'Full stack developer'
          ..location = 'San Francisco, CA'
          ..company = 'GitHub'
          ..avatarUrl.value = 'https://github.com/testuser.png'
          ..url.value = 'https://github.com/testuser'
          ..repositories.G__typename = 'RepositoryConnection'
          ..repositories.totalCount = 150
          ..followers.G__typename = 'FollowerConnection'
          ..followers.totalCount = 2500
          ..following.G__typename = 'FollowingConnection'
          ..following.totalCount = 800
          ..createdAt.value = '2020-01-01T00:00:00Z'
          ..updatedAt.value = '2024-01-01T00:00:00Z'
          ..starredRepositories.G__typename = 'StarredRepositoryConnection'
          ..starredRepositories.totalCount = 1200
          ..organizations.G__typename = 'OrganizationConnection'
          ..organizations.totalCount = 5,
      );

      when(mockUserDetailsViewModel.user).thenReturn(mockUser);
      when(mockUserDetailsViewModel.repositoriesCount).thenReturn(150);
      when(mockUserDetailsViewModel.starredRepositoriesCount).thenReturn(1200);
      when(mockUserDetailsViewModel.organizationsCount).thenReturn(5);
      when(
        mockUserDetailsViewModel.statusMessage,
      ).thenReturn('Building the future');
      when(mockUserDetailsViewModel.statusEmoji).thenReturn('🚀');

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      // Verify all main components are present
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.byType(UserProfile), findsOneWidget);
      expect(find.byType(UserStatusCard), findsOneWidget);
      expect(find.byType(UserStatsRow), findsOneWidget);

      // Verify header content
      expect(find.text('Test User'), findsAtLeast(1));
      expect(find.text('@testuser'), findsAtLeast(1));

      // Verify profile information
      expect(find.text('Full stack developer'), findsOneWidget);
      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('San Francisco, CA'), findsOneWidget);

      // Verify status
      expect(find.text('Building the future'), findsOneWidget);
      expect(find.text('🚀'), findsOneWidget);

      // Verify stats
      expect(find.text('2.5k'), findsOneWidget); // followers
      expect(find.text('800'), findsOneWidget); // following

      // Verify navigation tiles
      expect(find.text('Repositories'), findsOneWidget);
      expect(find.text('Starred'), findsOneWidget);
      expect(find.text('Organizations'), findsOneWidget);
      expect(find.text('150'), findsOneWidget);
      expect(find.text('1.2k'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('handles missing optional data gracefully', (
      WidgetTester tester,
    ) async {
      final mockUser = GGetUserDetailsData_user(
        (b) => b
          ..G__typename = 'User'
          ..id = 'test-id'
          ..login = 'testuser'
          ..name =
              null // no display name
          ..email = 'test@example.com'
          ..bio =
              null // no bio
          ..location =
              null // no location
          ..company =
              null // no company
          ..avatarUrl.value =
              '' // no avatar
          ..url.value = 'https://github.com/testuser'
          ..repositories.G__typename = 'RepositoryConnection'
          ..repositories.totalCount = 0
          ..followers.G__typename = 'FollowerConnection'
          ..followers.totalCount = 0
          ..following.G__typename = 'FollowingConnection'
          ..following.totalCount = 0
          ..createdAt.value = '2020-01-01T00:00:00Z'
          ..updatedAt.value = '2024-01-01T00:00:00Z'
          ..starredRepositories.G__typename = 'StarredRepositoryConnection'
          ..starredRepositories.totalCount = 0
          ..organizations.G__typename = 'OrganizationConnection'
          ..organizations.totalCount = 0,
      );

      when(mockUserDetailsViewModel.user).thenReturn(mockUser);
      when(mockUserDetailsViewModel.repositoriesCount).thenReturn(0);
      when(mockUserDetailsViewModel.starredRepositoriesCount).thenReturn(0);
      when(mockUserDetailsViewModel.organizationsCount).thenReturn(0);
      when(mockUserDetailsViewModel.statusMessage).thenReturn(null);
      when(mockUserDetailsViewModel.statusEmoji).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      // Should show login as fallback for name
      expect(find.text('testuser'), findsAtLeast(1));
      expect(find.text('@testuser'), findsAtLeast(1));

      // Should not show status card
      expect(find.byType(UserStatusCard), findsNothing);

      // Should show zero counts
      expect(
        find.text('0'),
        findsNWidgets(5),
      ); // repos, starred, orgs, followers, following
    });

    testWidgets('displays UserProfile without card and stats', (
      WidgetTester tester,
    ) async {
      final mockUser = GGetUserDetailsData_user(
        (b) => b
          ..G__typename = 'User'
          ..id = 'test-id'
          ..login = 'testuser'
          ..name = 'Test User'
          ..email = 'test@example.com'
          ..bio = 'Test bio description'
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

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      expect(find.byType(UserProfile), findsOneWidget);
      expect(find.text('Test bio description'), findsOneWidget);
      expect(find.text('Test Company'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('scrolling behavior with SliverAppBar', (
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
      when(mockUserDetailsViewModel.repositoriesCount).thenReturn(42);
      when(mockUserDetailsViewModel.starredRepositoriesCount).thenReturn(789);
      when(mockUserDetailsViewModel.organizationsCount).thenReturn(10);
      when(mockUserDetailsViewModel.statusMessage).thenReturn(null);
      when(mockUserDetailsViewModel.statusEmoji).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      // Verify initial state - both name and username should be visible
      expect(find.text('Test User'), findsAtLeast(1));
      expect(find.text('@testuser'), findsAtLeast(1));

      // Test scrolling behavior
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pump();

      // After scrolling, the sticky title should still show username
      expect(find.text('@testuser'), findsAtLeast(1));
    });

    testWidgets('error state displays correctly and retry button works', (
      WidgetTester tester,
    ) async {
      // Start with network error
      when(mockUserDetailsViewModel.isLoading).thenReturn(false);
      when(mockUserDetailsViewModel.error).thenReturn('Network error');
      when(mockUserDetailsViewModel.isNetworkError).thenReturn(true);

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      // Verify error state is displayed correctly
      expect(find.text('Connection Problem'), findsAtLeast(1));
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('Please check your internet connection and try again.'), findsOneWidget);

      // Verify retry button is functional
      await tester.tap(find.text('Try Again'));
      verify(mockUserDetailsViewModel.refresh()).called(1);
    });

    testWidgets('loading state displays skeleton correctly', (
      WidgetTester tester,
    ) async {
      // Set loading state
      when(mockUserDetailsViewModel.isLoading).thenReturn(true);

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      // Verify skeleton loading components are present
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
      
      // Verify navigation tiles are shown during loading
      expect(find.text('Repositories'), findsOneWidget);
      expect(find.text('Starred'), findsOneWidget);
      expect(find.text('Organizations'), findsOneWidget);
    });
  });
}
