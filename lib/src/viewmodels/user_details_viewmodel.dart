import 'package:flutter/foundation.dart';

import '../models/github_user.dart';
import '../models/github_repository.dart';
import '../services/github_api_service.dart';

class UserDetailsViewModel extends ChangeNotifier {
  final GitHubApiService _apiService;
  final String username;

  UserDetailsViewModel(this._apiService, this.username);

  GitHubUser? _user;
  List<GitHubRepository> _repositories = [];
  bool _isLoadingUser = false;
  bool _isLoadingRepositories = false;
  String? _userError;
  String? _repositoriesError;
  bool _hasMoreRepositories = true;
  int _currentPage = 1;
  static const int _perPage = 30;
  String _sortBy = 'updated';
  String _sortDirection = 'desc';

  GitHubUser? get user => _user;
  List<GitHubRepository> get repositories => _repositories;
  bool get isLoadingUser => _isLoadingUser;
  bool get isLoadingRepositories => _isLoadingRepositories;
  String? get userError => _userError;
  String? get repositoriesError => _repositoriesError;
  bool get hasMoreRepositories => _hasMoreRepositories;
  String get sortBy => _sortBy;
  String get sortDirection => _sortDirection;
  bool get isRepositoriesEmpty =>
      _repositories.isEmpty && !_isLoadingRepositories;

  /// Load user profile information
  Future<void> loadUser() async {
    if (_isLoadingUser) return;

    _setLoadingUser(true);
    _clearUserError();

    try {
      final user = await _apiService.getUser(username);
      _user = user;
      notifyListeners();
    } catch (e) {
      _setUserError(_getErrorMessage(e));
    } finally {
      _setLoadingUser(false);
    }
  }

  /// Load user repositories
  Future<void> loadRepositories() async {
    if (_isLoadingRepositories) return;

    _setLoadingRepositories(true);
    _clearRepositoriesError();

    try {
      final repositories = await _apiService.getUserRepositories(
        username,
        page: 1,
        perPage: _perPage,
        sort: _sortBy,
        direction: _sortDirection,
      );

      _repositories = repositories;
      _currentPage = 1;
      _hasMoreRepositories = repositories.length == _perPage;

      notifyListeners();
    } catch (e) {
      _setRepositoriesError(_getErrorMessage(e));
    } finally {
      _setLoadingRepositories(false);
    }
  }

  /// Load more repositories (pagination)
  Future<void> loadMoreRepositories() async {
    if (_isLoadingRepositories || !_hasMoreRepositories) return;

    _setLoadingRepositories(true);
    _clearRepositoriesError();

    try {
      final repositories = await _apiService.getUserRepositories(
        username,
        page: _currentPage + 1,
        perPage: _perPage,
        sort: _sortBy,
        direction: _sortDirection,
      );

      if (repositories.isNotEmpty) {
        _repositories.addAll(repositories);
        _currentPage++;
        _hasMoreRepositories = repositories.length == _perPage;
      } else {
        _hasMoreRepositories = false;
      }

      notifyListeners();
    } catch (e) {
      _setRepositoriesError(_getErrorMessage(e));
    } finally {
      _setLoadingRepositories(false);
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    _repositories.clear();
    _currentPage = 1;
    _hasMoreRepositories = true;

    await Future.wait([loadUser(), loadRepositories()]);
  }

  /// Change repository sorting
  Future<void> changeSorting(String sortBy, String direction) async {
    if (_sortBy == sortBy && _sortDirection == direction) return;

    _sortBy = sortBy;
    _sortDirection = direction;
    _repositories.clear();
    _currentPage = 1;
    _hasMoreRepositories = true;

    await loadRepositories();
  }

  /// Clear user error
  void clearUserError() {
    _clearUserError();
    notifyListeners();
  }

  /// Clear repositories error
  void clearRepositoriesError() {
    _clearRepositoriesError();
    notifyListeners();
  }

  void _setLoadingUser(bool loading) {
    _isLoadingUser = loading;
    notifyListeners();
  }

  void _setLoadingRepositories(bool loading) {
    _isLoadingRepositories = loading;
    notifyListeners();
  }

  void _setUserError(String error) {
    _userError = error;
    notifyListeners();
  }

  void _setRepositoriesError(String error) {
    _repositoriesError = error;
    notifyListeners();
  }

  void _clearUserError() {
    _userError = null;
  }

  void _clearRepositoriesError() {
    _repositoriesError = null;
  }

  String _getErrorMessage(dynamic error) {
    if (error is GitHubApiException) {
      switch (error.errorType) {
        case 'authentication':
          return 'Authentication failed. Please log in again.';
        case 'rate_limit':
          return 'GitHub API rate limit exceeded. Please try again later.';
        case 'not_found':
          return 'User not found.';
        case 'network_error':
          return 'Network error. Please check your connection.';
        default:
          return error.message;
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
