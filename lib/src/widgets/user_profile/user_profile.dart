import 'package:flutter/material.dart';
import '__generated__/user_profile.data.gql.dart';

class UserProfile extends StatelessWidget {
  final String login;
  final String? name;
  final String? bio;
  final String? location;
  final String? company;
  final String avatarUrl;
  final String? websiteUrl;
  final int repositoryCount;
  final int followerCount;
  final int followingCount;
  final DateTime createdAt;

  const UserProfile({
    super.key,
    required this.login,
    this.name,
    this.bio,
    this.location,
    this.company,
    required this.avatarUrl,
    this.websiteUrl,
    required this.repositoryCount,
    required this.followerCount,
    required this.followingCount,
    required this.createdAt,
  });

  factory UserProfile.fromFragment(GUserProfileFragment fragment, {Key? key}) {
    return UserProfile(
      key: key,
      login: fragment.login,
      name: fragment.name,
      bio: fragment.bio,
      location: fragment.location,
      company: fragment.company,
      avatarUrl: fragment.avatarUrl.value,
      websiteUrl: fragment.websiteUrl?.value,
      repositoryCount: fragment.repositories.totalCount,
      followerCount: fragment.followers.totalCount,
      followingCount: fragment.following.totalCount,
      createdAt: DateTime.parse(fragment.createdAt.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: _getAvatarColor(login),
                  radius: 40,
                  child: avatarUrl.isEmpty
                      ? Text(
                          login.isNotEmpty ? login[0].toUpperCase() : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? login,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '@$login',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      if (location != null && location!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              location!,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                      if (company != null && company!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              company!,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (bio != null && bio!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(bio!, style: const TextStyle(fontSize: 16)),
            ],
            if (websiteUrl != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.link, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      websiteUrl!,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  context,
                  'Repositories',
                  repositoryCount,
                  Icons.folder,
                ),
                _buildStat(context, 'Followers', followerCount, Icons.people),
                _buildStat(
                  context,
                  'Following',
                  followingCount,
                  Icons.person_add,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Joined ${_formatDate(createdAt)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    int count,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          _formatCount(count),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
