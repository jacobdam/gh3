import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'user_details_viewmodel.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserDetailsViewModel viewModel;

  const UserDetailsScreen({super.key, required this.viewModel});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late final UserDetailsViewModel _viewModel;

  void _onViewModelChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel.isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => _handleBackNavigation(context),
          ),
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_viewModel.error != null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => _handleBackNavigation(context),
          ),
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _viewModel.error!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _viewModel.refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final user = _viewModel.user;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => _handleBackNavigation(context),
          ),
          title: const Text('User not found'),
        ),
        body: const Center(
          child: Text('User not found'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            leading: BackButton(
              onPressed: () => _handleBackNavigation(context),
            ),
            title: Text('@${_viewModel.login}'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 80, // Reduced padding to prevent overflow
                  bottom: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Use minimum space needed
                  children: [
                    CircleAvatar(
                      backgroundImage: user.avatarUrl.value.isNotEmpty 
                          ? NetworkImage(user.avatarUrl.value)
                          : null,
                      backgroundColor: _getAvatarColor(_viewModel.login),
                      radius: 32, // Reduced radius to fit better
                      child: user.avatarUrl.value.isEmpty
                          ? Text(
                              _viewModel.login.isNotEmpty 
                                  ? _viewModel.login[0].toUpperCase() 
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20, // Reduced font size
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 8), // Reduced spacing
                    Flexible(
                      child: Text(
                        user.name ?? _viewModel.login,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '@${_viewModel.login}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14, // Reduced font size
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Placeholder content - will be replaced in future tasks
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    if (user.bio != null && user.bio!.isNotEmpty) ...[
                      Text(
                        user.bio!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (user.location != null && user.location!.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 8),
                          Text(user.location!),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (user.company != null && user.company!.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.business, size: 16),
                          const SizedBox(width: 8),
                          Text(user.company!),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          context,
                          'Repositories',
                          user.repositories.totalCount,
                          Icons.folder,
                        ),
                        _buildStat(
                          context,
                          'Followers',
                          user.followers.totalCount,
                          Icons.people,
                        ),
                        _buildStat(
                          context,
                          'Following',
                          user.following.totalCount,
                          Icons.person_add,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go('/');
    }
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
