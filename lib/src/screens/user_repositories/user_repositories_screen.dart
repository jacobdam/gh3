import 'package:flutter/material.dart';
import 'user_repositories_viewmodel.dart';
import '../../widgets/repository_card/repository_card.dart';
import '../../widgets/skeleton_loading/skeleton_loading.dart';
import '__generated__/user_repositories_viewmodel.data.gql.dart';

/// Screen for displaying a user's repositories with search, filter, and sort capabilities
class UserRepositoriesScreen extends StatefulWidget {
  final String login;
  final UserRepositoriesViewModel viewModel;

  const UserRepositoriesScreen({
    super.key,
    required this.login,
    required this.viewModel,
  });

  @override
  State<UserRepositoriesScreen> createState() => _UserRepositoriesScreenState();
}

class _UserRepositoriesScreenState extends State<UserRepositoriesScreen> {
  late UserRepositoriesViewModel _viewModel;
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.addListener(_onViewModelChanged);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _searchController = TextEditingController(text: _viewModel.searchQuery);
    _viewModel.loadRepositories();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _scrollController.dispose();
    _searchController.dispose();
    _viewModel.dispose();
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
      _viewModel.onScrollNearEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: 'Sort repositories',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _viewModel.refreshRepositories(),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading && _viewModel.filteredRepositories.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_viewModel.error != null && _viewModel.filteredRepositories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading repositories',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _viewModel.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _viewModel.loadRepositories(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Search and filter section
        SliverToBoxAdapter(
          child: _buildSearchAndFilterSection(),
        ),
        
