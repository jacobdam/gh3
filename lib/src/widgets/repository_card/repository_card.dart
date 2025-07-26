import 'package:flutter/material.dart';
import '__generated__/repository_card.data.gql.dart';
import '../../screens/user_repositories/__generated__/user_repositories_viewmodel.data.gql.dart';

class RepositoryCard extends StatelessWidget {
  final String name;
  final String? description;
  final String? primaryLanguageName;
  final String? primaryLanguageColor;
  final int stargazerCount;
  final int forkCount;
  final DateTime? updatedAt;
  final bool isPrivate;
  final VoidCallback? onTap;

  const RepositoryCard({
    super.key,
    required this.name,
    this.description,
    this.primaryLanguageName,
    this.primaryLanguageColor,
    required this.stargazerCount,
    required this.forkCount,
    this.updatedAt,
    this.isPrivate = false,
    this.onTap,
  });

  factory RepositoryCard.fromFragment(
    GRepositoryCardFragment fragment, {
    Key? key,
    VoidCallback? onTap,
  }) {
    return RepositoryCard(
      key: key,
      name: fragment.name,
      description: fragment.description,
      primaryLanguageName: fragment.primaryLanguage?.name,
      primaryLanguageColor: fragment.primaryLanguage?.color,
      stargazerCount: fragment.stargazerCount,
      forkCount: fragment.forkCount,
      updatedAt: DateTime.parse(fragment.updatedAt.value),
      isPrivate: false, // RepositoryCardFragment doesn't include isPrivate
      onTap: onTap,
    );
  }

  factory RepositoryCard.fromUserRepositoriesFragment(
    GUserRepositoriesFragment fragment, {
    Key? key,
    VoidCallback? onTap,
  }) {
    return RepositoryCard(
      key: key,
      name: fragment.name,
      description: fragment.description,
      primaryLanguageName: fragment.primaryLanguage?.name,
      primaryLanguageColor: fragment.primaryLanguage?.color,
      stargazerCount: fragment.stargazerCount,
      forkCount: fragment.forkCount,
      updatedAt: DateTime.parse(fragment.updatedAt.value),
      isPrivate: fragment.isPrivate,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            if (isPrivate) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.lock,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null && description!.isNotEmpty) ...[
              Text(
                description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                if (primaryLanguageName != null) ...[
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _parseColor(primaryLanguageColor),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    primaryLanguageName!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                ],
                Icon(Icons.star, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$stargazerCount',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.call_split, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$forkCount',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            if (updatedAt != null) ...[
              const SizedBox(height: 4),
              Text(
                'Updated ${_formatRelativeTime(updatedAt!)}',
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _parseColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) {
      return Colors.grey;
    }

    try {
      // Remove # if present and parse as hex
      final hex = colorHex.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
  }
}
