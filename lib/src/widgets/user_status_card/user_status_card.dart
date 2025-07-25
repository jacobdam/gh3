import 'package:flutter/material.dart';
import '../../screens/user_details/__generated__/user_details_viewmodel.data.gql.dart';

class UserStatusCard extends StatelessWidget {
  final String? message;
  final String? emoji;

  const UserStatusCard({
    super.key,
    this.message,
    this.emoji,
  });

  factory UserStatusCard.fromFragment(GUserStatusFragment_status fragment) {
    return UserStatusCard(
      message: fragment.message,
      emoji: fragment.emoji,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Don't render anything if there's no status message
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (emoji != null && emoji!.isNotEmpty) ...[
              Text(
                emoji!,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}