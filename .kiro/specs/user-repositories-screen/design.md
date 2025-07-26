# Design Document

## Overview

The User Repositories Screen is a comprehensive repository browsing interface that provides search, filtering, and sorting capabilities for a user's GitHub repositories. The design follows the established modular screen architecture pattern with a ViewModel managing state and business logic, while the screen focuses on UI presentation. The screen integrates with the existing GraphQL infrastructure to fetch repository data and provides a responsive, performant user experience.

## Architecture

### Component Structure
```
UserRepositoriesScreen (StatefulWidget)
├── UserRepositoriesViewModel (ChangeNotifier)
├── UserRepositoriesViewModelFactory (@injectable)
├── UserRepositoriesRoute (AppRoute) - Route: /:login/@repositories
├── UserRepositoriesRouteProvider (@injectable)
└── GraphQL Integration
    ├── user_repositories_viewmodel.graphql
    └── __generated__/ (Ferry generated files)
```

### Routing Pattern
The screen uses the URL pattern `/:login/@repositories` which follows GitHub's URL structure:
- `:login` - The username parameter extracted from the URL path
- `@repositories` - Static segment indicating the repositories view
- Example: `/octocat/@repositories` for user "octocat"'s repositories

### Data Flow
1. **Screen Initialization**: Route creates ViewModel via Factory with extracted login parameter
2. **Data Loading**: ViewModel fetches repositories via GraphQL using the login parameter
3. **User Interactions**: Search/filter/sort actions update ViewModel state
4. **UI Updates**: ViewModel notifies listeners, screen rebuilds with filtered data
5. **Navigation**: Repository selection triggers navigation to repository details

## Components and Interfaces

### UserRepositoriesViewModel
```dart
class UserRepositoriesViewModel extends DisposableViewModel {
  // State properties
  List<GRepositoryFragment> repositories
  List<GRepositoryFragment> filteredRepositories
  bool isLoading
  String? error
  
  // Pagination state
  bool hasNextPage
  bool isLoadingMore
  String? nextCursor
  int totalCount
  
  // Race condition protection
  Future<void>? _currentLoadMoreOperation
  
  // Filter/search state
  String searchQuery
  RepositoryType selectedType
  String? selectedLanguage
  RepositorySortOption sortOption
  
  // Methods
  Future<void> loadRepositories()
  Future<void> loadMoreRepositories()
  void updateSearchQuery(String query)
  void updateTypeFilter(RepositoryType type)
  void updateLanguageFilter(String? language)
  void updateSortOption(RepositorySortOption option)
  void clearAllFilters()
  void refreshRepositories()
  
  // Scroll detection
  void onScrollNearEnd()
  
  // Pagination helpers
  bool get canLoadMore => hasNextPage && !isLoadingMore && !isLoading && _currentLoadMoreOperation == null
  bool get showLoadingIndicator => isLoadingMore && filteredRepositories.isNotEmpty
}
```

### Repository Type Enum
```dart
enum RepositoryType {
  all,
  private,
  source,
  fork,
  mirror,
  template,
  archived
}
```

### Repository Sort Options
```dart
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
```

### UserRepositoriesScreen Layout
```dart
class UserRepositoriesScreen extends StatefulWidget {
  // ... widget implementation
}

class _UserRepositoriesScreenState extends State<UserRepositoriesScreen> {
  late ScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      widget.viewModel.onScrollNearEnd();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Repositories"),
      body: RefreshIndicator(
        onRefresh: () => widget.viewModel.refreshRepositories(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: SearchAndFilterSection()),
            SliverList(delegate: SliverChildBuilderDelegate(
              (context, index) => RepositoryCard(...),
              childCount: widget.viewModel.filteredRepositories.length,
            )),
            if (widget.viewModel.showLoadingIndicator)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

### Search and Filter Section
- **Search Field**: Text input with search icon and clear button
- **Filter Chips**: Horizontal scrollable row showing active filters
- **Filter Button**: Opens bottom sheet with all filter options
- **Sort Button**: Dropdown or bottom sheet for sort options

### Repository List View
- **CustomScrollView with Slivers**: Unified scrolling experience with search/filter section
- **ScrollController**: Monitors scroll position for infinite scroll trigger
- **SliverList**: Efficient scrolling for large repository lists
- **Repository Cards**: Using existing or enhanced RepositoryCard widget
- **Pull-to-refresh**: RefreshIndicator wrapping the entire CustomScrollView
- **Infinite Scroll**: Automatically loads more when user scrolls near bottom (200px threshold)
- **Loading Indicator**: Shows at bottom during load more operations
- **Empty States**: Different messages for no repositories vs no search results
- **Loading State**: Shimmer or skeleton loading indicators

### Infinite Scroll Implementation

#### Scroll Detection Logic
```dart
void onScrollNearEnd() {
  if (canLoadMore) {
    loadMoreRepositories();
  }
}
```

#### Race Condition Protected Pagination
```dart
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

