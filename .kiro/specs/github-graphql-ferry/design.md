# Design Document - GitHub GraphQL with Ferry

## Overview

This design document outlines the integration of Ferry and ferry_builder into the gh3 Flutter application to connect with GitHub's GraphQL API, directly addressing the requirements specified in the requirements document. Ferry provides a type-safe, code-generated GraphQL client with built-in caching, reactive streams, and excellent developer experience.

**Key Design Principles:**
- **Requirement 1**: Ferry configured with GitHub's GraphQL endpoint and automatic authentication
- **Requirement 2**: GraphQL operations defined in .graphql files with code generation  
- **Requirement 3**: Full integration with Injectable dependency injection system
- **Requirement 4**: Comprehensive error handling for all GraphQL failure scenarios
- **Requirement 5**: Complete testability with mocking and error injection support

The design maintains compatibility with the existing clean architecture while introducing GraphQL-specific patterns that follow established project conventions.

## Architecture

### High-Level Architecture (UI-Component Colocated GraphQL)

```mermaid
graph TB
    subgraph "Screen Components with Colocated ViewModels & GraphQL"
        subgraph "Home Screen"
            HOME_SCREEN[home_screen.dart]
            HOME_VM[home_viewmodel.dart]
            HOME_GQL[home_viewmodel.graphql]
            HOME_CODEGEN[home_viewmodel.graphql.dart]
        end
        
        subgraph "User Details Screen"
            USER_SCREEN[user_details_screen.dart]
            USER_VM[user_details_viewmodel.dart]
            USER_GQL[user_details_viewmodel.graphql]
            USER_CODEGEN[user_details_viewmodel.graphql.dart]
        end
        
        subgraph "Repository Details Screen"
            REPO_SCREEN[repository_details_screen.dart]
            REPO_VM[repository_details_viewmodel.dart]
            REPO_GQL[repository_details_viewmodel.graphql]
            REPO_CODEGEN[repository_details_viewmodel.graphql.dart]
        end
    end
    
    subgraph "UI Components with Colocated Fragments"
        USER_CARD[user_card.dart]
        USER_FRAGMENT[user_card.graphql]
        USER_FRAG_CODE[user_card.graphql.dart]
        
        REPO_CARD[repository_card.dart]
        REPO_FRAGMENT[repository_card.graphql]
        REPO_FRAG_CODE[repository_card.graphql.dart]
    end
    
    subgraph "Ferry Client"
        FERRY[Ferry Client] --> GITHUB_GQL[GitHub GraphQL API]
    end
    
    HOME_SCREEN --> HOME_VM
    USER_SCREEN --> USER_VM
    REPO_SCREEN --> REPO_VM
    
    HOME_VM --> FERRY
    USER_VM --> FERRY
    REPO_VM --> FERRY
    
    HOME_GQL --> HOME_CODEGEN
    USER_GQL --> USER_CODEGEN
    REPO_GQL --> REPO_CODEGEN
    USER_FRAGMENT --> USER_FRAG_CODE
    REPO_FRAGMENT --> REPO_FRAG_CODE
    
    HOME_SCREEN -.-> USER_CARD
    USER_SCREEN -.-> REPO_CARD
```

### Ferry Integration Architecture

```mermaid
graph LR
    subgraph "Dependency Injection"
        INJECTABLE[Injectable Container]
        FERRY_CLIENT[Ferry Client]
        AUTH_LINK[Auth Link]
        HTTP_LINK[HTTP Link]
    end
    
    subgraph "ViewModels"
        USER_VM[UserViewModel]
        REPO_VM[RepositoryViewModel]
        HOME_VM[HomeViewModel]
    end
    
    subgraph "Generated Code"
        USER_QUERY[GetUserQuery]
        REPO_QUERY[GetRepositoryQuery]
        FOLLOWING_QUERY[GetFollowingQuery]
    end
    
    INJECTABLE --> FERRY_CLIENT
    FERRY_CLIENT --> AUTH_LINK
    FERRY_CLIENT --> HTTP_LINK
    FERRY_CLIENT --> CACHE_STORE
    
    USER_VM --> FERRY_CLIENT
    REPO_VM --> FERRY_CLIENT
    HOME_VM --> FERRY_CLIENT
    
    FERRY_CLIENT --> USER_QUERY
    FERRY_CLIENT --> REPO_QUERY
    FERRY_CLIENT --> FOLLOWING_QUERY
```

