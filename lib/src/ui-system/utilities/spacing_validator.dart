import 'package:flutter/foundation.dart';
import '../tokens/gh_tokens.dart';

/// Utility class for validating spacing compliance with the 4dp grid system.
///
/// Provides tools for verifying that spacing values follow GitHub's design
/// system standards and the 4dp grid system.
class SpacingValidator {
  SpacingValidator._();

  /// The base grid unit in dp
  static const double _gridUnit = 4.0;

  /// Validates that a spacing value follows the 4dp grid system
  static bool isValidSpacing(double spacing) {
    return spacing >= 0 && spacing % _gridUnit == 0;
  }

  /// Validates multiple spacing values at once
  static bool areValidSpacings(List<double> spacings) {
    return spacings.every((spacing) => isValidSpacing(spacing));
  }

  /// Gets the nearest valid spacing value for the 4dp grid
  static double nearestValidSpacing(double spacing) {
    if (spacing < 0) return 0;
    return (spacing / _gridUnit).round() * _gridUnit;
  }

  /// Gets all available standard spacing constants from GHTokens
  static List<double> getStandardSpacings() {
    return [
      GHTokens.spacing4,
      GHTokens.spacing8,
      GHTokens.spacing12,
      GHTokens.spacing16,
      GHTokens.spacing20,
      GHTokens.spacing24,
      GHTokens.spacing32,
    ];
  }

  /// Finds the closest standard spacing constant to a given value
  static double closestStandardSpacing(double spacing) {
    final standardSpacings = getStandardSpacings();
    double closest = standardSpacings.first;
    double minDifference = (spacing - closest).abs();

    for (final standard in standardSpacings) {
      final difference = (spacing - standard).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closest = standard;
      }
    }

    return closest;
  }

  /// Gets the name of a spacing constant from its value
  static String? getSpacingConstantName(double spacing) {
    switch (spacing) {
      case GHTokens.spacing4:
        return 'GHTokens.spacing4';
      case GHTokens.spacing8:
        return 'GHTokens.spacing8';
      case GHTokens.spacing12:
        return 'GHTokens.spacing12';
      case GHTokens.spacing16:
        return 'GHTokens.spacing16';
      case GHTokens.spacing20:
        return 'GHTokens.spacing20';
      case GHTokens.spacing24:
        return 'GHTokens.spacing24';
      case GHTokens.spacing32:
        return 'GHTokens.spacing32';
      default:
        return null;
    }
  }

  /// Validates spacing and provides helpful debugging information
  static SpacingValidationResult validateWithDetails(double spacing) {
    final isValid = isValidSpacing(spacing);
    final constantName = getSpacingConstantName(spacing);
    final nearestValid = nearestValidSpacing(spacing);
    final closestStandard = closestStandardSpacing(spacing);
    final closestStandardName = getSpacingConstantName(closestStandard);

    return SpacingValidationResult(
      value: spacing,
      isValid: isValid,
      isStandardConstant: constantName != null,
      constantName: constantName,
      nearestValidValue: nearestValid,
      closestStandardValue: closestStandard,
      closestStandardName: closestStandardName,
    );
  }

  /// Debug helper: Logs spacing validation information
  static void debugLogSpacing(double spacing, {String? context}) {
    if (!kDebugMode) return;

    final result = validateWithDetails(spacing);
    final contextStr = context != null ? '[$context] ' : '';

    if (result.isValid) {
      if (result.isStandardConstant) {
        debugPrint(
          '$contextStr✅ Valid spacing: ${result.constantName} (${result.value}dp)',
        );
      } else {
        debugPrint(
          '$contextStr⚠️  Valid but non-standard spacing: ${result.value}dp (consider using ${result.closestStandardName})',
        );
      }
    } else {
      debugPrint(
        '$contextStr❌ Invalid spacing: ${result.value}dp - not aligned to 4dp grid',
      );
      debugPrint('$contextStr   Nearest valid: ${result.nearestValidValue}dp');
      debugPrint(
        '$contextStr   Closest standard: ${result.closestStandardName} (${result.closestStandardValue}dp)',
      );
    }
  }

  /// Debug helper: Logs validation for multiple spacing values
  static void debugLogSpacings(List<double> spacings, {String? context}) {
    if (!kDebugMode) return;

    final contextStr = context != null ? '[$context] ' : '';
    debugPrint(
      '${contextStr}Spacing validation for ${spacings.length} values:',
    );

    for (int i = 0; i < spacings.length; i++) {
      debugLogSpacing(spacings[i], context: '$context[$i]');
    }
  }
}

/// Result of spacing validation with detailed information
class SpacingValidationResult {
  final double value;
  final bool isValid;
  final bool isStandardConstant;
  final String? constantName;
  final double nearestValidValue;
  final double closestStandardValue;
  final String? closestStandardName;

  const SpacingValidationResult({
    required this.value,
    required this.isValid,
    required this.isStandardConstant,
    this.constantName,
    required this.nearestValidValue,
    required this.closestStandardValue,
    this.closestStandardName,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('SpacingValidationResult:');
    buffer.writeln('  Value: ${value}dp');
    buffer.writeln('  Valid: $isValid');
    buffer.writeln('  Standard constant: $isStandardConstant');
    if (constantName != null) {
      buffer.writeln('  Constant name: $constantName');
    }
    buffer.writeln('  Nearest valid: ${nearestValidValue}dp');
    buffer.writeln(
      '  Closest standard: $closestStandardName (${closestStandardValue}dp)',
    );
    return buffer.toString();
  }
}
