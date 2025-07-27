import 'package:flutter/material.dart';
import '../layouts/gh_screen_template.dart';
import '../layouts/gh_list_template.dart';
import '../widgets/gh_repository_card.dart';
import '../widgets/gh_filter_bar.dart';
import '../data/fake_data_service.dart';
import '../components/gh_card.dart';
import '../components/gh_chip.dart';
import '../tokens/gh_tokens.dart';
import '../navigation/navigation_service.dart';
import '../utils/number_formatter.dart';
import '../utils/debounced_search.dart';

/// User profile example screen showing comprehensive user information
/// with tabbed navigation for repositories, starred, organizations, etc.
class UserProfileExample extends StatefulWidget {
  /// Username to display profile for
  final String username;

  const UserProfileExample({super.key, required this.username});

  @override
  State<UserProfileExample> createState() => _UserProfileExampleState();
}

class _UserProfileExampleState extends State<UserProfileExample>
    with SingleTickerProviderStateMixin {
  final FakeDataService _dataService = FakeDataService();
  late TabController _tabController;
  late FakeUser _user;
  List<FakeRepository> _repositories = [];
  List<FakeRepository> _filteredRepositories = [];
  List<FakeRepository> _starredRepos = [];
  List<FakeRepository> _filteredStarredRepos = [];
  List<String> _organizations = [];
  bool _isLoading = true;
  bool _isFollowing = false;

  // Search and filtering state
  late final DebouncedSearch _repositorySearch;
  late final DebouncedSearch _starredSearch;
  String _repositoryQuery = '';
  String _starredQuery = '';
  String _repositoryFilter = 'all'; // all, sources, forks, archived
  String _starredFilter = 'all';
  String _repositorySortBy = 'updated'; // name, stars, updated
  String _starredSortBy = 'updated';

  // Tab-specific loading states
  bool _repositoriesLoading = false;
  bool _starredLoading = false;
  bool _organizationsLoading = false;

  final List<String> _tabTitles = [
    'Repositories',
    'Starred',
    'Organizations',
    'Projects',
    'Packages',
    'Gists',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Initialize debounced search
    _repositorySearch = DebouncedSearch(onSearch: _onRepositorySearch);
    _starredSearch = DebouncedSearch(onSearch: _onStarredSearch);

    _loadUserData();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      // Load data for the selected tab if not already loaded
      switch (_tabController.index) {
        case 0:
          if (_repositories.isEmpty && !_repositoriesLoading) {
            _loadRepositories();
          }
          break;
        case 1:
          if (_starredRepos.isEmpty && !_starredLoading) {
            _loadStarredRepositories();
          }
          break;
        case 2:
          if (_organizations.isEmpty && !_organizationsLoading) {
            _loadOrganizations();
          }
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _repositorySearch.dispose();
    _starredSearch.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Find user by username or use first user as fallback
    final users = _dataService.getUsers();
    _user = users.firstWhere(
      (user) => user.login == widget.username,
      orElse: () => users.first,
    );

    // Load user's repositories and starred repos
    _repositories = _dataService.getRepositories(count: 10);
    _starredRepos = _dataService.getUserStarredRepos(widget.username, count: 8);

    // Initialize filtered lists
    _applyRepositoryFilters();
    _applyStarredFilters();

    setState(() {
      _isLoading = false;
    });

    // Load initial tab data
    _loadRepositories();
  }

  Future<void> _loadRepositories() async {
    if (_repositoriesLoading) return;

    setState(() {
      _repositoriesLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    _repositories = _dataService.getRepositories(count: 15);
    _applyRepositoryFilters();

    setState(() {
      _repositoriesLoading = false;
    });
  }

  Future<void> _loadStarredRepositories() async {
    if (_starredLoading) return;

    setState(() {
      _starredLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    _starredRepos = _dataService.getUserStarredRepos(
      widget.username,
      count: 12,
    );
    _applyStarredFilters();

    setState(() {
      _starredLoading = false;
    });
  }

  Future<void> _loadOrganizations() async {
    if (_organizationsLoading) return;

    setState(() {
      _organizationsLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    _organizations = _dataService.getUserOrganizations(widget.username);

    setState(() {
      _organizationsLoading = false;
    });
  }

  void _applyRepositoryFilters() {
    var filtered = List<FakeRepository>.from(_repositories);

    // Apply type filter
    switch (_repositoryFilter) {
      case 'sources':
        filtered = filtered
            .where((repo) => !repo.name.contains('fork'))
            .toList();
        break;
      case 'forks':
        filtered = filtered
            .where((repo) => repo.name.contains('fork'))
            .toList();
        break;
      case 'archived':
        // For demo purposes, consider repos with low star count as archived
        filtered = filtered.where((repo) => repo.starCount < 5).toList();
        break;
      case 'all':
      default:
        // Keep all repositories
        break;
    }

    // Apply search filter
    if (_repositoryQuery.isNotEmpty) {
      filtered = filtered.where((repo) {
        final query = _repositoryQuery.toLowerCase();
        return repo.name.toLowerCase().contains(query) ||
            repo.description.toLowerCase().contains(query) ||
            repo.language.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sorting
    switch (_repositorySortBy) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'stars':
        filtered.sort((a, b) => b.starCount.compareTo(a.starCount));
        break;
      case 'updated':
      default:
        filtered.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        break;
    }

    _filteredRepositories = filtered;
  }

  void _applyStarredFilters() {
    var filtered = List<FakeRepository>.from(_starredRepos);

    // Apply type filter for starred repos
    switch (_starredFilter) {
      case 'sources':
        filtered = filtered
            .where((repo) => !repo.name.contains('fork'))
            .toList();
        break;
      case 'forks':
        filtered = filtered
            .where((repo) => repo.name.contains('fork'))
            .toList();
        break;
      case 'all':
      default:
        // Keep all starred repositories
        break;
    }

    // Apply search filter
    if (_starredQuery.isNotEmpty) {
      filtered = filtered.where((repo) {
        final query = _starredQuery.toLowerCase();
        return repo.name.toLowerCase().contains(query) ||
            repo.description.toLowerCase().contains(query) ||
            repo.language.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sorting
    switch (_starredSortBy) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'stars':
        filtered.sort((a, b) => b.starCount.compareTo(a.starCount));
        break;
      case 'updated':
      default:
        filtered.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        break;
    }

    _filteredStarredRepos = filtered;
  }

  void _onRepositorySearch(String query) {
    setState(() {
      _repositoryQuery = query;
    });
    _applyRepositoryFilters();
  }

  void _onStarredSearch(String query) {
    setState(() {
      _starredQuery = query;
    });
    _applyStarredFilters();
  }

  void _onRepositoryFilterChanged(String filter) {
    setState(() {
      _repositoryFilter = filter;
    });
    _applyRepositoryFilters();
  }

  void _onStarredFilterChanged(String filter) {
    setState(() {
      _starredFilter = filter;
    });
    _applyStarredFilters();
  }

  void _onRepositorySortChanged(String sortBy) {
    setState(() {
      _repositorySortBy = sortBy;
    });
    _applyRepositoryFilters();
  }

  void _onStarredSortChanged(String sortBy) {
    setState(() {
      _starredSortBy = sortBy;
    });
    _applyStarredFilters();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GHScreenTemplate(
      title: _user.name ?? _user.login,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Share ${_user.login}\'s profile')),
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
            const PopupMenuItem(value: 'Block user', child: Text('Block user')),
            const PopupMenuItem(
              value: 'Report user',
              child: Text('Report user'),
            ),
          ],
        ),
      ],
      body: Column(
        children: [
          // User profile header
          _buildUserHeader(),

          // Action buttons
          _buildActionButtons(),

          // Tab bar
          _buildTabBar(),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRepositoriesTab(),
                _buildStarredTab(),
                _buildOrganizationsTab(),
                _buildProjectsTab(),
                _buildPackagesTab(),
                _buildGistsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return GHCard(
      margin: const EdgeInsets.all(GHTokens.spacing16),
      child: Padding(
        padding: const EdgeInsets.all(GHTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Large avatar
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(_user.avatarUrl),
                ),
                const SizedBox(width: GHTokens.spacing16),

                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_user.name != null) ...[
                        Text(
                          _user.name!,
                          style: GHTokens.titleLarge.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        '@${_user.login}',
                        style: GHTokens.bodyLarge.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bio
            if (_user.bio != null) ...[
              const SizedBox(height: GHTokens.spacing12),
              Text(
                _user.bio!,
                style: GHTokens.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],

            // Location and company
            if (_user.location != null || _user.company != null) ...[
              const SizedBox(height: GHTokens.spacing8),
              Row(
                children: [
                  if (_user.location != null) ...[
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: GHTokens.spacing4),
                    Text(
                      _user.location!,
                      style: GHTokens.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (_user.location != null && _user.company != null)
                    const SizedBox(width: GHTokens.spacing16),
                  if (_user.company != null) ...[
                    Icon(
                      Icons.business_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: GHTokens.spacing4),
                    Text(
                      _user.company!,
                      style: GHTokens.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ],

            // Statistics
            const SizedBox(height: GHTokens.spacing16),
            Row(
              children: [
                _buildStatItem('Repositories', _user.repositoryCount),
                const SizedBox(width: GHTokens.spacing24),
                _buildStatItem('Followers', _user.followerCount),
                const SizedBox(width: GHTokens.spacing24),
                _buildStatItem('Following', _user.followingCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('View $label')));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            NumberFormatter.formatCompact(count),
            style: GHTokens.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: GHTokens.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GHTokens.spacing16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isFollowing = !_isFollowing;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isFollowing
                          ? 'Following ${_user.login}'
                          : 'Unfollowed ${_user.login}',
                    ),
                  ),
                );
              },
              icon: Icon(_isFollowing ? Icons.person_remove : Icons.person_add),
              label: Text(_isFollowing ? 'Unfollow' : 'Follow'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFollowing
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: _isFollowing
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: GHTokens.spacing8),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Message ${_user.login}')));
            },
            icon: const Icon(Icons.message_outlined),
            label: const Text('Message'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(top: GHTokens.spacing16),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: _tabTitles.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final badge = _getTabBadge(index);

          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title),
                if (badge != null) ...[
                  const SizedBox(width: GHTokens.spacing4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GHTokens.spacing4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(GHTokens.radius8),
                    ),
                    child: Text(
                      badge,
                      style: GHTokens.labelMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String? _getTabBadge(int tabIndex) {
    switch (tabIndex) {
      case 0: // Repositories
        return _filteredRepositories.isNotEmpty
            ? _filteredRepositories.length.toString()
            : _user.repositoryCount.toString();
      case 1: // Starred
        return _filteredStarredRepos.isNotEmpty
            ? _filteredStarredRepos.length.toString()
            : null;
      case 2: // Organizations
        return _organizations.isNotEmpty
            ? _organizations.length.toString()
            : _user.organizations.length.toString();
      default:
        return null;
    }
  }

  Widget _buildRepositoriesTab() {
    if (_repositoriesLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(GHTokens.spacing24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final sourceCount = _repositories
        .where((repo) => !repo.name.contains('fork'))
        .length;
    final forkCount = _repositories
        .where((repo) => repo.name.contains('fork'))
        .length;
    final archivedCount = _repositories
        .where((repo) => repo.starCount < 5)
        .length;

    return GHListTemplate(
      searchHint: 'Find a repository...',
      onRefresh: _loadRepositories,
      onSearch: (query) {
        _repositorySearch.search(query);
      },
      filters: [
        // Repository type filters
        GHFilterBar(
          filters:
              GHFilterItems.repositoryType(
                    allCount: _repositories.length,
                    sourcesCount: sourceCount,
                    forksCount: forkCount,
                    archivedCount: archivedCount,
                  )
                  .map(
                    (item) => GHFilterItem(
                      label: item.label,
                      value: item.value,
                      count: item.count,
                      isActive: item.value == _repositoryFilter,
                      colorIndicator: item.colorIndicator,
                    ),
                  )
                  .toList(),
          onFilterChanged: (filter) {
            _onRepositoryFilterChanged(filter.value);
          },
          onClearAll: () {
            _onRepositoryFilterChanged('all');
          },
        ),

        // Sort options
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GHTokens.spacing16),
          child: Row(
            children: [
              Text(
                'Sort:',
                style: GHTokens.labelMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: GHTokens.spacing8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GHChip(
                        label: 'Recently updated',
                        isSelected: _repositorySortBy == 'updated',
                        onTap: () => _onRepositorySortChanged('updated'),
                      ),
                      const SizedBox(width: GHTokens.spacing8),
                      GHChip(
                        label: 'Name',
                        isSelected: _repositorySortBy == 'name',
                        onTap: () => _onRepositorySortChanged('name'),
                      ),
                      const SizedBox(width: GHTokens.spacing8),
                      GHChip(
                        label: 'Stars',
                        isSelected: _repositorySortBy == 'stars',
                        onTap: () => _onRepositorySortChanged('stars'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      children: _filteredRepositories
          .map(
            (repo) => GHRepositoryCard.fromFakeRepository(
              repo,
              showStarButton: true,
              onTap: () {
                NavigationService.navigateToRepository(repo.owner, repo.name);
              },
              onStarTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Starred ${repo.owner}/${repo.name}')),
                );
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildStarredTab() {
    if (_starredLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(GHTokens.spacing24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_starredRepos.isEmpty) {
      return const GHListTemplate(
        children: [
          GHCard(
            child: Padding(
              padding: EdgeInsets.all(GHTokens.spacing16),
              child: Column(
                children: [
                  Icon(Icons.star_border, size: 48, color: Colors.grey),
                  SizedBox(height: GHTokens.spacing8),
                  Text(
                    'No starred repositories',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: GHTokens.spacing4),
                  Text(
                    'Star repositories to see them here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final starredSourceCount = _starredRepos
        .where((repo) => !repo.name.contains('fork'))
        .length;
    final starredForkCount = _starredRepos
        .where((repo) => repo.name.contains('fork'))
        .length;

    return GHListTemplate(
      searchHint: 'Search starred repositories...',
      onRefresh: _loadStarredRepositories,
      onSearch: (query) {
        _starredSearch.search(query);
      },
      filters: [
        // Starred repository type filters
        GHFilterBar(
          filters: [
            GHFilterItem(
              label: 'All',
              value: 'all',
              count: _starredRepos.length,
              isActive: _starredFilter == 'all',
            ),
            GHFilterItem(
              label: 'Sources',
              value: 'sources',
              count: starredSourceCount,
              isActive: _starredFilter == 'sources',
            ),
            GHFilterItem(
              label: 'Forks',
              value: 'forks',
              count: starredForkCount,
              isActive: _starredFilter == 'forks',
            ),
          ],
          onFilterChanged: (filter) {
            _onStarredFilterChanged(filter.value);
          },
          onClearAll: () {
            _onStarredFilterChanged('all');
          },
        ),

        // Sort options for starred repos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GHTokens.spacing16),
          child: Row(
            children: [
              Text(
                'Sort:',
                style: GHTokens.labelMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: GHTokens.spacing8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GHChip(
                        label: 'Recently starred',
                        isSelected: _starredSortBy == 'updated',
                        onTap: () => _onStarredSortChanged('updated'),
                      ),
                      const SizedBox(width: GHTokens.spacing8),
                      GHChip(
                        label: 'Name',
                        isSelected: _starredSortBy == 'name',
                        onTap: () => _onStarredSortChanged('name'),
                      ),
                      const SizedBox(width: GHTokens.spacing8),
                      GHChip(
                        label: 'Stars',
                        isSelected: _starredSortBy == 'stars',
                        onTap: () => _onStarredSortChanged('stars'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      children: _filteredStarredRepos
          .map(
            (repo) => GHRepositoryCard.fromFakeRepository(
              repo,
              showStarButton: true,
              isStarred: true,
              onTap: () {
                NavigationService.navigateToRepository(repo.owner, repo.name);
              },
              onStarTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Unstarred ${repo.owner}/${repo.name}'),
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildOrganizationsTab() {
    if (_organizationsLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(GHTokens.spacing24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final orgsToShow = _organizations.isNotEmpty
        ? _organizations
        : _user.organizations;

    if (orgsToShow.isEmpty) {
      return const GHListTemplate(
        children: [
          GHCard(
            child: Padding(
              padding: EdgeInsets.all(GHTokens.spacing16),
              child: Column(
                children: [
                  Icon(Icons.business_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: GHTokens.spacing8),
                  Text(
                    'No organizations',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: GHTokens.spacing4),
                  Text(
                    'Organizations will appear here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return GHListTemplate(
      onRefresh: _loadOrganizations,
      children: orgsToShow
          .map(
            (org) => GHCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Text(
                    org[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(org),
                subtitle: const Text('Organization'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('View organization: $org')),
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildProjectsTab() {
    return const GHListTemplate(
      children: [
        GHCard(
          child: Padding(
            padding: EdgeInsets.all(GHTokens.spacing16),
            child: Column(
              children: [
                Icon(Icons.dashboard_outlined, size: 48, color: Colors.grey),
                SizedBox(height: GHTokens.spacing8),
                Text(
                  'No projects yet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: GHTokens.spacing4),
                Text(
                  'Projects help organize work',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPackagesTab() {
    return const GHListTemplate(
      children: [
        GHCard(
          child: Padding(
            padding: EdgeInsets.all(GHTokens.spacing16),
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                SizedBox(height: GHTokens.spacing8),
                Text(
                  'No packages published',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: GHTokens.spacing4),
                Text(
                  'Packages will appear here when published',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGistsTab() {
    return const GHListTemplate(
      children: [
        GHCard(
          child: Padding(
            padding: EdgeInsets.all(GHTokens.spacing16),
            child: Column(
              children: [
                Icon(Icons.code_outlined, size: 48, color: Colors.grey),
                SizedBox(height: GHTokens.spacing8),
                Text(
                  'No gists created',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: GHTokens.spacing4),
                Text(
                  'Gists are a simple way to share code snippets',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
