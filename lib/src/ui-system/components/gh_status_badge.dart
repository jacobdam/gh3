import 'package:flutter/material.dart';
import '../tokens/gh_tokens.dart';

/// GitHub status types with semantic meaning
enum GHStatus {
  /// Open issues, pull requests
  open,

  /// Closed issues, pull requests
  closed,

  /// Merged pull requests
  merged,

  /// Draft pull requests
  draft,
}

/// A GitHub-styled status badge component with semantic colors.
///
/// This component provides status indicators with GitHub-specific colors,
/// icons, and consistent styling for different states.
class GHStatusBadge extends StatelessWidget {
  /// The status type to display
  final GHStatus status;

  /// Custom label text (overrides default status label)
  final String? customLabel;

  /// Whether to show the status icon
  final bool showIcon;

  /// Custom icon (overrides default status icon)
  final IconData? customIcon;

  const GHStatusBadge({
    super.key,
    required this.status,
    this.customLabel,
    this.showIcon = true,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GHTokens.spacing8,
        vertical: GHTokens.spacing4,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(GHTokens.radius12),
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              customIcon ?? config.icon,
              size: GHTokens.iconSize16,
              color: config.iconColor,
            ),
            const SizedBox(width: GHTokens.spacing4),
          ],
          Text(
            customLabel ?? config.label,
            style: GHTokens.labelMedium.copyWith(
              color: config.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(GHStatus status) {
    switch (status) {
      case GHStatus.open:
        return const _StatusConfig(
          backgroundColor: Color(0xFFDCFFE4),
          borderColor: Color(0xFF1A7F37),
          textColor: Color(0xFF1A7F37),
          iconColor: Color(0xFF1A7F37),
          icon: Icons.error_outline,
          label: 'Open',
        );
      case GHStatus.closed:
        return const _StatusConfig(
          backgroundColor: Color(0xFFFFE1E6),
          borderColor: Color(0xFFCF222E),
          textColor: Color(0xFFCF222E),
          iconColor: Color(0xFFCF222E),
          icon: Icons.check_circle_outline,
          label: 'Closed',
        );
      case GHStatus.merged:
        return const _StatusConfig(
          backgroundColor: Color(0xFFF4EBFF),
          borderColor: Color(0xFF8250DF),
          textColor: Color(0xFF8250DF),
          iconColor: Color(0xFF8250DF),
          icon: Icons.merge_type,
          label: 'Merged',
        );
      case GHStatus.draft:
        return const _StatusConfig(
          backgroundColor: Color(0xFFF6F8FA),
          borderColor: Color(0xFF656D76),
          textColor: Color(0xFF656D76),
          iconColor: Color(0xFF656D76),
          icon: Icons.edit_outlined,
          label: 'Draft',
        );
    }
  }
}

/// Configuration for status badge appearance
class _StatusConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final IconData icon;
  final String label;

  const _StatusConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.icon,
    required this.label,
  });
}
