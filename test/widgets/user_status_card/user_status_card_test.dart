import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/widgets/user_status_card/user_status_card.dart';
import 'package:gh3/src/screens/user_details/__generated__/user_details_viewmodel.data.gql.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart';

void main() {
  group('UserStatusCard', () {
    testWidgets('should display status message and emoji when both are provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserStatusCard(
              message: 'Working on something cool!',
              emoji: '🚀',
            ),
          ),
        ),
      );

      expect(find.text('Working on something cool!'), findsOneWidget);
      expect(find.text('🚀'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display status message without emoji when emoji is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserStatusCard(
              message: 'Working on something cool!',
              emoji: null,
            ),
          ),
        ),
      );

      expect(find.text('Working on something cool!'), findsOneWidget);
      expect(find.text('🚀'), findsNothing);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display status message without emoji when emoji is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserStatusCard(
              message: 'Working on something cool!',
              emoji: '',
            ),
          ),
        ),
      );

      expect(find.text('Working on something cool!'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      // Should not have extra spacing for emoji
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, equals(1)); // Only the Expanded text widget
    });

    testWidgets('should not render anything when message is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserStatusCard(
              message: null,
              emoji: '🚀',
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('🚀'), findsNothing);
    });

    testWidgets('should not render anything when message is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserStatusCard(
              message: '',
              emoji: '🚀',
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('🚀'), findsNothing);
    });

    testWidgets('should handle long status messages with proper text wrapping', (tester) async {
      const longMessage = 'This is a very long status message that should wrap properly within the card and not overflow the available space in the widget';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserStatusCard(
              message: longMessage,
              emoji: '📝',
            ),
          ),
        ),
      );

      expect(find.text(longMessage), findsOneWidget);
      expect(find.text('📝'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      
      // Verify the text is wrapped in an Expanded widget
      expect(find.byType(Expanded), findsOneWidget);
    });

    group('fromFragment factory constructor', () {
      testWidgets('should create widget from GraphQL fragment with message and emoji', (tester) async {
        final fragment = _createMockStatusFragment(
          message: 'Building something awesome',
          emoji: '⚡',
        );

        final widget = UserStatusCard.fromFragment(fragment);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: widget),
          ),
        );

        expect(find.text('Building something awesome'), findsOneWidget);
        expect(find.text('⚡'), findsOneWidget);
        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('should create widget from GraphQL fragment with only message', (tester) async {
        final fragment = _createMockStatusFragment(
          message: 'Building something awesome',
          emoji: null,
        );

        final widget = UserStatusCard.fromFragment(fragment);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: widget),
          ),
        );

        expect(find.text('Building something awesome'), findsOneWidget);
        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('should not render when fragment has null message', (tester) async {
        final fragment = _createMockStatusFragment(
          message: null,
          emoji: '🎯',
        );

        final widget = UserStatusCard.fromFragment(fragment);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: widget),
          ),
        );

        expect(find.byType(Card), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('should not render when fragment has empty message', (tester) async {
        final fragment = _createMockStatusFragment(
          message: '',
          emoji: '🎯',
        );

        final widget = UserStatusCard.fromFragment(fragment);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: widget),
          ),
        );

        expect(find.byType(Card), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    testWidgets('should apply proper styling and theming', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          home: const Scaffold(
            body: UserStatusCard(
              message: 'Test message',
              emoji: '✨',
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      
      // Verify card has proper margin
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.margin, equals(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)));
      
      // Verify padding - find the specific padding widget inside the card
      final paddings = tester.widgetList<Padding>(find.byType(Padding));
      final cardPadding = paddings.firstWhere((p) => p.padding == const EdgeInsets.all(16));
      expect(cardPadding.padding, equals(const EdgeInsets.all(16)));
      
      // Verify emoji styling
      final emojiText = tester.widget<Text>(find.text('✨'));
      expect(emojiText.style?.fontSize, equals(20));
    });
  });
}

// Helper function to create mock status fragment
GUserStatusFragment_status _createMockStatusFragment({
  String? message,
  String? emoji,
}) {
  return _MockUserStatusFragment(message: message, emoji: emoji);
}

class _MockUserStatusFragment implements GUserStatusFragment_status {
  @override
  final String? message;
  
  @override
  final String? emoji;
  
  @override
  final String G__typename = 'UserStatus';
  
  @override
  final GDateTime createdAt = GDateTime('2024-01-01T00:00:00Z');

  _MockUserStatusFragment({
    required this.message,
    required this.emoji,
  });
}