Future<void> _performLoadMore() async {
  try {
    final result = await _ferryClient.request(
      GUserRepositoriesReq((b) => b
        ..vars.first = 20
        ..vars.after = nextCursor
        ..vars.orderBy = _buildOrderBy(sortOption)
      ),
    ).first;
    
    if (result.hasErrors) {
      _error = result.graphqlErrors?.first.message;
    } else {
      final newRepositories = result.data?.viewer.repositories.nodes ?? [];
      _repositories.addAll(newRepositories);
      _hasNextPage = result.data?.viewer.repositories.pageInfo.hasNextPage ?? false;
      _nextCursor = result.data?.viewer.repositories.pageInfo.endCursor;
      _applyFiltersAndSort();
    }
  } catch (e) {
    _error = 'Failed to load more repositories: $e';
  }
}
```

#### Filter Interaction with Pagination
When filters change, pagination resets:
- Cancel any ongoing load more operation
- Clear existing repositories
- Reset pagination state (`hasNextPage = true`, `nextCursor = null`)
- Load first page with new filters
- Maintain infinite scroll functionality for filtered results

#### Scroll Threshold Configuration
- **Trigger Distance**: 200px from bottom of scroll view
- **Debouncing**: Built-in through race condition protection
- **Performance**: Only triggers when `canLoadMore` is true

## Data Models

### GraphQL Query Structure
```graphql
query UserRepositories($first: Int!, $after: String, $orderBy: RepositoryOrder) {
  viewer {
    repositories(first: $first, after: $after, orderBy: $orderBy) {
      totalCount
      pageInfo {
        hasNextPage
        endCursor
      }
      nodes {
        ...RepositoryFragment
      }
    }
  }
}

fragment RepositoryFragment on Repository {
  id
  name
  description
  url
  isPrivate
  isFork
  isTemplate
  isArchived
  isMirror
  primaryLanguage {
    name
    color
  }
  stargazerCount
  forkCount
  updatedAt
  pushedAt
  createdAt
}
```

### Filter Logic Implementation
```dart
List<GRepositoryFragment> _applyFilters(List<GRepositoryFragment> repositories) {
  var filtered = repositories;
  
  // Apply search filter
  if (searchQuery.isNotEmpty) {
    filtered = filtered.where((repo) => 
      repo.name.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }
  
  // Apply type filter
  filtered = _filterByType(filtered, selectedType);
  
  // Apply language filter
  if (selectedLanguage != null) {
    filtered = filtered.where((repo) => 
      repo.primaryLanguage?.name == selectedLanguage
    ).toList();
  }
  
  // Apply sorting
  filtered = _sortRepositories(filtered, sortOption);
  
  return filtered;
}
```

## Error Handling

### Error States
1. **Network Errors**: Display retry button with error message
2. **Authentication Errors**: Redirect to login screen
3. **GraphQL Errors**: Show user-friendly error messages
4. **Empty Results**: Distinguish between no repositories and no search results
5. **Load More Errors**: Show error message with retry option for pagination failures

### Error Recovery
- **Retry Mechanism**: Allow users to retry failed requests
- **Offline Handling**: Cache last successful data when possible
- **Graceful Degradation**: Show partial data if some operations fail

## Testing Strategy

### Unit Tests
- **ViewModel Logic**: Test filtering, sorting, and search functionality
- **Filter Combinations**: Test multiple filters applied simultaneously
- **Edge Cases**: Empty lists, null values, special characters in search
- **State Management**: Test loading states and error handling
- **Race Condition Protection**: Test multiple simultaneous `loadMoreRepositories()` calls
- **Infinite Scroll**: Test scroll detection and automatic loading behavior

### Widget Tests
- **Screen Rendering**: Test UI components render correctly
- **User Interactions**: Test search input, filter selection, sort changes
- **Navigation**: Test repository selection navigation
- **Accessibility**: Test screen reader support and keyboard navigation

### Integration Tests
- **GraphQL Integration**: Test data fetching and error scenarios
- **End-to-End Flow**: Test complete user journey from screen load to repository selection
- **Performance**: Test with large repository lists
- **Filter Persistence**: Test filter state maintenance during session

## Performance Considerations

### Optimization Strategies
1. **Infinite Scroll**: Automatic pagination with race condition protection
2. **Debounced Search**: Prevent excessive filtering during typing
3. **Efficient Filtering**: Use indexed data structures for fast filtering
4. **Memory Management**: Dispose of resources properly in ViewModel and ScrollController
5. **Caching**: Cache repository data to reduce API calls
6. **Scroll Performance**: 200px threshold prevents excessive API calls near bottom

### UI Performance
- **CustomScrollView with Slivers**: Efficient unified scrolling and rendering
- **SliverChildBuilderDelegate**: Lazy loading of repository cards
- **Const Widgets**: Use const constructors where possible
- **Minimal Rebuilds**: Optimize ChangeNotifier usage to prevent unnecessary rebuilds
- **Image Caching**: Cache repository owner avatars

## Accessibility

### Screen Reader Support
- **Semantic Labels**: Proper labels for search field and filter buttons
- **Repository Cards**: Descriptive labels including repository name, language, and stats
- **Filter State**: Announce active filters to screen readers
- **Navigation**: Clear navigation hierarchy and focus management

### Keyboard Navigation
- **Tab Order**: Logical tab sequence through search, filters, and repository list
- **Shortcuts**: Consider keyboard shortcuts for common actions
- **Focus Indicators**: Clear visual focus indicators for all interactive elements

## Future Enhancements

### Potential Features
1. **Advanced Search**: Search by description, topics, or README content
2. **Saved Filters**: Allow users to save and recall filter combinations
3. **Repository Actions**: Quick actions like star/unstar from list view
4. **Bulk Operations**: Select multiple repositories for batch actions
5. **Custom Sorting**: User-defined sort criteria
6. **Repository Grouping**: Group by language, organization, or custom criteria