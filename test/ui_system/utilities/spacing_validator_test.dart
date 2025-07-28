import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/ui-system/utilities/spacing_validator.dart';
import 'package:gh3/src/ui-system/tokens/gh_tokens.dart';

void main() {
  group('SpacingValidator', () {
    group('isValidSpacing', () {
      test('should return true for values that are multiples of 4', () {
        expect(SpacingValidator.isValidSpacing(0), isTrue);
        expect(SpacingValidator.isValidSpacing(4), isTrue);
        expect(SpacingValidator.isValidSpacing(8), isTrue);
        expect(SpacingValidator.isValidSpacing(12), isTrue);
        expect(SpacingValidator.isValidSpacing(16), isTrue);
        expect(SpacingValidator.isValidSpacing(20), isTrue);
        expect(SpacingValidator.isValidSpacing(24), isTrue);
        expect(SpacingValidator.isValidSpacing(32), isTrue);
        expect(SpacingValidator.isValidSpacing(100), isTrue);
      });

      test('should return false for values that are not multiples of 4', () {
        expect(SpacingValidator.isValidSpacing(1), isFalse);
        expect(SpacingValidator.isValidSpacing(2), isFalse);
        expect(SpacingValidator.isValidSpacing(3), isFalse);
        expect(SpacingValidator.isValidSpacing(5), isFalse);
        expect(SpacingValidator.isValidSpacing(6), isFalse);
        expect(SpacingValidator.isValidSpacing(7), isFalse);
        expect(SpacingValidator.isValidSpacing(15), isFalse);
        expect(SpacingValidator.isValidSpacing(18), isFalse);
      });

      test('should return false for negative values', () {
        expect(SpacingValidator.isValidSpacing(-4), isFalse);
        expect(SpacingValidator.isValidSpacing(-8), isFalse);
        expect(SpacingValidator.isValidSpacing(-1), isFalse);
      });
    });

    group('areValidSpacings', () {
      test('should return true when all spacings are valid', () {
        expect(SpacingValidator.areValidSpacings([0, 4, 8, 12, 16]), isTrue);
        expect(SpacingValidator.areValidSpacings([20, 24, 32]), isTrue);
        expect(SpacingValidator.areValidSpacings([]), isTrue);
      });

      test('should return false when any spacing is invalid', () {
        expect(SpacingValidator.areValidSpacings([4, 8, 15, 16]), isFalse);
        expect(SpacingValidator.areValidSpacings([1, 4, 8]), isFalse);
        expect(SpacingValidator.areValidSpacings([4, 8, -4]), isFalse);
      });
    });

    group('nearestValidSpacing', () {
      test('should return correct nearest valid spacing', () {
        expect(SpacingValidator.nearestValidSpacing(0), equals(0));
        expect(SpacingValidator.nearestValidSpacing(1), equals(0));
        expect(SpacingValidator.nearestValidSpacing(2), equals(4));
        expect(SpacingValidator.nearestValidSpacing(3), equals(4));
        expect(SpacingValidator.nearestValidSpacing(5), equals(4));
        expect(SpacingValidator.nearestValidSpacing(6), equals(8));
        expect(SpacingValidator.nearestValidSpacing(15), equals(16));
        expect(SpacingValidator.nearestValidSpacing(18), equals(20));
      });

      test('should return 0 for negative values', () {
        expect(SpacingValidator.nearestValidSpacing(-1), equals(0));
        expect(SpacingValidator.nearestValidSpacing(-8), equals(0));
      });

      test('should return same value for already valid spacings', () {
        expect(SpacingValidator.nearestValidSpacing(4), equals(4));
        expect(SpacingValidator.nearestValidSpacing(8), equals(8));
        expect(SpacingValidator.nearestValidSpacing(16), equals(16));
      });
    });

    group('getStandardSpacings', () {
      test('should return all standard spacing constants', () {
        final spacings = SpacingValidator.getStandardSpacings();

        expect(spacings, contains(GHTokens.spacing4));
        expect(spacings, contains(GHTokens.spacing8));
        expect(spacings, contains(GHTokens.spacing12));
        expect(spacings, contains(GHTokens.spacing16));
        expect(spacings, contains(GHTokens.spacing20));
        expect(spacings, contains(GHTokens.spacing24));
        expect(spacings, contains(GHTokens.spacing32));
        expect(spacings.length, equals(7));
      });

      test('should return spacings in ascending order', () {
        final spacings = SpacingValidator.getStandardSpacings();

        for (int i = 0; i < spacings.length - 1; i++) {
          expect(spacings[i], lessThan(spacings[i + 1]));
        }
      });
    });

    group('closestStandardSpacing', () {
      test('should return exact match for standard spacings', () {
        expect(
          SpacingValidator.closestStandardSpacing(GHTokens.spacing4),
          equals(GHTokens.spacing4),
        );
        expect(
          SpacingValidator.closestStandardSpacing(GHTokens.spacing16),
          equals(GHTokens.spacing16),
        );
        expect(
          SpacingValidator.closestStandardSpacing(GHTokens.spacing32),
          equals(GHTokens.spacing32),
        );
      });

      test('should return closest standard for non-standard values', () {
        expect(
          SpacingValidator.closestStandardSpacing(6),
          equals(GHTokens.spacing4),
        ); // 6 is equally close to 4 and 8, algorithm picks first
        expect(
          SpacingValidator.closestStandardSpacing(10),
          equals(GHTokens.spacing8),
        ); // 10 is equally close to 8 and 12, algorithm picks first
        expect(
          SpacingValidator.closestStandardSpacing(14),
          equals(GHTokens.spacing12),
        );
        expect(
          SpacingValidator.closestStandardSpacing(18),
          equals(GHTokens.spacing16),
        );
        expect(
          SpacingValidator.closestStandardSpacing(22),
          equals(GHTokens.spacing20),
        );
        expect(
          SpacingValidator.closestStandardSpacing(28),
          equals(GHTokens.spacing24),
        ); // 28 is equally close to 24 and 32, algorithm picks first
      });

      test('should handle edge cases', () {
        expect(
          SpacingValidator.closestStandardSpacing(0),
          equals(GHTokens.spacing4),
        );
        expect(
          SpacingValidator.closestStandardSpacing(1),
          equals(GHTokens.spacing4),
        );
        expect(
          SpacingValidator.closestStandardSpacing(100),
          equals(GHTokens.spacing32),
        );
      });
    });

    group('getSpacingConstantName', () {
      test('should return correct constant names for standard spacings', () {
        expect(
          SpacingValidator.getSpacingConstantName(GHTokens.spacing4),
          equals('GHTokens.spacing4'),
        );
        expect(
          SpacingValidator.getSpacingConstantName(GHTokens.spacing8),
          equals('GHTokens.spacing8'),
        );
        expect(
          SpacingValidator.getSpacingConstantName(GHTokens.spacing12),
          equals('GHTokens.spacing12'),
        );
        expect(
          SpacingValidator.getSpacingConstantName(GHTokens.spacing16),
          equals('GHTokens.spacing16'),
        );
        expect(
          SpacingValidator.getSpacingConstantName(GHTokens.spacing20),
          equals('GHTokens.spacing20'),
        );
        expect(
          SpacingValidator.getSpacingConstantName(GHTokens.spacing24),
          equals('GHTokens.spacing24'),
        );
        expect(
          SpacingValidator.getSpacingConstantName(GHTokens.spacing32),
          equals('GHTokens.spacing32'),
        );
      });

      test('should return null for non-standard spacing values', () {
        expect(SpacingValidator.getSpacingConstantName(0), isNull);
        expect(SpacingValidator.getSpacingConstantName(28), isNull);
        expect(SpacingValidator.getSpacingConstantName(36), isNull);
        expect(SpacingValidator.getSpacingConstantName(2), isNull);
      });
    });

    group('validateWithDetails', () {
      test('should correctly validate standard spacing constants', () {
        final result = SpacingValidator.validateWithDetails(GHTokens.spacing16);

        expect(result.value, equals(GHTokens.spacing16));
        expect(result.isValid, isTrue);
        expect(result.isStandardConstant, isTrue);
        expect(result.constantName, equals('GHTokens.spacing16'));
        expect(result.nearestValidValue, equals(GHTokens.spacing16));
        expect(result.closestStandardValue, equals(GHTokens.spacing16));
        expect(result.closestStandardName, equals('GHTokens.spacing16'));
      });

      test('should correctly validate valid but non-standard spacing', () {
        final result = SpacingValidator.validateWithDetails(28.0);

        expect(result.value, equals(28.0));
        expect(result.isValid, isTrue);
        expect(result.isStandardConstant, isFalse);
        expect(result.constantName, isNull);
        expect(result.nearestValidValue, equals(28.0));
        expect(
          result.closestStandardValue,
          equals(GHTokens.spacing24),
        ); // 28 is equally close to 24 and 32, algorithm picks first
        expect(result.closestStandardName, equals('GHTokens.spacing24'));
      });

      test('should correctly validate invalid spacing', () {
        final result = SpacingValidator.validateWithDetails(15.0);

        expect(result.value, equals(15.0));
        expect(result.isValid, isFalse);
        expect(result.isStandardConstant, isFalse);
        expect(result.constantName, isNull);
        expect(result.nearestValidValue, equals(16.0));
        expect(result.closestStandardValue, equals(GHTokens.spacing16));
        expect(result.closestStandardName, equals('GHTokens.spacing16'));
      });
    });
  });

  group('SpacingValidationResult', () {
    test('should have correct toString implementation', () {
      final result = SpacingValidationResult(
        value: 15.0,
        isValid: false,
        isStandardConstant: false,
        constantName: null,
        nearestValidValue: 16.0,
        closestStandardValue: 16.0,
        closestStandardName: 'GHTokens.spacing16',
      );

      final string = result.toString();
      expect(string, contains('15.0dp'));
      expect(string, contains('Valid: false'));
      expect(string, contains('Standard constant: false'));
      expect(string, contains('Nearest valid: 16.0dp'));
      expect(string, contains('GHTokens.spacing16'));
    });
  });
}
