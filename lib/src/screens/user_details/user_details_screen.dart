import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'user_details_viewmodel.dart';
import '../../widgets/user_stats_row/user_stats_row.dart';
import '../../widgets/user_profile/user_profile.dart';

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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile information (bio, company, location)
                    UserProfile.fromFragment(user, showCard: false, showStats: false),
                    const SizedBox(height: 16),
                    // Follower/Following stats with interactive navigation
                    UserStatsRow.fromFragment(
                      user,
                      onFollowersPressed: () {
                        // TODO: Navigate to followers screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Followers navigation not implemented yet')),
                        );
                      },
                      onFollowingPressed: () {
                        // TODO: Navigate to following screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Following navigation not implemented yet')),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Navigation tiles
                    _buildNavigationTile(
                      context,
                      title: 'Repositories',
                      icon: Icons.folder_outlined,
                      count: _viewModel.repositoriesCount,
                      onTap: () {
                        // TODO: Navigate to user repositories
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Repositories navigation not implemented yet')),
                        );
                      },
                    ),
                    _buildNavigationTile(
                      context,
                      title: 'Starred',
                      icon: Icons.star_outline,
                      count: _viewModel.starredRepositoriesCount,
                      onTap: () {
                        // TODO: Navigate to starred repositories
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Starred repositories navigation not implemented yet')),
                        );
                      },
                    ),
                    _buildNavigationTile(
                      context,
                      title: 'Organizations',
                      icon: Icons.business_outlined,
                      count: _viewModel.organizationsCount,
                      onTap: () {
                        // TODO: Navigate to user organizations
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Organizations navigation not implemented yet')),
                        );
                      },
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

  Widget _buildNavigationTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatCount(count),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
          ),
        ],
      ),
      onTap: onTap,
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
