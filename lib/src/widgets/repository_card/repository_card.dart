import 'package:flutter/material.dart';
import '__generated__/repository_card.data.gql.dart';

class RepositoryCard extends StatelessWidget {
  final String name;
  final String? description;
  final String? primaryLanguageName;
  final String? primaryLanguageColor;
  final int stargazerCount;
  final int forkCount;
  final VoidCallback? onTap;

  const RepositoryCard({
    super.key,
    required this.name,
    this.description,
    this.primaryLanguageName,
    this.primaryLanguageColor,
    required this.stargazerCount,
    required this.forkCount,
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
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
}