        // Repository list or empty state
        if (_viewModel.filteredRepositories.isEmpty && !_viewModel.isLoading)
          SliverFillRemaining(
            child: _buildEmptyState(),
          )
        else if (_viewModel.isLoading && _viewModel.filteredRepositories.isEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildRepositoryCardSkeleton(),
              childCount: 6, // Show 6 skeleton cards while loading
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final repository = _viewModel.filteredRepositories[index];
                return RepositoryCard.fromUserRepositoriesFragment(
                  repository,
                  onTap: () => _onRepositoryTap(repository),
                );
              },
              childCount: _viewModel.filteredRepositories.length,
            ),
          ),
        
        // Loading indicator for pagination
        if (_viewModel.showLoadingIndicator)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search repositories...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _viewModel.updateSearchQuery('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) => _viewModel.updateSearchQuery(value),
          ),
          
          const SizedBox(height: 16),
          
          // Filter chips and buttons
          Row(
            children: [
              Expanded(
                child: _buildActiveFiltersChips(),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Filter repositories',
                child: OutlinedButton.icon(
                  onPressed: _showFilterOptions,
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersChips() {
    final activeFilters = <Widget>[];
    
    // Repository type filter chip
    if (_viewModel.selectedType != RepositoryType.all) {
      activeFilters.add(
        Chip(
          label: Text(_getRepositoryTypeDisplayName(_viewModel.selectedType)),
          onDeleted: () => _viewModel.updateTypeFilter(RepositoryType.all),
          deleteIcon: const Icon(Icons.close, size: 18),
        ),
      );
    }
    
    // Language filter chip
    if (_viewModel.selectedLanguage != null) {
      activeFilters.add(
        Chip(
          label: Text(_viewModel.selectedLanguage!),
          onDeleted: () => _viewModel.updateLanguageFilter(null),
          deleteIcon: const Icon(Icons.close, size: 18),
        ),
      );
    }
    
    // Sort option chip (only show if not default)
    if (_viewModel.sortOption != RepositorySortOption.recentlyPushed) {
      activeFilters.add(
        Chip(
          label: Text('Sort: ${_getSortOptionDisplayName(_viewModel.sortOption)}'),
          onDeleted: () => _viewModel.updateSortOption(RepositorySortOption.recentlyPushed),
          deleteIcon: const Icon(Icons.close, size: 18),
        ),
      );
    }
    
    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...activeFilters.map((chip) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: chip,
          )),
          if (activeFilters.length > 1)
            TextButton(
              onPressed: () => _viewModel.clearAllFilters(),
              child: const Text('Clear all'),
            ),
        ],
      ),
    );
  }

  Widget _buildRepositoryCardSkeleton() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Repository name skeleton
            const SkeletonLoading(height: 18, width: 200),
            const SizedBox(height: 8),
            // Description skeleton
            const SkeletonLoading(height: 14, width: double.infinity),
            const SizedBox(height: 4),
            const SkeletonLoading(height: 14, width: 250),
            const SizedBox(height: 12),
            // Language and stats skeleton
            Row(
              children: [
                // Language dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const SkeletonLoading(height: 12, width: 80),
                const SizedBox(width: 16),
                // Star icon
                Icon(Icons.star, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 4),
                const SkeletonLoading(height: 12, width: 30),
                const SizedBox(width: 16),
                // Fork icon
                Icon(Icons.call_split, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 4),
                const SkeletonLoading(height: 12, width: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasSearchQuery = _viewModel.searchQuery.isNotEmpty;
    final hasFilters = _viewModel.selectedType != RepositoryType.all || 
                      _viewModel.selectedLanguage != null;
    
    if (hasSearchQuery || hasFilters) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No repositories found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filters.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _viewModel.clearAllFilters(),
              child: const Text('Clear filters'),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No repositories found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.login} has no public repositories.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Repositories',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () {
                      _viewModel.clearAllFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear all'),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Repository type filter
                    _buildFilterSection(
                      'Repository Type',
                      RepositoryType.values.map((type) => 
                        _buildFilterOption(
                          _getRepositoryTypeDisplayName(type),
                          _viewModel.selectedType == type,
                          () => _viewModel.updateTypeFilter(type),
                        ),
                      ).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Language filter
                    if (_viewModel.availableLanguages.isNotEmpty)
                      _buildFilterSection(
                        'Language',
                        [
                          _buildFilterOption(
                            'All Languages',
                            _viewModel.selectedLanguage == null,
                            () => _viewModel.updateLanguageFilter(null),
                          ),
                          ..._viewModel.availableLanguages.map((language) =>
                            _buildLanguageFilterOption(
                              language,
                              _viewModel.languageCounts[language] ?? 0,
                              _viewModel.selectedLanguage == language,
                              () => _viewModel.updateLanguageFilter(language),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              
              // Apply button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title, List<Widget> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...options,
      ],
    );
  }

  Widget _buildFilterOption(String title, bool isSelected, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildLanguageFilterOption(String language, int count, bool isSelected, VoidCallback onTap) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(language)),
          Text(
            '($count)',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: onTap,
      dense: true,
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Sort Repositories',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...RepositorySortOption.values.map((option) =>
              ListTile(
                title: Text(_getSortOptionDisplayName(option)),
                trailing: _viewModel.sortOption == option 
                    ? const Icon(Icons.check, color: Colors.blue) 
                    : null,
                onTap: () {
                  _viewModel.updateSortOption(option);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRepositoryTypeDisplayName(RepositoryType type) {
    switch (type) {
      case RepositoryType.all:
        return 'All';
      case RepositoryType.private:
        return 'Private';
      case RepositoryType.source:
        return 'Source';
      case RepositoryType.fork:
        return 'Forks';
      case RepositoryType.mirror:
        return 'Mirrors';
      case RepositoryType.template:
        return 'Templates';
      case RepositoryType.archived:
        return 'Archived';
    }
  }

  String _getSortOptionDisplayName(RepositorySortOption option) {
    switch (option) {
      case RepositorySortOption.recentlyPushed:
        return 'Recently pushed';
      case RepositorySortOption.leastRecentlyPushed:
        return 'Least recently pushed';
      case RepositorySortOption.newest:
        return 'Newest';
      case RepositorySortOption.oldest:
        return 'Oldest';
      case RepositorySortOption.nameAscending:
        return 'Name (A-Z)';
      case RepositorySortOption.nameDescending:
        return 'Name (Z-A)';
      case RepositorySortOption.mostStarred:
        return 'Most starred';
      case RepositorySortOption.leastStarred:
        return 'Least starred';
    }
  }

  void _onRepositoryTap(GUserRepositoriesFragment repository) {
    // TODO: Navigate to repository details screen in later tasks
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on ${repository.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
