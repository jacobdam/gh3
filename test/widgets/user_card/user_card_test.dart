import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/widgets/user_card/user_card.dart';
import 'package:gh3/src/widgets/user_card/__generated__/user_card.data.gql.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

void main() {
  group('UserCard', () {
    late GUserCardFragmentData baseUser;

    setUp(() {
      baseUser = GUserCardFragmentData.fromJson({
        'id': 'test-id',
        'login': 'testuser',
        'name': 'Test User',
        'avatarUrl': 'https://i.pravatar.cc/300',
        'bio': 'Test bio',
        'repositories': {'totalCount': 42},
        'followers': {'totalCount': 123},
      })!;
    });

    testWidgets('should display user information correctly', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: UserCard.fromFragment(baseUser))),
        );
        expect(find.text('Test User'), findsOneWidget);
        expect(find.text('@testuser'), findsOneWidget);
        expect(find.text('Test bio'), findsOneWidget);
        expect(find.text('42 repos'), findsOneWidget);
        expect(find.text('123 followers'), findsOneWidget);
      });
    });

    testWidgets(
      'should display avatar fallback correctly for different scenarios',
      (tester) async {
        await mockNetworkImages(() async {
          // Test fallback with first letter of login
          final userWithEmptyAvatar = baseUser.rebuild(
            (b) => b..avatarUrl.value = '',
          );
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: UserCard.fromFragment(userWithEmptyAvatar)),
            ),
          );
          expect(find.text('T'), findsOneWidget); // 'T' from 'testuser'

          // Test fallback with ? when both avatarUrl and login are empty
          final userWithEmptyBoth = baseUser.rebuild(
            (b) => b
              ..avatarUrl.value = ''
              ..login = '',
          );
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: UserCard.fromFragment(userWithEmptyBoth)),
            ),
          );
          expect(find.text('?'), findsOneWidget);
        });
      },
    );

    testWidgets('should display login if name is null', (tester) async {
      final user = baseUser.rebuild((b) => b..name = null);
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: UserCard.fromFragment(user))),
        );
        expect(find.text('testuser'), findsOneWidget);
      });
    });

    testWidgets('should not display bio if bio is null', (tester) async {
      final user = baseUser.rebuild((b) => b..bio = null);
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: UserCard.fromFragment(user))),
        );
        expect(find.text('Test bio'), findsNothing);
      });
    });

    testWidgets('should not display bio if bio is empty', (tester) async {
      final user = baseUser.rebuild((b) => b..bio = '');
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: UserCard.fromFragment(user))),
        );
        expect(find.text('Test bio'), findsNothing);
      });
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool tapped = false;
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserCard.fromFragment(baseUser, onTap: () => tapped = true),
            ),
          ),
        );
        await tester.tap(find.byType(UserCard));
        expect(tapped, isTrue);
      });
    });

    testWidgets(
      'should display correct repository and follower counts for edge cases',
      (tester) async {
        final userZero = baseUser.rebuild(
          (b) => b
            ..repositories.totalCount = 0
            ..followers.totalCount = 0,
        );
        final userOne = baseUser.rebuild(
          (b) => b
            ..repositories.totalCount = 1
            ..followers.totalCount = 1,
        );
        await mockNetworkImages(() async {
          await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: UserCard.fromFragment(userZero))),
          );
          expect(find.text('0 repos'), findsOneWidget);
          expect(find.text('0 followers'), findsOneWidget);
          await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: UserCard.fromFragment(userOne))),
          );
          expect(find.text('1 repos'), findsOneWidget);
          expect(find.text('1 followers'), findsOneWidget);
        });
      },
    );
  });
}
