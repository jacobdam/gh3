import 'package:ferry/ferry.dart';
import '../base_viewmodel.dart';
import '__generated__/user_repositories_viewmodel.data.gql.dart';
import '__generated__/user_repositories_viewmodel.req.gql.dart';
import '../../../__generated__/github_schema.schema.gql.dart';

class UserRepositoriesViewModel extends DisposableViewModel {
  final Client _ferryClient;
  final String _userLogin;

  UserRepositoriesViewModel(this._ferryClient, this._userLogin);

  // State properties
  List<GUserRepositoriesFragment> _repositories = [];
  List<GUserRepositoriesFragment> _filteredRepositories = [];
  bool _isLoading = false;
  String? _error;

  // Pagination state
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  String? _nextCursor;
  int _totalCount = 0;

  // Race condition protection
  Future<void>? _currentLoadMoreOperation;

  // Filter/search state
  String _searchQuery = '';
  RepositoryType _selectedType = RepositoryType.all;
  String? _selectedLanguage;
  RepositorySortOption _sortOption = RepositorySortOption.recentlyPushed;

  // Available languages extracted from repositories
  List<String> _availableLanguages = [];
  
  // Language counts for display in filter UI
  Map<String, int> _languageCounts = {};

  // Getters
  List<GUserRepositoriesFragment> get repositories => _repositories;
  List<GUserRepositoriesFragment> get filteredRepositories => _filteredRepositories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasNextPage => _hasNextPage;
  bool get isLoadingMore => _isLoadingMore;
  String? get nextCursor => _nextCursor;
  int get totalCount => _totalCount;
  String get searchQuery => _searchQuery;
  RepositoryType get selectedType => _selectedType;
  String? get selectedLanguage => _selectedLanguage;
  RepositorySortOption get sortOption => _sortOption;
  List<String> get availableLanguages => _availableLanguages;
  Map<String, int> get languageCounts => _languageCounts;

  // Computed properties
  bool get canLoadMore => _hasNextPage && !_isLoadingMore && !_isLoading && _currentLoadMoreOperation == null;
  bool get showLoadingIndicator => _isLoadingMore && _filteredRepositories.isNotEmpty;

  /// Load repositories from GraphQL API
  Future<void> loadRepositories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = GGetUserRepositoriesReq((b) {
        b.vars.login = _userLogin;
        b.vars.first = 20;
        b.vars.after = null;
        
        final orderBy = _buildOrderBy(_sortOption);
        b.vars.orderBy = orderBy.toBuilder();
        
        final affiliations = _buildAffiliations(_selectedType);
        if (affiliations != null) {
          b.vars.affiliations.addAll(affiliations);
        }
        
        b.vars.privacy = _buildPrivacy(_selectedType);
        b.vars.isFork = _buildIsFork(_selectedType);
        b.vars.isLocked = null;
      });

      final result = await _ferryClient.request(request).first;

