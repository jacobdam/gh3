import 'package:flutter/foundation.dart';

import '../models/github_repository.dart';
import '../services/github_api_service.dart';

class RepositoryDetailsViewModel extends ChangeNotifier {
  final GitHubApiService _apiService;
  final String owner;
  final String repositoryName;

  RepositoryDetailsViewModel(this._apiService, this.owner, this.repositoryName);

  GitHubRepository? _repository;
  String? _readmeContent;
  bool _isLoadingRepository = false;
  bool _isLoadingReadme = false;
  String? _repositoryError;
  String? _readmeError;

  GitHubRepository? get repository => _repository;
  String? get readmeContent => _readmeContent;
  bool get isLoadingRepository => _isLoadingRepository;
  bool get isLoadingReadme => _isLoadingReadme;
  String? get repositoryError => _repositoryError;
  String? get readmeError => _readmeError;
  bool get hasReadme => _readmeContent != null && _readmeContent!.isNotEmpty;

  /// Load repository information
  Future<void> loadRepository() async {
    if (_isLoadingRepository) return;

    _setLoadingRepository(true);
    _clearRepositoryError();

    try {
      final repository = await _apiService.getRepository(owner, repositoryName);
      _repository = repository;
      notifyListeners();
    } catch (e) {
      _setRepositoryError(_getErrorMessage(e));
    } finally {
      _setLoadingRepository(false);
    }
  }

  /// Load repository README content
  Future<void> loadReadme() async {
    if (_isLoadingReadme) return;

    _setLoadingReadme(true);
    _clearReadmeError();

    try {
      final readmeContent = await _apiService.getRepositoryReadme(owner, repositoryName);
      _readmeContent = readmeContent;
      notifyListeners();
    } catch (e) {
      final errorMessage = _getErrorMessage(e);
      if (errorMessage.contains('README not found')) {
        // Don't show error for missing README, just leave it empty
        _readmeContent = null;
      } else {
        _setReadmeError(errorMessage);
      }
    } finally {
      _setLoadingReadme(false);
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadRepository(),
      loadReadme(),
    ]);
  }

  /// Clear repository error
  void clearRepositoryError() {
    _clearRepositoryError();
    notifyListeners();
  }

  /// Clear README error
  void clearReadmeError() {
    _clearReadmeError();
    notifyListeners();
  }

  void _setLoadingRepository(bool loading) {
    _isLoadingRepository = loading;
    notifyListeners();
  }

  void _setLoadingReadme(bool loading) {
    _isLoadingReadme = loading;
    notifyListeners();
  }

  void _setRepositoryError(String error) {
    _repositoryError = error;
    notifyListeners();
  }

  void _setReadmeError(String error) {
    _readmeError = error;
    notifyListeners();
  }

  void _clearRepositoryError() {
    _repositoryError = null;
  }

  void _clearReadmeError() {
    _readmeError = null;
  }

  String _getErrorMessage(dynamic error) {
    if (error is GitHubApiException) {
      switch (error.errorType) {
        case 'authentication':
          return 'Authentication failed. Please log in again.';
        case 'rate_limit':
          return 'GitHub API rate limit exceeded. Please try again later.';
        case 'not_found':
          return 'Repository not found.';
        case 'network_error':
          return 'Network error. Please check your connection.';
        default:
          return error.message;
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}