## File Structure and Colocation

### Screen-Level Colocation
```
lib/src/screens/
├── home_screen/
│   ├── home_screen.dart              # Screen widget
│   ├── home_viewmodel.dart           # ViewModel colocated with screen
│   ├── home_viewmodel.graphql        # GraphQL queries for this ViewModel
│   └── home_viewmodel.graphql.dart   # Generated Ferry code
├── user_details_screen/
│   ├── user_details_screen.dart
│   ├── user_details_viewmodel.dart
│   ├── user_details_viewmodel.graphql
│   └── user_details_viewmodel.graphql.dart
└── repository_details_screen/
    ├── repository_details_screen.dart
    ├── repository_details_viewmodel.dart
    ├── repository_details_viewmodel.graphql
    └── repository_details_viewmodel.graphql.dart
```

### UI Component-Level Colocation
```
lib/src/widgets/
├── user_card/
│   ├── user_card.dart                # UI component
│   ├── user_card.graphql             # GraphQL fragment for this component
│   └── user_card.graphql.dart        # Generated fragment types
├── user_profile/
│   ├── user_profile.dart
│   ├── user_profile.graphql
│   └── user_profile.graphql.dart
├── repository_card/
│   ├── repository_card.dart
│   ├── repository_card.graphql
│   └── repository_card.graphql.dart
└── repository_details/
    ├── repository_details.dart
    ├── repository_details.graphql
    └── repository_details.graphql.dart
```

### Benefits of This Structure
- **Perfect locality**: Everything related to a component is in one folder
- **No model classes**: UI components consume GraphQL types directly
- **Fragment reuse**: Components define exactly what data they need
- **Easy maintenance**: Changes to UI requirements update colocated GraphQL
- **Clear dependencies**: Fragments show exactly what data each component uses

## Components and Interfaces

### Ferry Client Configuration

