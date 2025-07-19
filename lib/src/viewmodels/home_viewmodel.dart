import 'package:flutter/foundation.dart';

import '../models/github_user.dart';
import '../services/github_api_service.dart';

class HomeViewModel extends ChangeNotifier {
  final GitHubApiService _apiService;

  HomeViewModel(this._apiService);

  List<GitHubUser> _followingUsers = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _perPage = 30;

  List<GitHubUser> get followingUsers => _followingUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isEmpty => _followingUsers.isEmpty && !_isLoading;

  /// Load the initial list of following users
  Future<void> loadFollowingUsers() async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final users = await _apiService.getFollowing(page: 1, perPage: _perPage);

      _followingUsers = users;
      _currentPage = 1;
      _hasMore = users.length == _perPage;

      notifyListeners();
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  /// Load more following users (pagination)
  Future<void> loadMoreFollowingUsers() async {
    if (_isLoading || !_hasMore) return;

    _setLoading(true);
    _clearError();

    try {
      final users = await _apiService.getFollowing(
        page: _currentPage + 1,
        perPage: _perPage,
      );

      if (users.isNotEmpty) {
        _followingUsers.addAll(users);
        _currentPage++;
        _hasMore = users.length == _perPage;
      } else {
        _hasMore = false;
      }

      notifyListeners();
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh the following users list
  Future<void> refreshFollowingUsers() async {
    _followingUsers.clear();
    _currentPage = 1;
    _hasMore = true;
    await loadFollowingUsers();
  }

  /// Clear any existing error
  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _getErrorMessage(dynamic error) {
    if (error is GitHubApiException) {
      switch (error.errorType) {
        case 'authentication':
          return 'Authentication failed. Please log in again.';
        case 'rate_limit':
          return 'GitHub API rate limit exceeded. Please try again later.';
        case 'network_error':
          return 'Network error. Please check your connection.';
        default:
          return error.message;
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
