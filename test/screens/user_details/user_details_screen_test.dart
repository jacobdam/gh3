import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:gh3/src/screens/user_details/user_details_screen.dart';
import 'package:gh3/src/screens/user_details/user_details_viewmodel.dart';
import 'package:gh3/src/screens/user_details/__generated__/user_details_viewmodel.data.gql.dart';

import 'user_details_screen_test.mocks.dart';

@GenerateMocks([UserDetailsViewModel])
void main() {
  group('UserDetailsScreen', () {
    late MockUserDetailsViewModel mockUserDetailsViewModel;

    setUp(() {
      mockUserDetailsViewModel = MockUserDetailsViewModel();
      when(mockUserDetailsViewModel.login).thenReturn('testuser');
      when(mockUserDetailsViewModel.isLoading).thenReturn(false);
      when(mockUserDetailsViewModel.error).thenReturn(null);
      when(mockUserDetailsViewModel.user).thenReturn(null);
    });

    testWidgets('shows loading screen when loading', (
      WidgetTester tester,
    ) async {
      when(mockUserDetailsViewModel.isLoading).thenReturn(true);

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('shows error screen when there is an error', (
      WidgetTester tester,
    ) async {
      when(mockUserDetailsViewModel.isLoading).thenReturn(false);
      when(mockUserDetailsViewModel.error).thenReturn('Network error');

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailsScreen(viewModel: mockUserDetailsViewModel),
        ),
      );

      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
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
      expect(find.text('Test User'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

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
  });
}
