import 'dart:async';
import 'package:ferry/ferry.dart';
import '../base_viewmodel.dart';
import '../../services/graphql_error_handler.dart';
import '../../services/graphql_errors.dart';
import '__generated__/user_details_viewmodel.req.gql.dart';
import '__generated__/user_details_viewmodel.data.gql.dart';
import '__generated__/user_details_viewmodel.var.gql.dart';

/// ViewModel for handling user details screen logic with GraphQL.
class UserDetailsViewModel extends DisposableViewModel {
  final String _login;
  final Client _ferryClient;

  UserDetailsViewModel(this._login, this._ferryClient);

  // Store raw GraphQL results - no model conversion
  OperationResponse<GGetUserDetailsData, GGetUserDetailsVars>? _userResult;
  OperationResponse<GGetUserRepositoriesData, GGetUserRepositoriesVars>?
  _repositoriesResult;

  StreamSubscription<
    OperationResponse<GGetUserDetailsData, GGetUserDetailsVars>
  >?
  _userSubscription;
  StreamSubscription<
    OperationResponse<GGetUserRepositoriesData, GGetUserRepositoriesVars>
  >?
  _reposSubscription;

  // Pagination state for repositories
  String? _endCursor;
  bool _hasNextPage = true;
  static const int _pageSize = 20;

  /// The user login being displayed.
  String get login => _login;

  // Expose raw GraphQL data for UI consumption
  GGetUserDetailsData_user? get user => _userResult?.data?.user;
  GGetUserRepositoriesData_user_repositories? get repositories =>
      _repositoriesResult?.data?.user?.repositories;

  List<GGetUserRepositoriesData_user_repositories_nodes> get repositoryNodes =>
      repositories?.nodes
          ?.cast<GGetUserRepositoriesData_user_repositories_nodes>()
          .toList() ??
      [];

  bool get isLoading =>
      (_userResult?.loading ?? true) || (_repositoriesResult?.loading ?? true);

  /// Check if user details are still loading
  bool get isUserLoading => _userResult?.loading ?? true;

  /// Check if repositories are still loading
  bool get isRepositoriesLoading => _repositoriesResult?.loading ?? true;

  /// Check if user data has been loaded successfully
  bool get hasUserData => user != null && !isUserLoading;

  /// Check if repository data has been loaded successfully
  bool get hasRepositoryData => repositories != null && !isRepositoriesLoading;

  bool get hasMoreRepositories => _hasNextPage;
  bool get isEmpty => repositoryNodes.isEmpty;

  // Enhanced data access for new GraphQL fields

  /// User's status message, null if no status is set
  String? get statusMessage => user?.status?.message;

  /// User's status emoji, null if no status is set
  String? get statusEmoji => user?.status?.emoji;

  /// Total count of repositories starred by the user
  int get starredRepositoriesCount => user?.starredRepositories.totalCount ?? 0;

  /// Total count of organizations the user belongs to
  int get organizationsCount => user?.organizations.totalCount ?? 0;

  /// Total count of repositories owned by the user
  int get repositoriesCount => user?.repositories.totalCount ?? 0;

  String? get error {
    // Prioritize user details errors since they're more critical
    if (_userResult != null) {
      final linkException = _userResult!.linkException;
      final graphqlErrors = _userResult!.graphqlErrors;

      if (linkException != null ||
          (graphqlErrors != null && graphqlErrors.isNotEmpty)) {
        return GraphQLErrorHandler.getErrorMessage(_userResult!);
      }
    }

    // Check repositories errors only if user details are successful
    if (_repositoriesResult != null) {
      final linkException = _repositoriesResult!.linkException;
      final graphqlErrors = _repositoriesResult!.graphqlErrors;

      if (linkException != null ||
          (graphqlErrors != null && graphqlErrors.isNotEmpty)) {
        // For repository errors, provide a different message than user errors
        return 'Unable to load repositories. ${GraphQLErrorHandler.getErrorMessage(_repositoriesResult!)}';
      }
    }

    return null;
  }

  /// Check if the current error is specifically a user not found error
  bool get isUserNotFoundError {
    if (_userResult != null) {
      final processedError = GraphQLErrorHandler.processResponse(_userResult!);
      return processedError is GraphQLUserNotFoundError;
    }
    return false;
  }

