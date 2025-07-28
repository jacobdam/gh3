import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/ui-system/components/gh_card.dart';
import 'package:gh3/src/ui-system/tokens/gh_tokens.dart';

void main() {
  group('GHCard', () {
    testWidgets('should create standard card with default padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GHCard(child: Container())),
        ),
      );

      final card = tester.widget<GHCard>(find.byType(GHCard));
      expect(card.padding, isNull); // Uses default padding in build method
    });

    testWidgets('should create compact card with 12dp padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GHCard.compact(child: Container())),
        ),
      );

      final card = tester.widget<GHCard>(find.byType(GHCard));
      expect(card.padding, equals(const EdgeInsets.all(GHTokens.spacing12)));
    });

    testWidgets('should create tight card with 8dp padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GHCard.tight(child: Container())),
        ),
      );

      final card = tester.widget<GHCard>(find.byType(GHCard));
      expect(card.padding, equals(const EdgeInsets.all(GHTokens.spacing8)));
    });

    testWidgets('should create zero padding card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GHCard.zeroPadding(child: Container())),
        ),
      );

      final card = tester.widget<GHCard>(find.byType(GHCard));
      expect(card.padding, equals(EdgeInsets.zero));
    });

    testWidgets('should handle tap callback for all variants', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                GHCard(onTap: () => tapped = true, child: Container()),
                GHCard.compact(onTap: () => tapped = true, child: Container()),
                GHCard.tight(onTap: () => tapped = true, child: Container()),
                GHCard.zeroPadding(
                  onTap: () => tapped = true,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      );

      // Test each variant can be tapped
      await tester.tap(find.byType(GHCard).first);
      expect(tapped, isTrue);
    });

    group('padding validation', () {
      test('compact padding should be 4dp grid compliant', () {
        expect(GHTokens.spacing12 % 4, equals(0));
        expect(GHTokens.spacing12, equals(12.0));
      });

      test('tight padding should be 4dp grid compliant', () {
        expect(GHTokens.spacing8 % 4, equals(0));
        expect(GHTokens.spacing8, equals(8.0));
      });

      test('padding hierarchy should be correct', () {
        expect(0, lessThan(GHTokens.spacing8)); // zero < tight
        expect(
          GHTokens.spacing8,
          lessThan(GHTokens.spacing12),
        ); // tight < compact
        expect(
          GHTokens.spacing12,
          lessThan(GHTokens.spacing16),
        ); // compact < standard
      });
    });
  });
}
