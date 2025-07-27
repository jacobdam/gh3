import 'package:flutter/material.dart';
import '../tokens/gh_tokens.dart';

/// A GitHub-styled chip component with selection states and count badges.
///
/// This component provides filter chips with GitHub-specific styling,
/// selection states, count badges, and color indicators.
class GHChip extends StatelessWidget {
  /// The text label to display on the chip
  final String label;

  /// Whether the chip is currently selected
  final bool isSelected;

  /// Callback when the chip is tapped
  final VoidCallback? onTap;

  /// Optional count to display as a badge
  final int? count;

  /// Optional color indicator dot
  final Color? colorIndicator;

  /// Whether the chip can be selected/deselected
  final bool isSelectable;

  const GHChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.count,
    this.colorIndicator,
    this.isSelectable = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isSelectable) {
      return FilterChip(
        label: _buildChipContent(theme),
        selected: isSelected,
        onSelected: onTap != null ? (_) => onTap!() : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GHTokens.radius16),
        ),
        labelStyle: GHTokens.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: GHTokens.spacing8,
          vertical: GHTokens.spacing4,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
    } else {
      return Chip(
        label: _buildChipContent(theme),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GHTokens.radius16),
        ),
        labelStyle: GHTokens.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: GHTokens.spacing8,
          vertical: GHTokens.spacing4,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
    }
  }

  Widget _buildChipContent(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (colorIndicator != null) ...[
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colorIndicator,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: GHTokens.spacing4),
        ],
        Text(label, style: GHTokens.labelMedium),
        if (count != null) ...[
          const SizedBox(width: GHTokens.spacing4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: GHTokens.spacing4,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(GHTokens.radius8),
            ),
            child: Text(
              count.toString(),
              style: GHTokens.labelMedium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