  /// Check if the current error is a network connectivity issue
  bool get isNetworkError {
    if (_userResult != null) {
      final processedError = GraphQLErrorHandler.processResponse(_userResult!);
      return processedError is GraphQLNetworkError ||
          processedError is GraphQLOfflineError;
    }
    return false;
  }

  /// Check if the current error is an authentication issue
  bool get isAuthError {
    if (_userResult != null) {
      final processedError = GraphQLErrorHandler.processResponse(_userResult!);
      return processedError is GraphQLAuthenticationError;
    }
    return false;
  }

  /// Initialize the view model and load user data.
  Future<void> init() async {
    await loadUserDetails();
    await loadUserRepositories();
  }

  /// Load user details via GraphQL
  Future<void> loadUserDetails() async {
    final request = GGetUserDetailsReq((b) => b..vars.login = _login);

    _userSubscription?.cancel();
    _userSubscription = _ferryClient.request(request).listen((result) {
      _userResult = result;
      notifyListeners();
    });
  }

  /// Load user repositories via GraphQL
  Future<void> loadUserRepositories() async {
    _endCursor = null;
    _hasNextPage = true;

    final request = GGetUserRepositoriesReq(
      (b) => b
        ..vars.login = _login
        ..vars.first = _pageSize
        ..vars.after = null,
    );

    _reposSubscription?.cancel();
    _reposSubscription = _ferryClient.request(request).listen((result) {
      _repositoriesResult = result;

      if (result.data?.user?.repositories != null) {
        final pageInfo = result.data!.user!.repositories.pageInfo;
        _hasNextPage = pageInfo.hasNextPage;
        _endCursor = pageInfo.endCursor;
      }

      notifyListeners();
    });
  }

  /// Load more repositories (pagination)
  Future<void> loadMoreRepositories() async {
    if (isLoading || !_hasNextPage || _endCursor == null) return;

    final request = GGetUserRepositoriesReq(
      (b) => b
        ..vars.login = _login
        ..vars.first = _pageSize
        ..vars.after = _endCursor,
    );

    // For pagination, we'll need to merge results
    // This is a simplified approach - in production you might want more sophisticated caching
    _ferryClient.request(request).listen((result) {
      if (result.data?.user?.repositories != null) {
        final newRepositories = result.data!.user!.repositories;

        // Update pagination info
        final pageInfo = newRepositories.pageInfo;
        _hasNextPage = pageInfo.hasNextPage;
        _endCursor = pageInfo.endCursor;

        // For simplicity, just trigger a refresh - in production you'd merge properly
        notifyListeners();
      }
    });
  }

  /// Refresh both user details and repositories
  Future<void> refresh() async {
    notifyListeners(); // Notify to show loading state

    // For refresh, get fresh data
    final userRequest = GGetUserDetailsReq((b) => b..vars.login = _login);

    final reposRequest = GGetUserRepositoriesReq(
      (b) => b
        ..vars.login = _login
        ..vars.first = _pageSize
        ..vars.after = null,
    );

    _userSubscription?.cancel();
    _reposSubscription?.cancel();

    _userSubscription = _ferryClient.request(userRequest).listen((result) {
      _userResult = result;
      notifyListeners();
    });

    _reposSubscription = _ferryClient.request(reposRequest).listen((result) {
      _repositoriesResult = result;

      if (result.data?.user?.repositories != null) {
        final pageInfo = result.data!.user!.repositories.pageInfo;
        _hasNextPage = pageInfo.hasNextPage;
        _endCursor = pageInfo.endCursor;
      }

      notifyListeners();
    });
  }

  /// Retry only user details loading
  Future<void> retryUserDetails() async {
    await loadUserDetails();
  }

  /// Retry only repositories loading
  Future<void> retryRepositories() async {
    await loadUserRepositories();
  }

  /// Clear any existing error
  void clearError() {
    // Force refresh to clear error
    refresh();
  }

  @override
  void onDispose() {
    // Cancel all active subscriptions to prevent memory leaks
    _userSubscription?.cancel();
    _reposSubscription?.cancel();

    // Clear subscription references
    _userSubscription = null;
    _reposSubscription = null;

    // Clear cached results to free memory
    _userResult = null;
    _repositoriesResult = null;

    // Reset pagination state
    _endCursor = null;
    _hasNextPage = true;

    // Note: super.dispose() is called by DisposableViewModel.dispose()
  }
}
