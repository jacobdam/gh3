import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/widgets/user_stats_row/user_stats_row.dart';

void main() {
  group('UserStatsRow', () {
    testWidgets('should display follower and following counts', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserStatsRow(followerCount: 123, followingCount: 456),
          ),
        ),
      );

      expect(find.text('123'), findsOneWidget);
      expect(find.text('456'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
    });

    testWidgets('should handle various count scenarios', (tester) async {
      // Test large numbers
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserStatsRow(followerCount: 1234, followingCount: 1500000),
          ),
        ),
      );
      expect(find.text('1.2k'), findsOneWidget);
      expect(find.text('1.5M'), findsOneWidget);

      // Test exact thousands and millions
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserStatsRow(followerCount: 1000, followingCount: 2000000),
          ),
        ),
      );
      expect(find.text('1k'), findsOneWidget);
      expect(find.text('2M'), findsOneWidget);

      // Test zero and small numbers
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserStatsRow(followerCount: 0, followingCount: 999),
          ),
        ),
      );
      expect(find.text('0'), findsOneWidget);
      expect(find.text('999'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
    });

    testWidgets(
      'should call onFollowersPressed when followers section is tapped',
      (tester) async {
        bool followersTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserStatsRow(
                followerCount: 123,
                followingCount: 456,
                onFollowersPressed: () => followersTapped = true,
              ),
            ),
          ),
        );

        // Find the followers section and tap it
        final followersSection = find
            .ancestor(
              of: find.text('Followers'),
              matching: find.byType(InkWell),
            )
            .first;

        await tester.tap(followersSection);
        await tester.pumpAndSettle();

        expect(followersTapped, isTrue);
      },
    );

    testWidgets(
      'should call onFollowingPressed when following section is tapped',
      (tester) async {
        bool followingTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserStatsRow(
                followerCount: 123,
                followingCount: 456,
                onFollowingPressed: () => followingTapped = true,
              ),
            ),
          ),
        );

        // Find the following section and tap it
        final followingSection = find
            .ancestor(
              of: find.text('Following'),
              matching: find.byType(InkWell),
            )
            .last;

        await tester.tap(followingSection);
        await tester.pumpAndSettle();

        expect(followingTapped, isTrue);
      },
    );

    testWidgets('should not call callbacks when they are null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserStatsRow(
              followerCount: 123,
              followingCount: 456,
              // No callbacks provided
            ),
          ),
        ),
      );

      // Find the sections and tap them - should not throw
      final followersSection = find
          .ancestor(of: find.text('Followers'), matching: find.byType(InkWell))
          .first;

      final followingSection = find
          .ancestor(of: find.text('Following'), matching: find.byType(InkWell))
          .last;

      await tester.tap(followersSection);
      await tester.tap(followingSection);
      await tester.pumpAndSettle();

      // Should complete without errors
    });

    testWidgets('should display appropriate icons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserStatsRow(followerCount: 123, followingCount: 456),
          ),
        ),
      );

      expect(find.byIcon(Icons.people), findsOneWidget);
      expect(find.byIcon(Icons.person_add), findsOneWidget);
    });

    testWidgets('should use primary color for interactive elements', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: UserStatsRow(
              followerCount: 123,
              followingCount: 456,
              onFollowersPressed: () {},
              onFollowingPressed: () {},
            ),
          ),
        ),
      );

      // Find icons and verify they use primary color
      final icons = tester.widgetList<Icon>(find.byType(Icon));
      for (final icon in icons) {
        expect(icon.color, equals(Colors.blue));
      }
    });

    testWidgets('should use grey color for non-interactive elements', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserStatsRow(
              followerCount: 123,
              followingCount: 456,
              // No callbacks - should be non-interactive
            ),
          ),
        ),
      );

      // Find icons and verify they use grey color
      final icons = tester.widgetList<Icon>(find.byType(Icon));
      for (final icon in icons) {
        expect(icon.color, equals(Colors.grey[600]));
      }
    });

    group('count formatting', () {
      testWidgets('should format all number ranges correctly', (tester) async {
        // Test zero and small numbers
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserStatsRow(followerCount: 0, followingCount: 42),
            ),
          ),
        );
        expect(find.text('0'), findsOneWidget);
        expect(find.text('42'), findsOneWidget);

        // Test thousands
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserStatsRow(followerCount: 1000, followingCount: 1200),
            ),
          ),
        );
        expect(find.text('1k'), findsOneWidget);
        expect(find.text('1.2k'), findsOneWidget);

        // Test millions
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserStatsRow(
                followerCount: 1000000,
                followingCount: 1500000,
              ),
            ),
          ),
        );
        expect(find.text('1M'), findsOneWidget);
        expect(find.text('1.5M'), findsOneWidget);
      });
    });
  });
}
