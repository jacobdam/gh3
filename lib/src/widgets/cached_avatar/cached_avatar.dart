import 'package:flutter/material.dart';

/// A cached avatar widget that provides optimized image loading and caching for user avatars.
/// Uses Flutter's built-in image caching with enhanced error handling and loading states.
class CachedAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String? fallbackText;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showLoadingIndicator;

  const CachedAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.fallbackText,
    this.backgroundColor,
    this.onTap,
    this.showLoadingIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final widget = CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? _getDefaultBackgroundColor(context),
      child: _buildAvatarContent(context),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: widget);
    }

    return widget;
  }

  Widget _buildAvatarContent(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallbackContent(context);
    }

    return ClipOval(
      child: Image.network(
        imageUrl!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        // Enhanced caching configuration
        cacheWidth: (radius * 2 * MediaQuery.of(context).devicePixelRatio)
            .round(),
        cacheHeight: (radius * 2 * MediaQuery.of(context).devicePixelRatio)
            .round(),
        loadingBuilder: showLoadingIndicator
            ? (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: radius * 2,
                  height: radius * 2,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              }
            : null,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackContent(context);
        },
      ),
    );
  }

  Widget _buildFallbackContent(BuildContext context) {
    final fallbackChar = _getFallbackCharacter();
    final fontSize = radius * 0.6; // Scale font size based on radius

    return Text(
      fallbackChar,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }

  String _getFallbackCharacter() {
    if (fallbackText != null && fallbackText!.isNotEmpty) {
      return fallbackText![0].toUpperCase();
    }
    return '?';
  }

  Color _getDefaultBackgroundColor(BuildContext context) {
    if (backgroundColor != null) {
      return backgroundColor!;
    }

    // Generate a consistent color based on fallback text
    if (fallbackText != null && fallbackText!.isNotEmpty) {
      return _generateColorFromText(fallbackText!);
    }

    return Theme.of(context).primaryColor;
  }

  Color _generateColorFromText(String text) {
    const colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
    ];

    final hash = text.hashCode;
    return colors[hash.abs() % colors.length];
  }
}

/// Factory methods for CachedAvatar
class CachedAvatarFactory {
  static CachedAvatar fromUserData({
    String? avatarUrl,
    String? login,
    String? name,
    double radius = 20,
    Color? backgroundColor,
    VoidCallback? onTap,
    bool showLoadingIndicator = false,
  }) {
    return CachedAvatar(
      imageUrl: avatarUrl,
      radius: radius,
      fallbackText: name ?? login ?? '?',
      backgroundColor: backgroundColor,
      onTap: onTap,
      showLoadingIndicator: showLoadingIndicator,
    );
  }
}