#### FerryClientService (Requirement 1)
- **Purpose**: Configure and provide Ferry GraphQL client with GitHub's GraphQL endpoint
- **Injectable Registration**: Registered as singleton with `@singleton` annotation  
- **Responsibilities**:
  - Initialize Ferry client with GitHub GraphQL endpoint (https://api.github.com/graphql)
  - Configure authentication link with automatic token injection from ITokenStorage
  - Set up caching policies and storage for GitHub-specific data patterns
  - Handle client lifecycle and automatic token updates on authentication changes
- **Dependencies**: `ITokenStorage` (injected), `http.Client` (injected)
- **Key Methods**:
  - `createClient()`: Initialize Ferry client with GitHub endpoint and auth link
  - `updateAuthToken(String token)`: Automatically update authentication headers
  - `dispose()`: Clean up resources and subscriptions

```dart
@singleton
class FerryClientService {
  final ITokenStorage _tokenStorage;
  final http.Client _httpClient;
  late Client _ferryClient;
  
  FerryClientService(this._tokenStorage, this._httpClient) {
    _ferryClient = _createClient();
  }
  
  Client get client => _ferryClient;
  
  Client _createClient() {
    final authLink = AuthLink(
      getToken: () async => await _tokenStorage.getToken(),
    );
    
    final httpLink = HttpLink('https://api.github.com/graphql');
    
    final link = Link.from([authLink, httpLink]);
    
    return Client(
      link: link,
    );
  }
}
```

#### Authentication Link
- **Purpose**: Inject authentication headers into GraphQL requests
- **Responsibilities**:
  - Add Bearer token to all GraphQL requests
  - Handle token refresh scenarios
  - Provide error handling for authentication failures
- **Integration**: Custom Ferry Link implementation


### GraphQL Operations

#### Schema and Code Generation (Requirement 2)
**Ferry Builder Configuration**: GraphQL operations defined in .graphql files with automatic code generation

```yaml
# build.yaml - ferry_builder configuration for GitHub GraphQL schema
targets:
  $default:
    builders:
      ferry_generator:
        options:
          schema: lib/github_schema.graphql
          queries_glob: lib/**/*.graphql
          # Generated files colocated with screens, viewmodels, and UI components
          # lib/src/screens/home_screen/home_viewmodel.graphql → home_viewmodel.graphql.dart
          # lib/src/widgets/user_card/user_card.graphql → user_card.graphql.dart
```

**Code Generation Process**:
1. **Schema Definition**: GitHub GraphQL schema stored in `lib/github_schema.graphql`
2. **Operation Files**: .graphql files colocated with components that need them
3. **Build Process**: `flutter packages pub run build_runner build` generates type-safe Dart code
4. **Import Pattern**: Generated files imported alongside their .graphql definitions
5. **Fragment Dependencies**: ferry_builder automatically resolves fragment dependencies

#### UI-Component Colocated GraphQL Operations

**Screen-Level Queries (Colocated with ViewModels)**
```graphql
# lib/src/screens/home_screen/home_viewmodel.graphql
query GetFollowing($first: Int!, $after: String) {
  viewer {
    following(first: $first, after: $after) {
      nodes {
        ...UserCardFragment
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
}
```

```graphql
# lib/src/screens/user_details_screen/user_details_viewmodel.graphql
query GetUserDetails($login: String!) {
  user(login: $login) {
    ...UserProfileFragment
  }
}

query GetUserRepositories($login: String!, $first: Int!, $after: String) {
  user(login: $login) {
    repositories(first: $first, after: $after, orderBy: {field: UPDATED_AT, direction: DESC}) {
      nodes {
        ...RepositoryCardFragment
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
}
```

```graphql
# lib/src/screens/repository_details_screen/repository_details_viewmodel.graphql
query GetRepositoryDetails($owner: String!, $name: String!) {
  repository(owner: $owner, name: $name) {
    ...RepositoryDetailsFragment
    readme: object(expression: "HEAD:README.md") {
      ... on Blob {
        text
      }
    }
  }
}
```

**UI Component Fragments (Colocated with Widgets)**
```graphql
# lib/src/widgets/user_card/user_card.graphql
fragment UserCardFragment on User {
  id
  login
  name
  avatarUrl
  bio
  repositories {
    totalCount
  }
  followers {
    totalCount
  }
}
```

```graphql
# lib/src/widgets/user_profile/user_profile.graphql
fragment UserProfileFragment on User {
  id
  login
  name
  email
  bio
  location
  company
  websiteUrl
  avatarUrl
  url
  repositories {
    totalCount
  }
  followers {
    totalCount
  }
  following {
    totalCount
  }
  createdAt
  updatedAt
}
```

```graphql
# lib/src/widgets/repository_card/repository_card.graphql
fragment RepositoryCardFragment on Repository {
  id
  name
  nameWithOwner
  description
  stargazerCount
  forkCount
  primaryLanguage {
    name
    color
  }
  updatedAt
}
```

```graphql
# lib/src/widgets/repository_details/repository_details.graphql
fragment RepositoryDetailsFragment on Repository {
  id
  name
  nameWithOwner
  description
  url
  homepageUrl
  isPrivate
  isFork
  isArchived
  stargazerCount
  forkCount
  watchers {
    totalCount
  }
  issues(states: OPEN) {
    totalCount
  }
  primaryLanguage {
    name
    color
  }
  createdAt
  updatedAt
  pushedAt
  owner {
    login
    avatarUrl
  }
  languages(first: 10, orderBy: {field: SIZE, direction: DESC}) {
    nodes {
      name
      color
    }
    totalSize
  }
}
```

### UI-Component Colocated GraphQL Integration

This architecture provides maximum colocation by organizing code around UI components:

- **Screen-level colocation**: ViewModels colocated with their screens
- **Component-level colocation**: GraphQL fragments colocated with UI widgets
- **Direct data consumption**: UI components consume GraphQL generated types directly
- **No data models**: Eliminates the need for separate model classes
- **Fragment reuse**: UI components define their own data requirements via fragments

### ViewModel Integration (Requirement 3)

#### ViewModel Factory Pattern with Injectable Integration
**Dependency Injection Pattern**: ViewModel factories are injectable and receive Ferry client, then create ViewModels with the necessary dependencies

```dart
// lib/src/screens/user_details/user_details_viewmodel_factory.dart
import 'package:ferry/ferry.dart';
import 'package:injectable/injectable.dart';
import 'user_details_viewmodel.dart';

@injectable
class UserDetailsViewModelFactory {
  final Client _ferryClient;

  UserDetailsViewModelFactory(this._ferryClient);

  UserDetailsViewModel create(String login) {
    return UserDetailsViewModel(login, _ferryClient);
  }
}
```

```dart
// lib/src/screens/user_details/user_details_viewmodel.dart
import 'dart:async';
import 'package:ferry/ferry.dart';
import '../base_viewmodel.dart';
import '__generated__/user_details_viewmodel.req.gql.dart';
import '__generated__/user_details_viewmodel.data.gql.dart';
import '__generated__/user_details_viewmodel.var.gql.dart';

class UserDetailsViewModel extends DisposableViewModel {
  final String _login;
  final Client _ferryClient;

  UserDetailsViewModel(this._login, this._ferryClient);
  
  // Store raw GraphQL results - no model conversion
  OperationResponse<GGetUserDetailsData, GGetUserDetailsVars>? _userResult;
  OperationResponse<GGetUserRepositoriesData, GGetUserRepositoriesVars>? _repositoriesResult;
  
  StreamSubscription<OperationResponse<GGetUserDetailsData, GGetUserDetailsVars>>? _userSubscription;
  StreamSubscription<OperationResponse<GGetUserRepositoriesData, GGetUserRepositoriesVars>>? _reposSubscription;

  String get login => _login;
  
  // Expose raw GraphQL data for UI consumption
  GGetUserDetailsData_user? get user => _userResult?.data?.user;
  GGetUserRepositoriesData_user_repositories? get repositories => 
      _repositoriesResult?.data?.user?.repositories;
  
  bool get isLoading => 
      (_userResult?.loading ?? true) || (_repositoriesResult?.loading ?? true);
  
  String? get error {
    final userException = _userResult?.linkException ?? _userResult?.graphqlErrors;
    if (userException != null) {
      return _getErrorMessage(userException);
    }
    final reposException = _repositoriesResult?.linkException ?? _repositoriesResult?.graphqlErrors;
    if (reposException != null) {
      return _getErrorMessage(reposException);
    }
    return null;
  }
  
  Future<void> init() async {
    await loadUserDetails();
    await loadUserRepositories();
  }
  
  Future<void> loadUserDetails() async {
    final request = GGetUserDetailsReq((b) => b..vars.login = _login);
    
    _userSubscription?.cancel();
    _userSubscription = _ferryClient.request(request).listen((result) {
      _userResult = result;
      notifyListeners();
    });
  }
  
  Future<void> loadUserRepositories() async {
    final request = GGetUserRepositoriesReq(
      (b) => b
        ..vars.login = _login
        ..vars.first = 20
        ..vars.after = null,
    );
    
    _reposSubscription?.cancel();
    _reposSubscription = _ferryClient.request(request).listen((result) {
      _repositoriesResult = result;
      notifyListeners();
    });
  }
  
  @override
  void onDispose() {
    _userSubscription?.cancel();
    _reposSubscription?.cancel();
    _userSubscription = null;
    _reposSubscription = null;
    _userResult = null;
    _repositoriesResult = null;
  }
}
```

#### HomeViewModel Factory Pattern
```dart
// lib/src/screens/home_screen/home_viewmodel_factory.dart
import 'package:ferry/ferry.dart';
import 'package:injectable/injectable.dart';
import 'home_viewmodel.dart';

@injectable
class HomeViewModelFactory {
  final Client _ferryClient;

  HomeViewModelFactory(this._ferryClient);

  HomeViewModel create() {
    return HomeViewModel(_ferryClient);
  }
}
```

```dart
// lib/src/screens/home_screen/home_viewmodel.dart
import 'dart:async';
import 'package:ferry/ferry.dart';
import '../base_viewmodel.dart';
import '__generated__/home_viewmodel.req.gql.dart';
import '__generated__/home_viewmodel.data.gql.dart';
import '__generated__/home_viewmodel.var.gql.dart';

class HomeViewModel extends DisposableViewModel {
  final Client _ferryClient;

  HomeViewModel(this._ferryClient);

  // Store raw GraphQL results - no model conversion
  OperationResponse<GGetFollowingData, GGetFollowingVars>? _followingResult;
  StreamSubscription<OperationResponse<GGetFollowingData, GGetFollowingVars>>? _followingSubscription;

  // Expose raw GraphQL data for UI consumption
  GGetFollowingData_viewer_following? get following => _followingResult?.data?.viewer.following;
  List<GGetFollowingData_viewer_following_nodes> get followingUsers => 
      following?.nodes?.cast<GGetFollowingData_viewer_following_nodes>().toList() ?? [];

  bool get isLoading => _followingResult?.loading ?? true;
  
  Future<void> loadFollowingUsers() async {
    final request = GGetFollowingReq((b) => b..vars.first = 20..vars.after = null);
    
    _followingSubscription?.cancel();
    _followingSubscription = _ferryClient.request(request).listen((result) {
      _followingResult = result;
      notifyListeners();
    });
  }

  @override
  void onDispose() {
    _followingSubscription?.cancel();
    _followingSubscription = null;
    _followingResult = null;
  }
}
```

#### Injectable Registration Pattern
The Factory pattern ensures that:
- **Factories are Injectable**: Only ViewModel factories have `@injectable` annotations
- **ViewModels are created by Factories**: ViewModels receive dependencies through their constructors via factories  
- **Consistent Pattern**: All ViewModels (HomeViewModel, UserDetailsViewModel, etc.) follow the same factory pattern for dependency injection
- **Route Providers use Factories**: Route providers inject factory dependencies and pass them to screens

#### Screen with Factory-Based ViewModel Integration
```dart
// lib/src/screens/user_details/user_details_screen.dart
import 'package:flutter/material.dart';
import 'user_details_viewmodel.dart';
import 'user_details_viewmodel_factory.dart';
import '../../widgets/user_profile/user_profile.dart';
import '../../widgets/repository_card/repository_card.dart';

class UserDetailsScreen extends StatefulWidget {
  final String username;
  final UserDetailsViewModelFactory viewModelFactory;
  
  const UserDetailsScreen({
    Key? key, 
    required this.username,
    required this.viewModelFactory,
  }) : super(key: key);
  
  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late UserDetailsViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    // Create ViewModel using factory
    _viewModel = widget.viewModelFactory.create(widget.username);
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.init(); // Load user data
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_viewModel.error != null) {
      return Center(child: Text('Error: ${_viewModel.error}'));
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // UserProfile widget consumes GraphQL fragment data directly
          if (_viewModel.user != null)
            UserProfile(user: _viewModel.user!),
          
          const SizedBox(height: 24),
          
          // Repository list using RepositoryCard widgets
          if (_viewModel.repositories?.nodes != null)
            ...(_viewModel.repositories!.nodes!.map((repo) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RepositoryCard(repository: repo),
              )
            )),
        ],
      ),
    );
  }
  
  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }
  
  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }
}
```

#### Route Provider Integration
```dart
// lib/src/screens/user_details/user_details_route_provider.dart
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../routing/route_provider.dart';
import 'user_details_screen.dart';
import 'user_details_viewmodel_factory.dart';

@injectable
class UserDetailsRouteProvider implements RouteProvider {
  final UserDetailsViewModelFactory _viewModelFactory;

  UserDetailsRouteProvider(this._viewModelFactory);

  @override
  GoRoute getRoute() {
    return GoRoute(
      path: '/user/:username',
      builder: (context, state) {
        final username = state.pathParameters['username']!;
        return UserDetailsScreen(
          username: username,
          viewModelFactory: _viewModelFactory,
        );
      },
    );
  }
}
```

#### UI Components Consuming GraphQL Fragments Directly
```dart
// lib/src/widgets/user_profile/user_profile.dart
import 'package:flutter/material.dart';
import 'user_profile.graphql.dart'; // Generated fragment types

class UserProfile extends StatelessWidget {
  final UserProfileFragment user; // Direct GraphQL fragment consumption
  
  const UserProfile({Key? key, required this.user}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? user.login,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text('@${user.login}'),
                      if (user.location != null)
                        Text(user.location!),
                    ],
                  ),
                ),
              ],
            ),
            if (user.bio != null) ...[
              const SizedBox(height: 16),
              Text(user.bio!),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStat('Repositories', user.repositories.totalCount),
                const SizedBox(width: 24),
                _buildStat('Followers', user.followers.totalCount),
                const SizedBox(width: 24),
                _buildStat('Following', user.following.totalCount),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
```

```dart
// lib/src/widgets/repository_card/repository_card.dart
import 'package:flutter/material.dart';
import 'repository_card.graphql.dart'; // Generated fragment types

class RepositoryCard extends StatelessWidget {
  final RepositoryCardFragment repository; // Direct GraphQL fragment consumption
  
  const RepositoryCard({Key? key, required this.repository}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(repository.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (repository.description != null)
              Text(repository.description!),
            const SizedBox(height: 4),
            Row(
              children: [
                if (repository.primaryLanguage != null) ...[
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                        repository.primaryLanguage!.color?.replaceFirst('#', '0xFF') ?? '0xFF000000'
                      )),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(repository.primaryLanguage!.name),
                  const SizedBox(width: 16),
                ],
                Icon(Icons.star, size: 16),
                Text(' ${repository.stargazerCount}'),
                const SizedBox(width: 16),
                Icon(Icons.call_split, size: 16),
                Text(' ${repository.forkCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Error Handling Strategy (Requirement 4)

**Comprehensive Error Handling**: Ferry distinguishes between different failure scenarios with specific error types and appropriate user feedback.

#### GraphQL Error Types
```dart
abstract class GraphQLError {
  final String message;
  final String? code;
  
  const GraphQLError(this.message, {this.code});
}

// Network connectivity and HTTP errors
class GraphQLNetworkError extends GraphQLError {
  final int? statusCode;
  
  const GraphQLNetworkError(String message, {this.statusCode}) 
      : super(message, code: 'NETWORK_ERROR');
}

// Authentication and authorization failures  
class GraphQLAuthenticationError extends GraphQLError {
  const GraphQLAuthenticationError(String message) 
      : super(message, code: 'AUTHENTICATION_ERROR');
}

// GitHub API rate limiting
class GraphQLRateLimitError extends GraphQLError {
  final DateTime? resetTime;
  final int? remainingPoints;
  
  const GraphQLRateLimitError(String message, {this.resetTime, this.remainingPoints}) 
      : super(message, code: 'RATE_LIMIT_ERROR');
}

// GraphQL-specific errors from GitHub API
class GraphQLValidationError extends GraphQLError {
  final List<String> fieldErrors;
  
  const GraphQLValidationError(String message, {this.fieldErrors = const []}) 
      : super(message, code: 'VALIDATION_ERROR');
}

// Offline/network connectivity issues
class GraphQLOfflineError extends GraphQLError {
  const GraphQLOfflineError(String message) 
      : super(message, code: 'OFFLINE_ERROR');
}
```

#### Error Handling Flow
```mermaid
graph TD
    QUERY[GraphQL Query] --> RESULT{Query Result}
    RESULT -->|Success| DATA[Process Data]
    RESULT -->|Error| ERROR_TYPE{Error Type}
    
    ERROR_TYPE -->|Network| NETWORK_HANDLER[Network Error Handler]
    ERROR_TYPE -->|Auth| AUTH_HANDLER[Auth Error Handler]  
    ERROR_TYPE -->|Rate Limit| RATE_HANDLER[Rate Limit Handler]
    ERROR_TYPE -->|GraphQL| GQL_HANDLER[GraphQL Error Handler]
    ERROR_TYPE -->|Offline| OFFLINE_HANDLER[Offline Error Handler]
    
    NETWORK_HANDLER --> RETRY{Retry?}
    AUTH_HANDLER --> LOGOUT[Logout User]
    RATE_HANDLER --> WAIT[Wait for Reset]
    GQL_HANDLER --> NO_PARTIAL[No Partial Data - Treat as Failure]
    OFFLINE_HANDLER --> OFFLINE_MESSAGE[Show Offline Message]
    
    RETRY -->|Yes| QUERY
    RETRY -->|No| FALLBACK[Use REST API]
    WAIT --> QUERY
    NO_PARTIAL --> USER_FEEDBACK[Show Error Message]
```

#### Error Processing in ViewModels
```dart
class GraphQLErrorHandler {
  static GraphQLError processException(OperationException exception) {
    // Network errors (HTTP status codes)
    if (exception.linkException != null) {
      final linkError = exception.linkException!;
      if (linkError is HttpLinkServerException) {
        if (linkError.response.statusCode == 401) {
          return GraphQLAuthenticationError('Authentication failed');
        }
        if (linkError.response.statusCode == 403) {
          // Check for rate limiting headers
          final resetHeader = linkError.response.headers['x-ratelimit-reset'];
          if (resetHeader != null) {
            final resetTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(resetHeader) * 1000
            );
            return GraphQLRateLimitError(
              'Rate limit exceeded', 
              resetTime: resetTime
            );
          }
        }
        return GraphQLNetworkError(
          'Network error: ${linkError.response.statusCode}',
          statusCode: linkError.response.statusCode,
        );
      }
      // Network connectivity issues
      return GraphQLOfflineError('No internet connection');
    }
    
    // GraphQL errors - treat as failures (no partial data)
    if (exception.graphqlErrors.isNotEmpty) {
      final firstError = exception.graphqlErrors.first;
      return GraphQLValidationError(
        firstError.message,
        fieldErrors: firstError.extensions?['field_errors'] ?? [],
      );
    }
    
    return GraphQLError('Unknown error occurred');
  }
}


