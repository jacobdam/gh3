import 'package:flutter/material.dart';
import '__generated__/user_card.data.gql.dart';

class UserCard extends StatelessWidget {
  final String login;
  final String? name;
  final String? bio;
  final String avatarUrl;
  final int repositoryCount;
  final int followerCount;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.login,
    this.name,
    this.bio,
    required this.avatarUrl,
    required this.repositoryCount,
    required this.followerCount,
    this.onTap,
  });

  factory UserCard.fromFragment(
    GUserCardFragment fragment, {
    Key? key,
    VoidCallback? onTap,
  }) {
    return UserCard(
      key: key,
      login: fragment.login,
      name: fragment.name,
      bio: fragment.bio,
      avatarUrl: fragment.avatarUrl.value,
      repositoryCount: fragment.repositories.totalCount,
      followerCount: fragment.followers.totalCount,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(avatarUrl),
          backgroundColor: _getAvatarColor(login),
          child: avatarUrl.isEmpty
              ? Text(
                  login.isNotEmpty ? login[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        title: Text(
          name ?? login,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('@$login'),
            if (bio != null && bio!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                bio!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.folder, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$repositoryCount repos',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$followerCount followers',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getAvatarColor(String login) {
    // Generate a consistent color based on username
    final colors = [
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

    final hash = login.hashCode;
    return colors[hash.abs() % colors.length];
  }
}

