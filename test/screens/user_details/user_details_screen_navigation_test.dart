import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:gh3/src/screens/user_details/user_details_screen.dart';
import 'package:gh3/src/screens/user_details/user_details_viewmodel.dart';
import 'package:gh3/src/screens/user_details/__generated__/user_details_viewmodel.data.gql.dart';
import 'package:gh3/src/widgets/user_stats_row/user_stats_row.dart';

import 'user_details_screen_test.mocks.dart';

@GenerateMocks([UserDetailsViewModel])
void main() {
  group('UserDetailsScreen Navigation Tests', () {
    late MockUserDetailsViewModel mockUserDetailsViewModel;
    late GGetUserDetailsData_user mockUser;

    setUp(() {
      mockUserDetailsViewModel = MockUserDetailsViewModel();
      mockUser = GGetUserDetailsData_user(
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
          ..repositories.totalCount = 1234
          ..followers.G__typename = 'FollowerConnection'
          ..followers.totalCount = 123
          ..following.G__typename = 'FollowingConnection'
          ..following.totalCount = 456
          ..createdAt.value = '2020-01-01T00:00:00Z'
          ..updatedAt.value = '2024-01-01T00:00:00Z'
          ..starredRepositories.G__typename = 'StarredRepositoryConnection'
          ..starredRepositories.totalCount = 5678
          ..organizations.G__typename = 'OrganizationConnection'
          ..organizations.totalCount = 15,
      );

      when(mockUserDetailsViewModel.login).thenReturn('testuser');
      when(mockUserDetailsViewModel.isLoading).thenReturn(false);
      when(mockUserDetailsViewModel.error).thenReturn(null);
      when(mockUserDetailsViewModel.user).thenReturn(mockUser);
      when(mockUserDetailsViewModel.repositoriesCount).thenReturn(1234);
      when(mockUserDetailsViewModel.starredRepositoriesCount).thenReturn(5678);
      when(mockUserDetailsViewModel.organizationsCount).thenReturn(15);
      when(mockUserDetailsViewModel.isUserLoading).thenReturn(false);
      when(mockUserDetailsViewModel.statusMessage).thenReturn(null);
      when(mockUserDetailsViewModel.statusEmoji).thenReturn(null);
      when(mockUserDetailsViewModel.isUserNotFoundError).thenReturn(false);
      when(mockUserDetailsViewModel.isNetworkError).thenReturn(false);
      when(mockUserDetailsViewModel.isAuthError).thenReturn(false);
    });

    group('Navigation Tiles', () {
      testWidgets('displays navigation tiles with correct counts', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        // Find the navigation tiles
        expect(find.text('Repositories'), findsOneWidget);
        expect(find.text('Starred'), findsOneWidget);
        expect(find.text('Organizations'), findsOneWidget);

        // Check formatted counts
        expect(find.text('1.2k'), findsOneWidget); // repositories
        expect(find.text('5.7k'), findsOneWidget); // starred
        expect(find.text('15'), findsOneWidget); // organizations

        // Check icons
        expect(find.byIcon(Icons.folder_outlined), findsOneWidget);
        expect(find.byIcon(Icons.star_outline), findsOneWidget);
        expect(find.byIcon(Icons.business_outlined), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right), findsNWidgets(3));
      });

      testWidgets('shows loading indicators when data is loading', (
        WidgetTester tester,
      ) async {
        when(mockUserDetailsViewModel.isUserLoading).thenReturn(true);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        // Should show loading indicators instead of counts
        expect(find.byType(CircularProgressIndicator), findsAtLeast(3));
        expect(find.text('1.2k'), findsNothing);
        expect(find.text('5.7k'), findsNothing);
        expect(find.text('15'), findsNothing);
      });

      testWidgets('navigation tiles show placeholder snackbars when tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        // Tap repositories tile
        await tester.tap(find.text('Repositories'));
        await tester.pump();
        expect(
          find.text('Repositories navigation not implemented yet'),
          findsOneWidget,
        );

        // Dismiss snackbar
        await tester.pump(const Duration(seconds: 4));

        // Tap starred tile
        await tester.tap(find.text('Starred'));
        await tester.pump();
        expect(
          find.text('Starred repositories navigation not implemented yet'),
          findsOneWidget,
        );

        // Dismiss snackbar
        await tester.pump(const Duration(seconds: 4));

        // Tap organizations tile
        await tester.tap(find.text('Organizations'));
        await tester.pump();
        expect(
          find.text('Organizations navigation not implemented yet'),
          findsOneWidget,
        );
      });

      testWidgets('formats large counts correctly', (
        WidgetTester tester,
      ) async {
        when(mockUserDetailsViewModel.repositoriesCount).thenReturn(1500000);
        when(
          mockUserDetailsViewModel.starredRepositoriesCount,
        ).thenReturn(2300000);
        when(mockUserDetailsViewModel.organizationsCount).thenReturn(1200);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.text('1.5M'), findsOneWidget); // repositories
        expect(find.text('2.3M'), findsOneWidget); // starred
        expect(find.text('1.2k'), findsOneWidget); // organizations
      });
    });

    group('UserStatsRow Integration', () {
      testWidgets('displays UserStatsRow with correct data', (
        WidgetTester tester,
      ) async {
        final userWithStats = GGetUserDetailsData_user(
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
            ..followers.totalCount = 1234
            ..following.G__typename = 'FollowingConnection'
            ..following.totalCount = 567
            ..createdAt.value = '2020-01-01T00:00:00Z'
            ..updatedAt.value = '2024-01-01T00:00:00Z'
            ..starredRepositories.G__typename = 'StarredRepositoryConnection'
            ..starredRepositories.totalCount = 789
            ..organizations.G__typename = 'OrganizationConnection'
            ..organizations.totalCount = 10,
        );

        when(mockUserDetailsViewModel.user).thenReturn(userWithStats);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.byType(UserStatsRow), findsOneWidget);
        expect(find.text('Followers'), findsOneWidget);
        expect(find.text('Following'), findsOneWidget);
        expect(find.text('1.2k'), findsOneWidget); // formatted followers count
        expect(find.text('567'), findsOneWidget); // following count
      });

      testWidgets('shows skeleton when user data is loading', (
        WidgetTester tester,
      ) async {
        when(mockUserDetailsViewModel.isUserLoading).thenReturn(true);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        // Should show skeleton loading instead of UserStatsRow
        expect(find.byType(UserStatsRow), findsNothing);
        expect(find.text('Followers'), findsNothing);
        expect(find.text('Following'), findsNothing);
      });

      testWidgets('UserStatsRow placeholder navigation shows snackbars', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        // Tap followers button
        await tester.tap(find.text('Followers'));
        await tester.pump();
        expect(
          find.text('Followers navigation not implemented yet'),
          findsOneWidget,
        );

        // Dismiss snackbar
        await tester.pump(const Duration(seconds: 4));

        // Tap following button
        await tester.tap(find.text('Following'));
        await tester.pump();
        expect(
          find.text('Following navigation not implemented yet'),
          findsOneWidget,
        );
      });
    });
  });
}
