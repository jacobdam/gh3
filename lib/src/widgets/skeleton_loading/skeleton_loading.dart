import 'package:flutter/material.dart';

/// A skeleton loading widget that creates a shimmer-like effect using built-in Flutter components.
class SkeletonLoading extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoading({
    super.key,
    required this.height,
    this.width,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor =
        widget.baseColor ??
        (theme.brightness == Brightness.light
            ? Colors.grey[300]!
            : Colors.grey[700]!);
    final highlightColor =
        widget.highlightColor ??
        (theme.brightness == Brightness.light
            ? Colors.grey[100]!
            : Colors.grey[600]!);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [0.0, 0.5, 1.0],
              transform: GradientRotation(_animation.value * 3.14159),
            ),
          ),
        );
      },
    );
  }
}

/// A skeleton loading widget specifically for user profile sections
class UserProfileSkeleton extends StatelessWidget {
  const UserProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bio skeleton
        const SkeletonLoading(height: 16, width: double.infinity),
        const SizedBox(height: 8),
        const SkeletonLoading(height: 16, width: 200),
        const SizedBox(height: 16),
        // Company and location skeleton
        Row(
          children: [
            Icon(Icons.business, size: 16, color: Colors.grey[400]),
            const SizedBox(width: 8),
            const SkeletonLoading(height: 14, width: 120),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey[400]),
            const SizedBox(width: 8),
            const SkeletonLoading(height: 14, width: 100),
          ],
        ),
      ],
    );
  }
}

/// A skeleton loading widget for user stats row
class UserStatsRowSkeleton extends StatelessWidget {
  const UserStatsRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const SkeletonLoading(height: 20, width: 60),
            const SizedBox(height: 4),
            Text(
              'Followers',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        Column(
          children: [
            const SkeletonLoading(height: 20, width: 60),
            const SizedBox(height: 4),
            Text(
              'Following',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}

/// A skeleton loading widget for navigation list tiles
class NavigationTileSkeleton extends StatelessWidget {
  final IconData icon;
  final String title;

  const NavigationTileSkeleton({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[400]),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SkeletonLoading(height: 16, width: 40),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }
}

/// A skeleton loading widget for the user header in SliverAppBar
class UserHeaderSkeleton extends StatelessWidget {
  const UserHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 80, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar skeleton
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 8),
          // Name skeleton
          const SkeletonLoading(
            height: 20,
            width: 150,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          const SizedBox(height: 4),
          // Username skeleton
          const SkeletonLoading(
            height: 16,
            width: 100,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
    );
  }
}
