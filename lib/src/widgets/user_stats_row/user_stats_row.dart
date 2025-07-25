import 'package:flutter/material.dart';
import '../../screens/user_details/__generated__/user_details_viewmodel.data.gql.dart';

class UserStatsRow extends StatelessWidget {
  final int followerCount;
  final int followingCount;
  final VoidCallback? onFollowersPressed;
  final VoidCallback? onFollowingPressed;

  const UserStatsRow({
    super.key,
    required this.followerCount,
    required this.followingCount,
    this.onFollowersPressed,
    this.onFollowingPressed,
  });

  factory UserStatsRow.fromFragment(
    GGetUserDetailsData_user fragment, {
    VoidCallback? onFollowersPressed,
    VoidCallback? onFollowingPressed,
  }) {
    return UserStatsRow(
      followerCount: fragment.followers.totalCount,
      followingCount: fragment.following.totalCount,
      onFollowersPressed: onFollowersPressed,
      onFollowingPressed: onFollowingPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatButton(
            context,
            'Followers',
            followerCount,
            Icons.people,
            onFollowersPressed,
          ),
          _buildStatButton(
            context,
            'Following',
            followingCount,
            Icons.person_add,
            onFollowingPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildStatButton(
    BuildContext context,
    String label,
    int count,
    IconData icon,
    VoidCallback? onPressed,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: onPressed != null 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey[600],
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                _formatCount(count),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: onPressed != null 
                      ? Theme.of(context).primaryColor 
                      : Colors.black87,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      double value = count / 1000000;
      if (value >= 1000) {
        // Handle very large numbers (billions)
        return '${(value / 1000).toStringAsFixed(1)}B';
      }
      return value == value.truncate() 
          ? '${value.truncate()}M' 
          : '${value.toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      double value = count / 1000;
      if (value >= 1000) {
        // This handles the edge case where we get 1000k -> should be 1M
        return '1M';
      }
      return value == value.truncate() 
          ? '${value.truncate()}k' 
          : '${value.toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}