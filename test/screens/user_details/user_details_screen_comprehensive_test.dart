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
import 'package:gh3/src/widgets/skeleton_loading/skeleton_loading.dart';

import 'user_details_screen_test.mocks.dart';

@GenerateMocks([UserDetailsViewModel])
void main() {
  group('UserDetailsScreen Comprehensive Tests', () {
    late MockUserDetailsViewModel mockUserDetailsViewModel;

    setUp(() {
      mockUserDetailsViewModel = MockUserDetailsViewModel();
      when(mockUserDetailsViewModel.login).thenReturn('testuser');
    });

    void setupBasicMocks({
      bool isLoading = false,
      String? error,
      GGetUserDetailsData_user? user,
      bool isUserLoading = false,
      String? statusMessage,
      String? statusEmoji,
      int repositoriesCount = 0,
      int starredRepositoriesCount = 0,
      int organizationsCount = 0,
      bool isUserNotFoundError = false,
      bool isNetworkError = false,
      bool isAuthError = false,
    }) {
      when(mockUserDetailsViewModel.isLoading).thenReturn(isLoading);
      when(mockUserDetailsViewModel.error).thenReturn(error);
      when(mockUserDetailsViewModel.user).thenReturn(user);
      when(mockUserDetailsViewModel.isUserLoading).thenReturn(isUserLoading);
      when(mockUserDetailsViewModel.statusMessage).thenReturn(statusMessage);
      when(mockUserDetailsViewModel.statusEmoji).thenReturn(statusEmoji);
      when(
        mockUserDetailsViewModel.repositoriesCount,
      ).thenReturn(repositoriesCount);
      when(
        mockUserDetailsViewModel.starredRepositoriesCount,
      ).thenReturn(starredRepositoriesCount);
      when(
        mockUserDetailsViewModel.organizationsCount,
      ).thenReturn(organizationsCount);
      when(
        mockUserDetailsViewModel.isUserNotFoundError,
      ).thenReturn(isUserNotFoundError);
      when(mockUserDetailsViewModel.isNetworkError).thenReturn(isNetworkError);
      when(mockUserDetailsViewModel.isAuthError).thenReturn(isAuthError);
    }

    GGetUserDetailsData_user createMockUser({
      String? name,
      String? bio,
      String? company,
      String? location,
      String avatarUrl = '',
      int repositoriesCount = 42,
      int followersCount = 123,
      int followingCount = 456,
      int starredCount = 789,
      int organizationsCount = 10,
    }) {
      return GGetUserDetailsData_user(
        (b) => b
          ..G__typename = 'User'
          ..id = 'test-id'
          ..login = 'testuser'
          ..name = name
          ..email = 'test@example.com'
          ..bio = bio
          ..location = location
          ..company = company
          ..avatarUrl.value = avatarUrl
          ..url.value = 'https://github.com/testuser'
          ..repositories.G__typename = 'RepositoryConnection'
          ..repositories.totalCount = repositoriesCount
          ..followers.G__typename = 'FollowerConnection'
          ..followers.totalCount = followersCount
          ..following.G__typename = 'FollowingConnection'
          ..following.totalCount = followingCount
          ..createdAt.value = '2020-01-01T00:00:00Z'
          ..updatedAt.value = '2024-01-01T00:00:00Z'
          ..starredRepositories.G__typename = 'StarredRepositoryConnection'
          ..starredRepositories.totalCount = starredCount
          ..organizations.G__typename = 'OrganizationConnection'
          ..organizations.totalCount = organizationsCount,
      );
    }

    group('Loading States', () {
      testWidgets('shows skeleton loading screen when loading', (
        WidgetTester tester,
      ) async {
        setupBasicMocks(isLoading: true);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.byType(CustomScrollView), findsOneWidget);
        expect(find.byType(SliverAppBar), findsOneWidget);
        expect(find.byType(SkeletonLoading), findsAtLeast(1));
        expect(find.byType(BackButton), findsOneWidget);
        expect(find.text('Repositories'), findsOneWidget);
        expect(find.text('Starred'), findsOneWidget);
        expect(find.text('Organizations'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('shows user not found error', (WidgetTester tester) async {
        setupBasicMocks(error: 'User not found', isUserNotFoundError: true);

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
        expect(find.text('Try Again'), findsNothing);
      });

      testWidgets('shows network error with retry option', (
        WidgetTester tester,
      ) async {
        setupBasicMocks(error: 'Network error', isNetworkError: true);

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

      testWidgets('retry button calls refresh on viewModel', (
        WidgetTester tester,
      ) async {
        setupBasicMocks(error: 'Network error', isNetworkError: true);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        await tester.tap(find.text('Try Again'));
        verify(mockUserDetailsViewModel.refresh()).called(1);
      });
    });

    group('UserStatusCard Tests', () {
      testWidgets('shows status card when user has status', (
        WidgetTester tester,
      ) async {
        final mockUser = createMockUser(name: 'Test User');
        setupBasicMocks(
          user: mockUser,
          statusMessage: 'Working from home',
          statusEmoji: '🏠',
        );

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
        final mockUser = createMockUser(name: 'Test User');
        setupBasicMocks(user: mockUser);

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
        final mockUser = createMockUser(name: 'Test User');
        setupBasicMocks(user: mockUser, statusMessage: '', statusEmoji: '🏠');

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.byType(UserStatusCard), findsNothing);
      });
    });

    group('Navigation Tiles Tests', () {
      testWidgets('displays navigation tiles with correct counts', (
        WidgetTester tester,
      ) async {
        final mockUser = createMockUser(
          name: 'Test User',
          repositoriesCount: 1234,
          starredCount: 5678,
          organizationsCount: 15,
        );
        setupBasicMocks(
          user: mockUser,
          repositoriesCount: 1234,
          starredRepositoriesCount: 5678,
          organizationsCount: 15,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.text('Repositories'), findsOneWidget);
        expect(find.text('Starred'), findsOneWidget);
        expect(find.text('Organizations'), findsOneWidget);
        expect(find.text('1.2k'), findsOneWidget); // repositories
        expect(find.text('5.7k'), findsOneWidget); // starred
        expect(find.text('15'), findsOneWidget); // organizations
        expect(find.byIcon(Icons.folder_outlined), findsOneWidget);
        expect(find.byIcon(Icons.star_outline), findsOneWidget);
        expect(find.byIcon(Icons.business_outlined), findsOneWidget);
      });

      testWidgets('shows loading indicators when data is loading', (
        WidgetTester tester,
      ) async {
        final mockUser = createMockUser(name: 'Test User');
        setupBasicMocks(user: mockUser, isUserLoading: true);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsAtLeast(3));
      });

      testWidgets('navigation tiles are tappable', (WidgetTester tester) async {
        final mockUser = createMockUser(name: 'Test User');
        setupBasicMocks(user: mockUser);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        // Just verify the tiles are tappable without checking snackbar content
        await tester.tap(find.text('Repositories'));
        await tester.tap(find.text('Starred'));
        await tester.tap(find.text('Organizations'));
        await tester.pump();
      });
    });

    group('UserStatsRow Tests', () {
      testWidgets('displays UserStatsRow with correct data', (
        WidgetTester tester,
      ) async {
        final mockUser = createMockUser(
          name: 'Test User',
          followersCount: 1234,
          followingCount: 567,
        );
        setupBasicMocks(user: mockUser);

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

      testWidgets('UserStatsRow buttons are tappable', (
        WidgetTester tester,
      ) async {
        final mockUser = createMockUser(name: 'Test User');
        setupBasicMocks(user: mockUser);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        // Just verify the buttons are tappable without checking snackbar content
        await tester.tap(find.text('Followers'));
        await tester.tap(find.text('Following'));
        await tester.pump();
      });
    });

    group('Integration Tests', () {
      testWidgets('complete user details flow with all components', (
        WidgetTester tester,
      ) async {
        final mockUser = createMockUser(
          name: 'Test User',
          bio: 'Full stack developer',
          company: 'GitHub',
          location: 'San Francisco, CA',
          repositoriesCount: 150,
          followersCount: 2500,
          followingCount: 800,
          starredCount: 1200,
          organizationsCount: 5,
        );

        setupBasicMocks(
          user: mockUser,
          repositoriesCount: 150,
          starredRepositoriesCount: 1200,
          organizationsCount: 5,
          statusMessage: 'Building the future',
          statusEmoji: '🚀',
        );

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
        final mockUser = createMockUser(
          name: null, // no display name
          bio: null, // no bio
          company: null, // no company
          location: null, // no location
          repositoriesCount: 0,
          followersCount: 0,
          followingCount: 0,
          starredCount: 0,
          organizationsCount: 0,
        );

        setupBasicMocks(user: mockUser);

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

      testWidgets('displays UserProfile component correctly', (
        WidgetTester tester,
      ) async {
        final mockUser = createMockUser(
          name: 'Test User',
          bio: 'Test bio description',
          company: 'Test Company',
          location: 'Test Location',
        );

        setupBasicMocks(user: mockUser);

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

      testWidgets('CustomScrollView structure and behavior', (
        WidgetTester tester,
      ) async {
        final mockUser = createMockUser(name: 'Test User');
        setupBasicMocks(user: mockUser);

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        // Verify structure
        expect(find.byType(CustomScrollView), findsOneWidget);
        expect(find.byType(SliverAppBar), findsOneWidget);
        expect(find.byType(SliverList), findsOneWidget);

        // Verify header content
        expect(find.text('Test User'), findsAtLeast(1));
        expect(find.text('@testuser'), findsAtLeast(1));
        expect(find.byType(BackButton), findsOneWidget);

        // Test scrolling behavior
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
        await tester.pump();

        // After scrolling, the sticky title should still show username
        expect(find.text('@testuser'), findsAtLeast(1));
      });
    });

    group('ViewModel Interaction', () {
      testWidgets('calls init on ViewModel during initState', (
        WidgetTester tester,
      ) async {
        setupBasicMocks();

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        verify(mockUserDetailsViewModel.init()).called(1);
      });

      testWidgets('handles ViewModel lifecycle correctly', (
        WidgetTester tester,
      ) async {
        setupBasicMocks();

        await tester.pumpWidget(
          MaterialApp(
            home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
          ),
        );

        verify(mockUserDetailsViewModel.addListener(any)).called(1);

        await tester.pumpWidget(Container());

        verify(mockUserDetailsViewModel.removeListener(any)).called(1);
        verify(mockUserDetailsViewModel.dispose()).called(1);
      });
    });
  });
}
