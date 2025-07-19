import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/user_details_viewmodel.dart';

class UserDetailsScreen extends StatefulWidget {
  final String login;
  final UserDetailsViewModel viewModel;

  const UserDetailsScreen({
    super.key,
    required this.login,
    required this.viewModel,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
    _scrollController.addListener(_onScroll);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.refresh();
    });
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.viewModel.loadMoreRepositories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('@${widget.login}'),
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
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleSortSelection(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'updated_desc',
                child: Text('Recently updated'),
              ),
              const PopupMenuItem(
                value: 'created_desc',
                child: Text('Recently created'),
              ),
              const PopupMenuItem(
                value: 'pushed_desc',
                child: Text('Recently pushed'),
              ),
              const PopupMenuItem(
                value: 'full_name_asc',
                child: Text('Name (A-Z)'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: widget.viewModel.refresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Card
              _buildUserProfileCard(),
              const SizedBox(height: 16),

              // Repositories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Repositories',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.viewModel.isLoadingRepositories &&
                      widget.viewModel.repositories.isEmpty)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Repositories Error
              if (widget.viewModel.repositoriesError != null)
                _buildErrorCard(
                  widget.viewModel.repositoriesError!,
                  widget.viewModel.clearRepositoriesError,
                ),

              // Repositories List
              Expanded(child: _buildRepositoriesList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileCard() {
    final user = widget.viewModel.user;
    final isLoading = widget.viewModel.isLoadingUser;
    final error = widget.viewModel.userError;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (error != null)
              _buildErrorCard(error, widget.viewModel.clearUserError)
            else ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: user?.avatarUrl != null
                        ? NetworkImage(user!.avatarUrl)
                        : null,
                    backgroundColor: Colors.grey[300],
                    onBackgroundImageError: (_, _) {},
                    child: user?.avatarUrl == null || user!.avatarUrl.isEmpty
                        ? Icon(Icons.person, size: 40, color: Colors.grey[600])
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.login ?? widget.login,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        if (isLoading)
                          Text(
                            'Loading user details...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else if (user?.name != null && user!.name!.isNotEmpty)
                          Text(
                            user.name!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        if (user?.bio != null && user!.bio!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            user.bio!,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                        if (user?.location != null &&
                            user!.location!.isNotEmpty) ...[
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
                                user.location!,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                        if (user?.company != null &&
                            user!.company!.isNotEmpty) ...[
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
                                user.company!,
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(
                    'Repositories',
                    isLoading
                        ? 'Loading...'
                        : _formatNumber(user?.publicRepos ?? 0),
                  ),
                  _buildStatColumn(
                    'Followers',
                    isLoading
                        ? 'Loading...'
                        : _formatNumber(user?.followers ?? 0),
                  ),
                  _buildStatColumn(
                    'Following',
                    isLoading
                        ? 'Loading...'
                        : _formatNumber(user?.following ?? 0),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRepositoriesList() {
    if (widget.viewModel.isRepositoriesEmpty &&
        !widget.viewModel.isLoadingRepositories) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No repositories found',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'This user hasn\'t created any public repositories yet',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount:
          widget.viewModel.repositories.length +
          (widget.viewModel.isLoadingRepositories ? 1 : 0),
      itemBuilder: (context, index) {
        // Loading indicator at the end
        if (index >= widget.viewModel.repositories.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final repo = widget.viewModel.repositories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: Icon(
              repo.private ? Icons.lock : Icons.folder,
              color: repo.private ? Colors.orange : Colors.blue,
            ),
            title: Text(
              repo.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (repo.description != null &&
                    repo.description!.isNotEmpty) ...[
                  Text(
                    repo.description!,
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    if (repo.language != null && repo.language!.isNotEmpty) ...[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getLanguageColor(repo.language!),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        repo.language!,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 16),
                    ],
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      _formatNumber(repo.stargazersCount),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.fork_right, size: 16, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(
                      _formatNumber(repo.forksCount),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              context.push('/${widget.login}/${repo.name}');
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildErrorCard(String error, VoidCallback onDismiss) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(error, style: TextStyle(color: Colors.red.shade700)),
          ),
          TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
        ],
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

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  void _handleSortSelection(String value) {
    final parts = value.split('_');
    final sortBy = parts[0];
    final direction = parts[1];
    widget.viewModel.changeSorting(sortBy, direction);
  }
}
