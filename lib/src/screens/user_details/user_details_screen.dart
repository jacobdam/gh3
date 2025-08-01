import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'user_details_viewmodel.dart';
import '../../widgets/user_stats_row/user_stats_row.dart';
import '../../widgets/user_profile/user_profile.dart';
import '../../widgets/user_status_card/user_status_card.dart';
import '../../widgets/skeleton_loading/skeleton_loading.dart';
import '../../widgets/cached_avatar/cached_avatar.dart';
import '../user_repositories/user_repositories_route.dart';
import '../user_starred/user_starred_route.dart';
import '../user_organizations/user_organizations_route.dart';

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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              leading: BackButton(
                onPressed: () => _handleBackNavigation(context),
              ),
              title: const SkeletonLoading(height: 16, width: 100),
              flexibleSpace: const FlexibleSpaceBar(
                background: UserHeaderSkeleton(),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Profile skeleton
                      UserProfileSkeleton(),
                      SizedBox(height: 16),
                      // User Stats skeleton
                      UserStatsRowSkeleton(),
                      SizedBox(height: 16),
                      // Navigation tiles skeleton
                      NavigationTileSkeleton(
                        icon: Icons.folder_outlined,
                        title: 'Repositories',
                      ),
                      NavigationTileSkeleton(
                        icon: Icons.star_outline,
                        title: 'Starred',
                      ),
                      NavigationTileSkeleton(
                        icon: Icons.business_outlined,
                        title: 'Organizations',
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

    if (_viewModel.error != null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => _handleBackNavigation(context)),
          title: Text(_getErrorTitle()),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getErrorIcon(),
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 24),
                Text(
                  _getErrorTitle(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _getErrorMessage(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (!_viewModel.isUserNotFoundError) ...[
                  ElevatedButton.icon(
                    onPressed: () => _viewModel.refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                  const SizedBox(height: 16),
                ],
                TextButton(
                  onPressed: () => _handleBackNavigation(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final user = _viewModel.user;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => _handleBackNavigation(context)),
          title: const Text('User not found'),
        ),
        body: const Center(child: Text('User not found')),
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
                    CachedAvatarFactory.fromUserData(
                      avatarUrl: user.avatarUrl.value.isNotEmpty
                          ? user.avatarUrl.value
                          : null,
                      login: _viewModel.login,
                      name: user.name,
                      radius: 32,
                      backgroundColor: _getAvatarColor(_viewModel.login),
                      showLoadingIndicator: true,
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
                    UserProfile.fromFragment(
                      user,
                      showCard: false,
                      showStats: false,
                    ),
                    const SizedBox(height: 16),
                    // User Status Card (only shown if user has a status)
                    if (_viewModel.statusMessage != null &&
                        _viewModel.statusMessage!.isNotEmpty)
                      Column(
                        children: [
                          UserStatusCard(
                            message: _viewModel.statusMessage,
                            emoji: _viewModel.statusEmoji,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    // Follower/Following stats with interactive navigation
                    if (_viewModel.isUserLoading)
                      const UserStatsRowSkeleton()
                    else
                      UserStatsRow.fromFragment(
                        user,
                        onFollowersPressed: () {
                          // TODO: Navigate to followers screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Followers navigation not implemented yet',
                              ),
                            ),
                          );
                        },
                        onFollowingPressed: () {
                          // TODO: Navigate to following screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Following navigation not implemented yet',
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                    // Navigation tiles with loading states
                    _buildNavigationTile(
                      context,
                      title: 'Repositories',
                      icon: Icons.folder_outlined,
                      count: _viewModel.repositoriesCount,
                      isLoading: _viewModel.isUserLoading,
                      onTap: () {
                        UserRepositoriesRoute(_viewModel.login).push(context);
                      },
                    ),
                    _buildNavigationTile(
                      context,
                      title: 'Starred',
                      icon: Icons.star_outline,
                      count: _viewModel.starredRepositoriesCount,
                      isLoading: _viewModel.isUserLoading,
                      onTap: () {
                        UserStarredRoute(_viewModel.login).push(context);
                      },
                    ),
                    _buildNavigationTile(
                      context,
                      title: 'Organizations',
                      icon: Icons.business_outlined,
                      count: _viewModel.organizationsCount,
                      isLoading: _viewModel.isUserLoading,
                      onTap: () {
                        UserOrganizationsRoute(_viewModel.login).push(context);
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
    bool isLoading = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              _formatCount(count),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
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

  String _getErrorTitle() {
    if (_viewModel.isUserNotFoundError) {
      return 'User Not Found';
    }
    if (_viewModel.isNetworkError) {
      return 'Connection Problem';
    }
    if (_viewModel.isAuthError) {
      return 'Access Denied';
    }
    return 'Something Went Wrong';
  }

  String _getErrorMessage() {
    if (_viewModel.isUserNotFoundError) {
      return 'The user "@${_viewModel.login}" does not exist or may have been deleted.';
    }
    if (_viewModel.isNetworkError) {
      return 'Please check your internet connection and try again.';
    }
    if (_viewModel.isAuthError) {
      return 'You don\'t have permission to view this user\'s profile.';
    }
    return _viewModel.error ??
        'An unexpected error occurred. Please try again.';
  }

  IconData _getErrorIcon() {
    if (_viewModel.isUserNotFoundError) {
      return Icons.person_off;
    }
    if (_viewModel.isNetworkError) {
      return Icons.wifi_off;
    }
    if (_viewModel.isAuthError) {
      return Icons.lock;
    }
    return Icons.error_outline;
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
