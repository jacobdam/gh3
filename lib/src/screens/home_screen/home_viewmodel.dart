import 'dart:async';
import 'package:ferry/ferry.dart';
import '../base_viewmodel.dart';
import '../../services/graphql_error_handler.dart';
import '__generated__/home_viewmodel.req.gql.dart';
import '__generated__/home_viewmodel.data.gql.dart';
import '__generated__/home_viewmodel.var.gql.dart';

class HomeViewModel extends DisposableViewModel {
  final Client _ferryClient;

  HomeViewModel(this._ferryClient);

  // Store raw GraphQL results - no model conversion
  OperationResponse<GGetFollowingData, GGetFollowingVars>? _followingResult;
  StreamSubscription<OperationResponse<GGetFollowingData, GGetFollowingVars>>?
  _followingSubscription;

  // Pagination state
  String? _endCursor;
  bool _hasNextPage = true;
  static const int _pageSize = 20;

  // Expose raw GraphQL data for UI consumption
  GGetFollowingData_viewer_following? get following =>
      _followingResult?.data?.viewer.following;

  List<GGetFollowingData_viewer_following_nodes> get followingUsers =>
      following?.nodes
          ?.cast<GGetFollowingData_viewer_following_nodes>()
          .toList() ??
      [];

  bool get isLoading => _followingResult?.loading ?? true;
  bool get hasMore => _hasNextPage;
  bool get isEmpty => followingUsers.isEmpty;

  String? get error {
    if (_followingResult != null) {
      final linkException = _followingResult!.linkException;
      final graphqlErrors = _followingResult!.graphqlErrors;
      
      if (linkException != null || (graphqlErrors != null && graphqlErrors.isNotEmpty)) {
        return GraphQLErrorHandler.getErrorMessage(_followingResult!);
      }
    }
    return null;
  }

  /// Load the initial list of following users via GraphQL
  Future<void> loadFollowingUsers() async {
    _endCursor = null;
    _hasNextPage = true;

    final request = GGetFollowingReq(
      (b) => b
        ..vars.first = _pageSize
        ..vars.after = null,
    );

    _followingSubscription?.cancel();
    _followingSubscription = _ferryClient.request(request).listen((result) {
      _followingResult = result;

      if (result.data != null) {
        final pageInfo = result.data!.viewer.following.pageInfo;
        _hasNextPage = pageInfo.hasNextPage;
        _endCursor = pageInfo.endCursor;
      }

      notifyListeners();
    });
  }

  /// Load more following users (pagination)
  Future<void> loadMoreFollowingUsers() async {
    if (isLoading || !_hasNextPage || _endCursor == null) return;

    final request = GGetFollowingReq(
      (b) => b
        ..vars.first = _pageSize
        ..vars.after = _endCursor,
    );

    // For pagination, we'll need to merge results
    // This is a simplified approach - in production you might want more sophisticated caching
    _ferryClient.request(request).listen((result) {
      if (result.data?.viewer.following != null) {
        final newFollowing = result.data!.viewer.following;

        // Update pagination info
        final pageInfo = newFollowing.pageInfo;
        _hasNextPage = pageInfo.hasNextPage;
        _endCursor = pageInfo.endCursor;

        // For simplicity, just trigger a refresh - in production you'd merge properly
        notifyListeners();
      }
    });
  }

  /// Refresh the following users list
  Future<void> refreshFollowingUsers() async {
    await loadFollowingUsers();
  }

  /// Clear any existing error
  void clearError() {
    // Force refresh to clear error
    loadFollowingUsers();
  }

  @override
  void onDispose() {
    _followingSubscription?.cancel();
    _followingSubscription = null;
    _followingResult = null;
  }
}
