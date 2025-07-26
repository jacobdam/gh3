import 'package:flutter/material.dart';

/// Placeholder screen for displaying a user's starred repositories
class UserStarredScreen extends StatelessWidget {
  final String login;

  const UserStarredScreen({super.key, required this.login});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$login\'s Starred')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Starred Repositories',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This is a placeholder screen for starred repositories.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
