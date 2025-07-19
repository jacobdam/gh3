import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/widgets/user_card/user_card.dart';
import 'package:gh3/src/widgets/user_card/__generated__/user_card.data.gql.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart';

// Mock implementation of GUserCardFragment for testing
class MockUserCardFragment implements GUserCardFragment {
  @override
  String get G__typename => 'User';

  @override
  String get id => 'test-id';

  @override
  String get login => 'testuser';

  @override
  String? get name => 'Test User';

  @override
  GURI get avatarUrl => GURI('https://example.com/avatar.jpg');

  @override
  String? get bio => 'Test bio';

  @override
  GUserCardFragment_repositories get repositories => MockRepositories();

  @override
  GUserCardFragment_followers get followers => MockFollowers();
}

class MockRepositories implements GUserCardFragment_repositories {
  @override
  String get G__typename => 'RepositoryConnection';

  @override
  int get totalCount => 42;
}

class MockFollowers implements GUserCardFragment_followers {
  @override
  String get G__typename => 'FollowerConnection';

  @override
  int get totalCount => 123;
}

class MockUserCardFragmentWithoutName implements GUserCardFragment {
  @override
  String get G__typename => 'User';

  @override
  String get id => 'test-id';

  @override
  String get login => 'testuser';

  @override
  String? get name => null; // No name

  @override
  GURI get avatarUrl => GURI('https://example.com/avatar.jpg');

  @override
  String? get bio => 'Test bio';

  @override
  GUserCardFragment_repositories get repositories => MockRepositories();

  @override
  GUserCardFragment_followers get followers => MockFollowers();
}

class MockUserCardFragmentWithoutBio implements GUserCardFragment {
  @override
  String get G__typename => 'User';

  @override
  String get id => 'test-id';

  @override
  String get login => 'testuser';

  @override
  String? get name => 'Test User';

  @override
  GURI get avatarUrl => GURI('https://example.com/avatar.jpg');

  @override
  String? get bio => null; // No bio

  @override
  GUserCardFragment_repositories get repositories => MockRepositories();

  @override
  GUserCardFragment_followers get followers => MockFollowers();
}

void main() {
  group('UserCard', () {
    late MockUserCardFragment mockUser;

    setUp(() {
      mockUser = MockUserCardFragment();
    });

    testWidgets('should display user information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: mockUser)),
        ),
      );

      // Verify user name is displayed
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('@testuser'), findsOneWidget);

      // Verify bio is displayed
      expect(find.text('Test bio'), findsOneWidget);

      // Verify repository count
      expect(find.text('42 repos'), findsOneWidget);

      // Verify follower count
      expect(find.text('123 followers'), findsOneWidget);
    });

    testWidgets('should handle tap events', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserCard(user: mockUser, onTap: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.byType(UserCard));
      expect(tapped, isTrue);
    });

    testWidgets('should display fallback when name is null', (tester) async {
      final userWithoutName = MockUserCardFragmentWithoutName();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: userWithoutName)),
        ),
      );

      // Should display login when name is null
      expect(find.text('testuser'), findsOneWidget); // Falls back to login
    });

    testWidgets('should handle empty bio gracefully', (tester) async {
      final userWithoutBio = MockUserCardFragmentWithoutBio();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: userWithoutBio)),
        ),
      );

      // Should not crash and should display other information
      expect(find.text('@testuser'), findsOneWidget);
    });
  });
}
