import 'package:flutter/material.dart';
import '../tokens/gh_tokens.dart';

/// A GitHub-styled card component with consistent elevation and styling.
///
/// This component provides a Material Design 3 card with GitHub-specific
/// styling including consistent padding, border radius, and elevation.
class GHCard extends StatelessWidget {
  /// The widget to display inside the card
  final Widget child;

  /// Custom padding for the card content. Defaults to 16dp on all sides.
  final EdgeInsetsGeometry? padding;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Custom elevation for the card. Defaults to 1dp.
  final double? elevation;

  /// Custom margin around the card
  final EdgeInsetsGeometry? margin;

  const GHCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevation,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? GHTokens.elevation1,
      margin: margin ?? const EdgeInsets.all(GHTokens.spacing4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GHTokens.radius8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GHTokens.radius8),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(GHTokens.spacing16),
          child: child,
        ),
      ),
    );
  }
}
