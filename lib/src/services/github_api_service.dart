import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import '../models/github_user.dart';
import '../models/github_repository.dart';
import 'token_storage.dart';

/// Exception thrown when GitHub API operations fail
class GitHubApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorType;

  const GitHubApiException(this.message, {this.statusCode, this.errorType});

  @override
  String toString() => 'GitHubApiException: $message';
}

/// Service for interacting with GitHub's REST API
@injectable
class GitHubApiService {
  final http.Client _httpClient;
  final ITokenStorage _tokenStorage;

  static const String _baseUrl = 'https://api.github.com';
  static const Duration _requestTimeout = Duration(seconds: 30);

  const GitHubApiService(this._httpClient, this._tokenStorage);

  /// Get the authenticated user's information
  Future<GitHubUser> getAuthenticatedUser() async {
    final response = await _makeAuthenticatedRequest('GET', '/user');
    return GitHubUser.fromJson(response);
  }

  /// Get a specific user by username
  Future<GitHubUser> getUser(String username) async {
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }

    final response = await _makeAuthenticatedRequest('GET', '/users/$username');
    return GitHubUser.fromJson(response);
  }

  /// Get users that the authenticated user follows
  Future<List<GitHubUser>> getFollowing({
    int page = 1,
    int perPage = 30,
  }) async {
    if (page < 1) throw ArgumentError('Page must be >= 1');
    if (perPage < 1 || perPage > 100) {
      throw ArgumentError('Per page must be between 1 and 100');
    }

    final response = await _makeAuthenticatedRequest(
      'GET',
      '/user/following',
      queryParams: {'page': page.toString(), 'per_page': perPage.toString()},
    );

    if (response is! List) {
      throw GitHubApiException('Expected list response for following users');
    }

    return response
        .cast<Map<String, dynamic>>()
        .map((json) => GitHubUser.fromJson(json))
        .toList();
  }

  /// Get users that follow a specific user
  Future<List<GitHubUser>> getUserFollowers(
    String username, {
    int page = 1,
    int perPage = 30,
  }) async {
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    if (page < 1) throw ArgumentError('Page must be >= 1');
    if (perPage < 1 || perPage > 100) {
      throw ArgumentError('Per page must be between 1 and 100');
    }

    final response = await _makeAuthenticatedRequest(
      'GET',
      '/users/$username/followers',
      queryParams: {'page': page.toString(), 'per_page': perPage.toString()},
    );

    if (response is! List) {
      throw GitHubApiException('Expected list response for user followers');
    }

    return response
        .cast<Map<String, dynamic>>()
        .map((json) => GitHubUser.fromJson(json))
        .toList();
  }

  /// Get repositories for a specific user
  Future<List<GitHubRepository>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 30,
    String sort = 'updated',
    String direction = 'desc',
  }) async {
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    if (page < 1) throw ArgumentError('Page must be >= 1');
    if (perPage < 1 || perPage > 100) {
      throw ArgumentError('Per page must be between 1 and 100');
    }
    if (!['created', 'updated', 'pushed', 'full_name'].contains(sort)) {
      throw ArgumentError('Invalid sort parameter');
    }
    if (!['asc', 'desc'].contains(direction)) {
      throw ArgumentError('Invalid direction parameter');
    }

    final response = await _makeAuthenticatedRequest(
      'GET',
      '/users/$username/repos',
      queryParams: {
        'page': page.toString(),
        'per_page': perPage.toString(),
        'sort': sort,
        'direction': direction,
      },
    );

    if (response is! List) {
      throw GitHubApiException('Expected list response for user repositories');
    }

    return response
        .cast<Map<String, dynamic>>()
        .map((json) => GitHubRepository.fromJson(json))
        .toList();
  }

  /// Get a specific repository
  Future<GitHubRepository> getRepository(String owner, String repo) async {
    if (owner.isEmpty) throw ArgumentError('Owner cannot be empty');
    if (repo.isEmpty) throw ArgumentError('Repository name cannot be empty');

    final response = await _makeAuthenticatedRequest(
      'GET',
      '/repos/$owner/$repo',
    );
    return GitHubRepository.fromJson(response);
  }

  /// Get repository README content
  Future<String> getRepositoryReadme(String owner, String repo) async {
    if (owner.isEmpty) throw ArgumentError('Owner cannot be empty');
    if (repo.isEmpty) throw ArgumentError('Repository name cannot be empty');

    try {
      final response = await _makeAuthenticatedRequest(
        'GET',
        '/repos/$owner/$repo/readme',
      );

      final content = response['content'] as String?;
      if (content == null) {
        throw GitHubApiException('README content not found');
      }

      // GitHub returns base64 encoded content
      final decodedBytes = base64Decode(content.replaceAll('\n', ''));
      return utf8.decode(decodedBytes);
    } on GitHubApiException catch (e) {
      if (e.statusCode == 404) {
        throw GitHubApiException(
          'README not found for repository $owner/$repo',
        );
      }
      rethrow;
    }
  }

  /// Make an authenticated HTTP request to GitHub API
  Future<dynamic> _makeAuthenticatedRequest(
    String method,
    String path, {
    Map<String, String>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    final token = await _tokenStorage.getToken();
    if (token == null) {
      throw GitHubApiException('No authentication token available');
    }

    final uri = Uri.parse('$_baseUrl$path');
    final finalUri = queryParams != null
        ? uri.replace(queryParameters: queryParams)
        : uri;

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'gh3-flutter-app',
      'X-GitHub-Api-Version': '2022-11-28',
    };

    if (body != null) {
      headers['Content-Type'] = 'application/json';
    }

    try {
      late http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _httpClient
              .get(finalUri, headers: headers)
              .timeout(_requestTimeout);
          break;
        case 'POST':
          response = await _httpClient
              .post(
                finalUri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(_requestTimeout);
          break;
        case 'PUT':
          response = await _httpClient
              .put(
                finalUri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(_requestTimeout);
          break;
        case 'DELETE':
          response = await _httpClient
              .delete(finalUri, headers: headers)
              .timeout(_requestTimeout);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } on TimeoutException {
      throw GitHubApiException(
        'Request timed out after ${_requestTimeout.inSeconds} seconds',
      );
    } on SocketException catch (e) {
      throw GitHubApiException('Network error: ${e.message}');
    } on http.ClientException catch (e) {
      throw GitHubApiException('HTTP client error: ${e.message}');
    }
  }

  /// Handle HTTP response and parse JSON
  dynamic _handleResponse(http.Response response) {
    // Handle rate limiting
    if (response.statusCode == 403) {
      final rateLimitRemaining = response.headers['x-ratelimit-remaining'];
      if (rateLimitRemaining == '0') {
        final resetTime = response.headers['x-ratelimit-reset'];
        throw GitHubApiException(
          'GitHub API rate limit exceeded. Resets at: $resetTime',
          statusCode: 403,
          errorType: 'rate_limit',
        );
      }
    }

    // Handle authentication errors
    if (response.statusCode == 401) {
      throw GitHubApiException(
        'Authentication failed. Token may be invalid or expired.',
        statusCode: 401,
        errorType: 'authentication',
      );
    }

    // Handle not found
    if (response.statusCode == 404) {
      throw GitHubApiException(
        'Resource not found',
        statusCode: 404,
        errorType: 'not_found',
      );
    }

    // Handle server errors
    if (response.statusCode >= 500) {
      throw GitHubApiException(
        'GitHub server error (${response.statusCode})',
        statusCode: response.statusCode,
        errorType: 'server_error',
      );
    }

    // Handle other client errors
    if (response.statusCode >= 400) {
      String errorMessage = 'GitHub API error (${response.statusCode})';

      try {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        final message = errorBody['message'] as String?;
        if (message != null) {
          errorMessage = message;
        }
      } catch (_) {
        // If we can't parse the error body, use the default message
      }

      throw GitHubApiException(
        errorMessage,
        statusCode: response.statusCode,
        errorType: 'client_error',
      );
    }

    // Parse successful response
    if (response.body.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(response.body);
    } catch (e) {
      throw GitHubApiException('Failed to parse response JSON: $e');
    }
  }
}