## Performance Optimizations

### Query Optimization

#### Field Selection
- Request only necessary fields in GraphQL queries
- Use fragments to avoid duplication

#### Pagination Strategy
```graphql
query GetRepositoriesPaginated($login: String!, $first: Int!, $after: String) {
  user(login: $login) {
    repositories(first: $first, after: $after, orderBy: {field: UPDATED_AT, direction: DESC}) {
      nodes {
        ...RepositoryFragment
      }
      pageInfo {
        hasNextPage
        hasPreviousPage
        startCursor
        endCursor
      }
    }
  }
}
```

#### Batch Operations
- Combine related queries when possible
- Use GraphQL aliases for multiple similar queries
- Implement query batching for related data

### Memory Management

#### Stream Management
```dart
class GraphQLViewModel extends ChangeNotifier {
  final List<StreamSubscription> _subscriptions = [];
  
  @override
  void dispose() {
    // Cancel all GraphQL subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }
  
  void _addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }
}
```

## Testing Strategy (Requirement 5)

**Complete Testability**: Ferry operations support mocking responses, error injection, and simulated network conditions.

### Unit Testing GraphQL Operations

#### Mock Ferry Client Setup
```dart
class MockFerryClient extends Mock implements Client {}

void main() {  
  group('UserDetailsViewModel Tests', () {
    late MockFerryClient mockClient;
    late UserDetailsViewModel viewModel;
    
    setUp(() {
      mockClient = MockFerryClient();
      viewModel = UserDetailsViewModel(mockClient);
    });
    
    test('should fetch user successfully', () async {
      // Arrange - Mock successful response
      final mockResult = QueryResult<GetUserDetailsQuery>(
        data: GetUserDetailsQuery$Query.fromJson({
          'user': {
            'login': 'testuser',
            'name': 'Test User',
            'avatarUrl': 'https://example.com/avatar.jpg',
            // ... other user fields
          }
        }),
        loading: false,
        hasException: false,
      );
      
      when(mockClient.request(any)).thenAnswer(
        (_) => Stream.value(mockResult),
      );
      
      // Act
      await viewModel.loadUser('testuser');
      
      // Assert
      expect(viewModel.user?.login, equals('testuser'));
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.error, isNull);
      verify(mockClient.request(any)).called(1);
    });
    
    test('should handle authentication errors', () async {
      // Arrange - Mock authentication error
      final mockException = OperationException(
        linkException: HttpLinkServerException(
          HttpLinkResponse(
            headers: {},
            statusCode: 401,
            reasonPhrase: 'Unauthorized',
            response: {},
          ),
          'Unauthorized',
        ),
      );
      
      final mockResult = QueryResult<GetUserDetailsQuery>(
        loading: false,
        hasException: true,
        exception: mockException,
      );
      
      when(mockClient.request(any)).thenAnswer(
        (_) => Stream.value(mockResult),
      );
      
      // Act
      await viewModel.loadUser('testuser');
      
      // Assert
      expect(viewModel.error, isNotNull);
      expect(viewModel.error, contains('Authentication'));
      expect(viewModel.user, isNull);
    });
    
    test('should handle rate limiting errors', () async {
      // Arrange - Mock rate limit error  
      final mockException = OperationException(
        linkException: HttpLinkServerException(
          HttpLinkResponse(
            headers: {'x-ratelimit-reset': '1640995200'},
            statusCode: 403,
            reasonPhrase: 'Forbidden',
            response: {},
          ),
          'Rate limit exceeded',
        ),
      );
      
      final mockResult = QueryResult<GetUserDetailsQuery>(
        loading: false,
        hasException: true,
        exception: mockException,
      );
      
      when(mockClient.request(any)).thenAnswer(
        (_) => Stream.value(mockResult),
      );
      
      // Act
      await viewModel.loadUser('testuser');
      
      // Assert
      expect(viewModel.error, contains('Rate limit'));
    });
    
    test('should handle offline scenarios', () async {
      // Arrange - Mock network error
      final mockException = OperationException(
        linkException: NetworkException('No internet connection'),
      );
      
      final mockResult = QueryResult<GetUserDetailsQuery>(
        loading: false,
        hasException: true,
        exception: mockException,
      );
      
      when(mockClient.request(any)).thenAnswer(
        (_) => Stream.value(mockResult),
      );
      
      // Act
      await viewModel.loadUser('testuser');
      
      // Assert
      expect(viewModel.error, contains('No internet'));
    });
  });
}
```

