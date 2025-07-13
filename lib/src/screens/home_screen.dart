import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  final AuthViewModel authViewModel;

  const HomeScreen({super.key, required this.authViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.waving_hand,
                      size: 32,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back!',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Discover repositories from people you follow',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Following Section
            Text(
              'Following',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: _sampleUsers.length,
                itemBuilder: (context, index) {
                  final user = _sampleUsers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getUserAvatarColor(user['login']!),
                        child: Text(
                          user['login']![0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        user['login']!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user['name']!.isNotEmpty)
                            Text(
                              user['name']!,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.folder,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${user['repos']} repositories',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.people,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${user['followers']} followers',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        context.push('/${user['login']}');
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

  Color _getUserAvatarColor(String login) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[login.hashCode % colors.length];
  }

  // Sample users data for placeholder
  static const List<Map<String, String>> _sampleUsers = [
    {
      'login': 'torvalds',
      'name': 'Linus Torvalds',
      'repos': '25',
      'followers': '210K',
    },
    {
      'login': 'octocat',
      'name': 'The Octocat',
      'repos': '8',
      'followers': '9.2K',
    },
    {
      'login': 'gaearon',
      'name': 'Dan Abramov',
      'repos': '118',
      'followers': '89K',
    },
    {
      'login': 'addyosmani',
      'name': 'Addy Osmani',
      'repos': '442',
      'followers': '35K',
    },
    {
      'login': 'sindresorhus',
      'name': 'Sindre Sorhus',
      'repos': '1.2K',
      'followers': '52K',
    },
    {
      'login': 'tj',
      'name': 'TJ Holowaychuk',
      'repos': '289',
      'followers': '28K',
    },
    {
      'login': 'defunkt',
      'name': 'Chris Wanstrath',
      'repos': '107',
      'followers': '21K',
    },
    {
      'login': 'mojombo',
      'name': 'Tom Preston-Werner',
      'repos': '62',
      'followers': '22K',
    },
    {
      'login': 'kentcdodds',
      'name': 'Kent C. Dodds',
      'repos': '234',
      'followers': '31K',
    },
    {'login': 'wesbos', 'name': 'Wes Bos', 'repos': '156', 'followers': '18K'},
  ];
}