      if (result.hasErrors) {
        _error = result.graphqlErrors?.first.message ?? 'Failed to load repositories';
      } else {
        final data = result.data;
        if (data?.user != null) {
          final repositoryConnection = data!.user!.repositories;
          _repositories = repositoryConnection.nodes?.where((node) => node != null).cast<GUserRepositoriesFragment>().toList() ?? [];
          _hasNextPage = repositoryConnection.pageInfo.hasNextPage;
          _nextCursor = repositoryConnection.pageInfo.endCursor;
          _totalCount = repositoryConnection.totalCount;
          
          _extractAvailableLanguages();
          _applyFiltersAndSort();
        } else {
          _error = 'User not found';
        }
      }
    } catch (e) {
      _error = 'Failed to load repositories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more repositories for pagination
  Future<void> loadMoreRepositories() async {
    // Prevent multiple simultaneous calls
    if (_currentLoadMoreOperation != null) {
      return _currentLoadMoreOperation!;
    }

    if (!canLoadMore) return;

    _isLoadingMore = true;
    notifyListeners();

    // Store the operation to prevent race conditions
    _currentLoadMoreOperation = _performLoadMore();

    try {
      await _currentLoadMoreOperation!;
    } finally {
      _currentLoadMoreOperation = null;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Perform the actual load more operation
  Future<void> _performLoadMore() async {
    try {
      final request = GGetUserRepositoriesReq((b) {
        b.vars.login = _userLogin;
        b.vars.first = 20;
        b.vars.after = _nextCursor;
        
        final orderBy = _buildOrderBy(_sortOption);
        b.vars.orderBy = orderBy.toBuilder();
        
        final affiliations = _buildAffiliations(_selectedType);
        if (affiliations != null) {
          b.vars.affiliations.addAll(affiliations);
        }
        
        b.vars.privacy = _buildPrivacy(_selectedType);
        b.vars.isFork = _buildIsFork(_selectedType);
        b.vars.isLocked = null;
      });

      final result = await _ferryClient.request(request).first;

      if (result.hasErrors) {
        _error = result.graphqlErrors?.first.message ?? 'Failed to load more repositories';
      } else {
        final data = result.data;
        if (data?.user != null) {
          final repositoryConnection = data!.user!.repositories;
          final newRepositories = repositoryConnection.nodes?.where((node) => node != null).cast<GUserRepositoriesFragment>().toList() ?? [];
          
          _repositories.addAll(newRepositories);
          _hasNextPage = repositoryConnection.pageInfo.hasNextPage;
          _nextCursor = repositoryConnection.pageInfo.endCursor;
          
          _extractAvailableLanguages();
          _applyFiltersAndSort();
        }
      }
    } catch (e) {
      _error = 'Failed to load more repositories: $e';
    }
  }

  /// Update search query and apply filters
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Update repository type filter
  void updateTypeFilter(RepositoryType type) {
    if (_selectedType != type) {
      _selectedType = type;
      // Reset pagination when filter changes
      _resetPaginationAndReload();
    }
  }

  /// Update language filter
  void updateLanguageFilter(String? language) {
    _selectedLanguage = language;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Update sort option
  void updateSortOption(RepositorySortOption option) {
    if (_sortOption != option) {
      _sortOption = option;
      // Reset pagination when sort changes
      _resetPaginationAndReload();
    }
  }

  /// Clear all filters and reset to defaults
  void clearAllFilters() {
    _searchQuery = '';
    _selectedType = RepositoryType.all;
    _selectedLanguage = null;
    _sortOption = RepositorySortOption.recentlyPushed;
    _resetPaginationAndReload();
  }

  /// Refresh repositories by clearing cache and reloading
  Future<void> refreshRepositories() async {
    _repositories.clear();
    _filteredRepositories.clear();
    _hasNextPage = true;
    _nextCursor = null;
    await loadRepositories();
  }

  /// Handle scroll near end for infinite scroll
  void onScrollNearEnd() {
    if (canLoadMore) {
      loadMoreRepositories();
    }
  }

  /// Reset pagination state and reload repositories
  Future<void> _resetPaginationAndReload() async {
    // Cancel any ongoing load more operation
    _currentLoadMoreOperation = null;
    
    // Clear existing repositories and reset pagination
    _repositories.clear();
    _filteredRepositories.clear();
    _hasNextPage = true;
    _nextCursor = null;
    
    // Reload with new filters/sort
    await loadRepositories();
  }

  /// Apply search, language filters, and sorting to repositories
  void _applyFiltersAndSort() {
    var filtered = List<GUserRepositoriesFragment>.from(_repositories);

    // Apply repository type filter (client-side for types not handled by GraphQL)
    filtered = _filterByRepositoryType(filtered, _selectedType);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((repo) => 
        repo.name.toLowerCase().contains(query) ||
        (repo.description?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    // Apply language filter
    if (_selectedLanguage != null) {
      if (_selectedLanguage == 'No Language') {
        filtered = filtered.where((repo) => repo.primaryLanguage == null).toList();
      } else {
        filtered = filtered.where((repo) => 
          repo.primaryLanguage?.name == _selectedLanguage
        ).toList();
      }
    }

    // Apply sorting (only for client-side filtering, server-side sorting is handled in GraphQL query)
    if (_searchQuery.isNotEmpty || _selectedLanguage != null || _needsClientSideTypeFilter(_selectedType)) {
      filtered = _sortRepositories(filtered, _sortOption);
    }

    _filteredRepositories = filtered;
  }

  /// Filter repositories by type (client-side filtering for types not handled by GraphQL)
  List<GUserRepositoriesFragment> _filterByRepositoryType(List<GUserRepositoriesFragment> repos, RepositoryType type) {
    switch (type) {
      case RepositoryType.all:
        return repos;
      case RepositoryType.private:
        return repos.where((repo) => repo.isPrivate).toList();
      case RepositoryType.source:
        return repos.where((repo) => !repo.isFork && !repo.isMirror && !repo.isTemplate).toList();
      case RepositoryType.fork:
        return repos.where((repo) => repo.isFork).toList();
      case RepositoryType.mirror:
        return repos.where((repo) => repo.isMirror).toList();
      case RepositoryType.template:
        return repos.where((repo) => repo.isTemplate).toList();
      case RepositoryType.archived:
        return repos.where((repo) => repo.isArchived).toList();
    }
  }

  /// Check if the repository type requires client-side filtering
  bool _needsClientSideTypeFilter(RepositoryType type) {
    switch (type) {
      case RepositoryType.mirror:
      case RepositoryType.template:
      case RepositoryType.archived:
        return true;
      case RepositoryType.all:
      case RepositoryType.private:
      case RepositoryType.source:
      case RepositoryType.fork:
        return false;
    }
  }

  /// Sort repositories based on the selected sort option
  List<GUserRepositoriesFragment> _sortRepositories(List<GUserRepositoriesFragment> repos, RepositorySortOption option) {
    final sortedRepos = List<GUserRepositoriesFragment>.from(repos);
    
    switch (option) {
      case RepositorySortOption.recentlyPushed:
        sortedRepos.sort((a, b) {
          final aPushed = a.pushedAt?.value ?? a.updatedAt.value;
          final bPushed = b.pushedAt?.value ?? b.updatedAt.value;
          return bPushed.compareTo(aPushed);
        });
        break;
      case RepositorySortOption.leastRecentlyPushed:
        sortedRepos.sort((a, b) {
          final aPushed = a.pushedAt?.value ?? a.updatedAt.value;
          final bPushed = b.pushedAt?.value ?? b.updatedAt.value;
          return aPushed.compareTo(bPushed);
        });
        break;
      case RepositorySortOption.newest:
        sortedRepos.sort((a, b) => b.createdAt.value.compareTo(a.createdAt.value));
        break;
      case RepositorySortOption.oldest:
        sortedRepos.sort((a, b) => a.createdAt.value.compareTo(b.createdAt.value));
        break;
      case RepositorySortOption.nameAscending:
        sortedRepos.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case RepositorySortOption.nameDescending:
        sortedRepos.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case RepositorySortOption.mostStarred:
        sortedRepos.sort((a, b) => b.stargazerCount.compareTo(a.stargazerCount));
        break;
      case RepositorySortOption.leastStarred:
        sortedRepos.sort((a, b) => a.stargazerCount.compareTo(b.stargazerCount));
        break;
    }
    
    return sortedRepos;
  }

  /// Extract available languages from all repositories
  void _extractAvailableLanguages() {
    final languages = <String>{};
    final counts = <String, int>{};
    
    for (final repo in _repositories) {
      if (repo.primaryLanguage?.name != null) {
        final language = repo.primaryLanguage!.name;
        languages.add(language);
        counts[language] = (counts[language] ?? 0) + 1;
      }
    }
    
    _availableLanguages = languages.toList()..sort();
    _languageCounts = counts;
    
    // Add "No Language" option if there are repositories without a primary language
    final noLanguageCount = _repositories.where((repo) => repo.primaryLanguage == null).length;
    if (noLanguageCount > 0) {
      _availableLanguages.insert(0, 'No Language');
      _languageCounts['No Language'] = noLanguageCount;
    }
  }

  /// Build GraphQL repository order based on sort option
  GRepositoryOrder _buildOrderBy(RepositorySortOption option) {
    switch (option) {
      case RepositorySortOption.recentlyPushed:
        return GRepositoryOrder((b) => b
          ..field = GRepositoryOrderField.PUSHED_AT
          ..direction = GOrderDirection.DESC);
      case RepositorySortOption.leastRecentlyPushed:
        return GRepositoryOrder((b) => b
          ..field = GRepositoryOrderField.PUSHED_AT
          ..direction = GOrderDirection.ASC);
      case RepositorySortOption.newest:
        return GRepositoryOrder((b) => b
          ..field = GRepositoryOrderField.CREATED_AT
          ..direction = GOrderDirection.DESC);
      case RepositorySortOption.oldest:
        return GRepositoryOrder((b) => b
          ..field = GRepositoryOrderField.CREATED_AT
          ..direction = GOrderDirection.ASC);
      case RepositorySortOption.nameAscending:
        return GRepositoryOrder((b) => b
          ..field = GRepositoryOrderField.NAME
          ..direction = GOrderDirection.ASC);
      case RepositorySortOption.nameDescending:
        return GRepositoryOrder((b) => b
          ..field = GRepositoryOrderField.NAME
          ..direction = GOrderDirection.DESC);
      case RepositorySortOption.mostStarred:
        return GRepositoryOrder((b) => b
          ..field = GRepositoryOrderField.STARGAZERS
          ..direction = GOrderDirection.DESC);
      case RepositorySortOption.leastStarred:
        return GRepositoryOrder((b) => b
          ..field = GRepositoryOrderField.STARGAZERS
          ..direction = GOrderDirection.ASC);
    }
  }

  /// Build repository affiliations based on repository type filter
  List<GRepositoryAffiliation>? _buildAffiliations(RepositoryType type) {
    switch (type) {
      case RepositoryType.all:
        return null; // No filter
      case RepositoryType.private:
      case RepositoryType.source:
      case RepositoryType.fork:
      case RepositoryType.mirror:
      case RepositoryType.template:
      case RepositoryType.archived:
        // For these types, we'll use owner affiliation and filter client-side
        return [GRepositoryAffiliation.OWNER];
    }
  }

  /// Build repository privacy filter based on repository type
  GRepositoryPrivacy? _buildPrivacy(RepositoryType type) {
    switch (type) {
      case RepositoryType.private:
        return GRepositoryPrivacy.PRIVATE;
      case RepositoryType.all:
      case RepositoryType.source:
      case RepositoryType.fork:
      case RepositoryType.mirror:
      case RepositoryType.template:
      case RepositoryType.archived:
        return null; // No privacy filter
    }
  }

  /// Build fork filter based on repository type
  bool? _buildIsFork(RepositoryType type) {
    switch (type) {
      case RepositoryType.fork:
        return true;
      case RepositoryType.source:
        return false;
      case RepositoryType.all:
      case RepositoryType.private:
      case RepositoryType.mirror:
      case RepositoryType.template:
      case RepositoryType.archived:
        return null; // No fork filter
    }
  }

  @override
  void onDispose() {
    // Cancel any ongoing operations
    _currentLoadMoreOperation = null;
  }
}

// Enums for repository filtering and sorting
enum RepositoryType {
  all,
  private,
  source,
  fork,
  mirror,
  template,
  archived
}

enum RepositorySortOption {
  recentlyPushed,
  leastRecentlyPushed,
  newest,
  oldest,
  nameAscending,
  nameDescending,
  mostStarred,
  leastStarred
}