import 'package:flutter/material.dart';
import '../layouts/gh_screen_template.dart';
import '../widgets/gh_entity_header.dart';
import '../widgets/gh_navigation_grid.dart';
import '../components/gh_card.dart';
import '../components/gh_chip.dart';
import '../components/gh_button.dart';
import '../data/fake_data_service.dart';
import '../tokens/gh_tokens.dart';
import '../navigation/navigation_service.dart';
import '../utils/date_formatter.dart';

/// Repository details example screen showing comprehensive repository information
/// with header, metadata, navigation, and README content.
class RepositoryDetailsExample extends StatefulWidget {
  /// Repository owner
  final String owner;

  /// Repository name
  final String name;

  const RepositoryDetailsExample({
    super.key,
    required this.owner,
    required this.name,
  });

  @override
  State<RepositoryDetailsExample> createState() =>
      _RepositoryDetailsExampleState();
}

class _RepositoryDetailsExampleState extends State<RepositoryDetailsExample> {
  final FakeDataService _dataService = FakeDataService();
  late FakeRepository _repository;
  bool _isLoading = true;
  String? _error;

  // Action states
  bool _isStarred = false;
  bool _isWatched = false;
  bool _isForked = false;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _loadRepositoryData();
  }

  Future<void> _loadRepositoryData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Find repository by owner and name
      final repositories = _dataService.getRepositories(count: 50);
      final repo = repositories.firstWhere(
        (r) =>
            r.owner.toLowerCase() == widget.owner.toLowerCase() &&
            r.name.toLowerCase() == widget.name.toLowerCase(),
        orElse: () =>
            repositories.first.copyWith(owner: widget.owner, name: widget.name),
      );

      _repository = repo;

      // Initialize action states (simulated user preferences)
      _isStarred = false;
      _isWatched = false;
      _isForked = false;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load repository details';
      });
    }
  }

  Future<void> _onStarTap() async {
    if (_actionInProgress) return;

    setState(() {
      _actionInProgress = true;
      _isStarred = !_isStarred;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isStarred
                  ? 'Starred ${widget.owner}/${widget.name}'
                  : 'Unstarred ${widget.owner}/${widget.name}',
            ),
          ),
        );
      }
    } catch (e) {
      // Rollback on error
      setState(() {
        _isStarred = !_isStarred;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action failed. Please try again.')),
        );
      }
    } finally {
      setState(() {
        _actionInProgress = false;
      });
    }
  }

  Future<void> _onWatchTap() async {
    if (_actionInProgress) return;

    setState(() {
      _actionInProgress = true;
      _isWatched = !_isWatched;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isWatched
                  ? 'Watching ${widget.owner}/${widget.name}'
                  : 'Unwatched ${widget.owner}/${widget.name}',
            ),
          ),
        );
      }
    } catch (e) {
      // Rollback on error
      setState(() {
        _isWatched = !_isWatched;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action failed. Please try again.')),
        );
      }
    } finally {
      setState(() {
        _actionInProgress = false;
      });
    }
  }

  Future<void> _onForkTap() async {
    if (_actionInProgress) return;

    setState(() {
      _actionInProgress = true;
      _isForked = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Forked ${widget.owner}/${widget.name}')),
        );
      }
    } catch (e) {
      // Rollback on error
      setState(() {
        _isForked = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fork failed. Please try again.')),
        );
      }
    } finally {
      setState(() {
        _actionInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('${widget.owner}/${widget.name}')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: GHTokens.spacing16),
              Text(
                _error!,
                style: GHTokens.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: GHTokens.spacing24),
              ElevatedButton(
                onPressed: _loadRepositoryData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return GHScreenTemplate(
      title: '${widget.owner}/${widget.name}',
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Share ${widget.owner}/${widget.name}')),
            );
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$value action')));
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'Pin repository',
              child: Text('Pin repository'),
            ),
            const PopupMenuItem(
              value: 'Add to list',
              child: Text('Add to list'),
            ),
            const PopupMenuItem(
              value: 'Report repository',
              child: Text('Report repository'),
            ),
          ],
        ),
      ],
      body: RefreshIndicator(
        onRefresh: _loadRepositoryData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: GHTokens.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Repository header
              _buildRepositoryHeader(),
              const SizedBox(height: GHTokens.spacing16),

              // Action buttons
              _buildActionButtons(),
              const SizedBox(height: GHTokens.spacing24),

              // Repository metadata
              _buildRepositoryMetadata(),
              const SizedBox(height: GHTokens.spacing24),

              // Navigation grid
              _buildNavigationGrid(),
              const SizedBox(height: GHTokens.spacing24),

              // README section placeholder
              _buildReadmeSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepositoryHeader() {
    return GHEntityHeader(
      title: '${widget.owner}/${widget.name}',
      subtitle: _repository.description,
      avatar: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          _repository.isPrivate ? Icons.lock : Icons.folder,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      stats: GHEntityStats.repository(
        stars: _repository.starCount,
        forks: _repository.forkCount,
        watchers: _repository.starCount ~/ 10,
        language: _repository.language,
      ),
      isPrivate: _repository.isPrivate,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GHButton(
            label: _isStarred ? 'Starred' : 'Star',
            icon: _isStarred ? Icons.star : Icons.star_border,
            style: _isStarred ? GHButtonStyle.secondary : GHButtonStyle.primary,
            isLoading: _actionInProgress,
            onPressed: _onStarTap,
          ),
        ),
        const SizedBox(width: GHTokens.spacing8),

        Expanded(
          child: GHButton(
            label: _isWatched ? 'Watching' : 'Watch',
            icon: _isWatched ? Icons.visibility : Icons.visibility_outlined,
            style: GHButtonStyle.secondary,
            isLoading: _actionInProgress,
            onPressed: _onWatchTap,
          ),
        ),
        const SizedBox(width: GHTokens.spacing8),

        Expanded(
          child: GHButton(
            label: _isForked ? 'Forked' : 'Fork',
            icon: Icons.fork_right,
            style: GHButtonStyle.secondary,
            isLoading: _actionInProgress,
            onPressed: _onForkTap,
          ),
        ),
      ],
    );
  }

  Widget _buildRepositoryMetadata() {
    return GHCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: GHTokens.titleMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: GHTokens.spacing12),

          // Topics
          if (_repository.topics.isNotEmpty) ...[
            Text(
              'Topics',
              style: GHTokens.labelLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: GHTokens.spacing8),
            Wrap(
              spacing: GHTokens.spacing8,
              runSpacing: GHTokens.spacing4,
              children: _repository.topics.map((topic) {
                return GHChip(
                  label: topic,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Search topic: $topic')),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: GHTokens.spacing16),
          ],

          // Website
          if (_repository.homepage != null) ...[
            _buildMetadataItem(
              icon: Icons.link,
              label: 'Website',
              value: _repository.homepage!,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Open ${_repository.homepage}')),
                );
              },
            ),
            const SizedBox(height: GHTokens.spacing8),
          ],

          // License
          if (_repository.license != null) ...[
            _buildMetadataItem(
              icon: Icons.balance,
              label: 'License',
              value: _repository.license!,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('View license details')),
                );
              },
            ),
            const SizedBox(height: GHTokens.spacing8),
          ],

          // Last updated
          _buildMetadataItem(
            icon: Icons.schedule,
            label: 'Updated',
            value: DateFormatter.formatRelative(_repository.lastUpdated),
          ),
          const SizedBox(height: GHTokens.spacing8),

          // Created date
          if (_repository.createdAt != null)
            _buildMetadataItem(
              icon: Icons.calendar_today,
              label: 'Created',
              value: DateFormatter.formatRelative(_repository.createdAt!),
            ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(GHTokens.radius4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: GHTokens.spacing8),
            Text(
              label,
              style: GHTokens.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: GHTokens.spacing8),
            Expanded(
              child: Text(
                value,
                style: GHTokens.bodyMedium.copyWith(
                  color: onTap != null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.open_in_new,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationGrid() {
    return GHCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore',
            style: GHTokens.titleMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: GHTokens.spacing16),

          GHNavigationGrid.twoByTwo(
            items: GHNavigationItems.repository(
              issues: _repository.issues.length,
              pullRequests: _repository.issues
                  .where((i) => i.isPullRequest)
                  .length,
              actions: 12, // Simulated actions count
              onCodeTap: () {
                NavigationService.navigateToRepositoryTree(
                  widget.owner,
                  widget.name,
                );
              },
              onIssuesTap: () {
                NavigationService.navigateToIssues(widget.owner, widget.name);
              },
              onPullRequestsTap: () {
                NavigationService.navigateToPulls(widget.owner, widget.name);
              },
              onActionsTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to Actions')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadmeSection() {
    return GHCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: GHTokens.spacing8),
              Text(
                'README.md',
                style: GHTokens.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: GHTokens.spacing16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(GHTokens.spacing16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(GHTokens.radius8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '# ${widget.name}',
                  style: GHTokens.titleLarge.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: GHTokens.spacing12),

                Text(
                  _repository.description,
                  style: GHTokens.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: GHTokens.spacing16),

                Text(
                  '## Installation\n\n```bash\nnpm install ${widget.name}\n```\n\n## Usage\n\nThis is a sample README content for demonstration purposes. In a real implementation, this would be rendered from actual markdown content.',
                  style: GHTokens.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: GHTokens.spacing16),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('View full README')));
            },
            icon: const Icon(Icons.open_in_full),
            label: const Text('View full README'),
          ),
        ],
      ),
    );
  }
}
