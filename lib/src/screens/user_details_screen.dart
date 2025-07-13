import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserDetailsScreen extends StatelessWidget {
  final String login;

  const UserDetailsScreen({super.key, required this.login});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('@$login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                login,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Loading user details...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Repositories', 'Loading...'),
                        _buildStatColumn('Followers', 'Loading...'),
                        _buildStatColumn('Following', 'Loading...'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Repositories Section
            Text(
              'Repositories',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: _sampleRepositories.length,
                itemBuilder: (context, index) {
                  final repo = _sampleRepositories[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.folder, color: Colors.blue),
                      title: Text(
                        repo['name']!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (repo['description']!.isNotEmpty)
                            Text(
                              repo['description']!,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (repo['language']!.isNotEmpty) ...[
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getLanguageColor(repo['language']!),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  repo['language']!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 16),
                              ],
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                repo['stars']!,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.fork_right,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                repo['forks']!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        context.push('/$login/${repo['name']}');
                      },
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Color _getLanguageColor(String language) {
    switch (language.toLowerCase()) {
      case 'dart':
        return Colors.blue;
      case 'javascript':
        return Colors.yellow;
      case 'typescript':
        return Colors.blue[700]!;
      case 'python':
        return Colors.green;
      case 'java':
        return Colors.orange;
      case 'swift':
        return Colors.orange[700]!;
      case 'kotlin':
        return Colors.purple;
      case 'go':
        return Colors.cyan;
      case 'rust':
        return Colors.brown;
      case 'c++':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  // Sample repository data for placeholder
  static const List<Map<String, String>> _sampleRepositories = [
    {
      'name': 'awesome-flutter-app',
      'description': 'A beautiful Flutter application with modern UI design',
      'language': 'Dart',
      'stars': '142',
      'forks': '23',
    },
    {
      'name': 'react-dashboard',
      'description': 'Modern dashboard built with React and TypeScript',
      'language': 'TypeScript',
      'stars': '89',
      'forks': '12',
    },
    {
      'name': 'python-data-analysis',
      'description': 'Data analysis tools and utilities for Python',
      'language': 'Python',
      'stars': '67',
      'forks': '8',
    },
    {
      'name': 'mobile-game',
      'description': 'Cross-platform mobile game built with Flutter',
      'language': 'Dart',
      'stars': '234',
      'forks': '45',
    },
    {
      'name': 'web-scraper',
      'description': 'Efficient web scraping tool with async support',
      'language': 'Python',
      'stars': '156',
      'forks': '31',
    },
    {
      'name': 'ui-components',
      'description': 'Reusable UI components library',
      'language': 'JavaScript',
      'stars': '98',
      'forks': '19',
    },
    {
      'name': 'api-server',
      'description': 'RESTful API server with authentication',
      'language': 'Go',
      'stars': '203',
      'forks': '42',
    },
    {
      'name': 'machine-learning-models',
      'description': 'Collection of ML models and experiments',
      'language': 'Python',
      'stars': '445',
      'forks': '87',
    },
  ];
}