### Integration Testing

#### GraphQL Schema Testing
```dart
group('GraphQL Schema Integration Tests', () {
  test('should generate valid queries from schema', () async {
    // Test that generated code matches GitHub GraphQL schema
    final query = GetUserDetailsQuery(
      variables: GetUserDetailsArguments(login: 'octocat'),
    );
    
    expect(query.document.definitions, isNotEmpty);
    expect(query.variables, contains('login'));
  });
  
  test('should handle fragment composition correctly', () {
    // Test that fragments are properly composed in queries
    final fragment = UserCardFragment;
    expect(fragment.document.definitions.first.name?.value, equals('UserCardFragment'));
  });
});
```


## Migration Strategy

### Gradual Migration Approach

#### Phase 1: Infrastructure Setup
1. Add Ferry dependencies and configuration
2. Set up code generation pipeline
3. Create basic GraphQL operations
4. Implement authentication integration

#### Phase 2: Parallel Implementation
1. Implement GraphQL services alongside REST
2. Update ViewModels to use GraphQL where beneficial
3. Maintain REST API as fallback
4. Add comprehensive testing

#### Phase 3: Optimization and Cleanup
1. Optimize GraphQL queries and caching
2. Remove redundant REST API calls
3. Implement advanced Ferry features
4. Performance tuning and monitoring

### Coexistence Strategy
- GraphQL for complex, nested data fetching
- REST API for simple operations and fallbacks
- Shared authentication and error handling
- Consistent data models across both approaches

## Security Considerations

### Authentication Integration
- Reuse existing token storage and management
- Implement token refresh in GraphQL context
- Handle authentication errors consistently

### Query Security
- Validate query complexity and depth
- Implement query whitelisting if needed
- Monitor for potential GraphQL-specific attacks

### Data Privacy
- Respect GitHub's API rate limits and terms
- Implement proper data retention policies
- Handle sensitive data appropriately