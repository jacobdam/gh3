import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

class GithubDeviceCodeResult {
  GithubDeviceCodeResult({required this.deviceCode, required this.userCode});

  String deviceCode;
  String userCode;

  factory GithubDeviceCodeResult.fromJson(Map<String, dynamic> json) =>
      GithubDeviceCodeResult(
        deviceCode: json['device_code'],
        userCode: json['user_code'],
      );
}

// Custom exceptions for GitHub OAuth flow
abstract class GithubAuthException implements Exception {
  final String message;
  GithubAuthException([this.message = '']);
  @override
  String toString() => 'GithubAuthException: $message';
}

abstract class GithubRecoverableException extends GithubAuthException {
  GithubRecoverableException([super.message]);
}

class AuthorizationPendingException extends GithubRecoverableException {
  AuthorizationPendingException([super.message = 'Authorization pending']);
}

class SlowDownException extends GithubRecoverableException {
  SlowDownException([super.message = 'Slow down']);
}

class AccessDeniedException extends GithubRecoverableException {
  AccessDeniedException([super.message = 'Access denied']);
}

@injectable
class GithubNonRecoverableException extends GithubAuthException {
  final String code;
  final String description;
  GithubNonRecoverableException(this.code, this.description)
    : super("$code: $description");
}

@module
abstract class GithubAuthHttpClientModule {
  @lazySingleton
  http.Client get httpClient => http.Client();
}

@injectable
class GithubAuthClient {
  final http.Client _httpClient;
  final String _githubClientID;

  // Configuration constants
  static const Duration _requestTimeout = Duration(seconds: 30);
  static const int _maxRetryAttempts = 3;
  static const Duration _baseRetryDelay = Duration(seconds: 1);
  static const Duration _maxRetryDelay = Duration(seconds: 30);

  const GithubAuthClient(
    http.Client httpClient,
    @Named('GithubClientID') String githubClientID,
  ) : _httpClient = httpClient,
      _githubClientID = githubClientID;

  /// Creates a device code for GitHub OAuth device flow.
  /// Implements retry logic with exponential backoff for transient failures.
  Future<GithubDeviceCodeResult> createDeviceCode(List<String> scopes) async {
    if (scopes.isEmpty) {
      throw ArgumentError('Scopes cannot be empty');
    }

    final url = Uri.https('github.com', '/login/device/code', {
      'client_id': _githubClientID,
      'scope': scopes.join(' '),
    });

    return await _executeWithRetry(
      operation: () => _makeDeviceCodeRequest(url),
      operationName: 'createDeviceCode',
    );
  }

  /// Polls GitHub for an access token using the device code.
  /// Handles specific OAuth errors and implements proper error handling.
  Future<String> createAccessTokenFromDeviceCode(String deviceCode) async {
    if (deviceCode.isEmpty) {
      throw ArgumentError('Device code cannot be empty');
    }

    final url = Uri.https('github.com', '/login/oauth/access_token', {
      'client_id': _githubClientID,
      'device_code': deviceCode,
      'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
    });

    try {
      final response = await _makeHttpRequest(
        url,
        'createAccessTokenFromDeviceCode',
      );
      final parsedBody = _parseJsonResponse(
        response,
        'createAccessTokenFromDeviceCode',
      );

      final error = parsedBody['error'] as String?;
      if (error != null) {
        _logError('OAuth error received', {
          'error': error,
          'description': parsedBody['error_description'],
        });

        switch (error) {
          case 'authorization_pending':
            throw AuthorizationPendingException();
          case 'slow_down':
            throw SlowDownException();
          case 'access_denied':
            throw AccessDeniedException();
          default:
            throw GithubNonRecoverableException(
              error,
              parsedBody['error_description'] ?? 'Unknown error',
            );
        }
      }

      final accessToken = parsedBody['access_token'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        throw GithubNonRecoverableException(
          'invalid_response',
          'Access token not found in response',
        );
      }

      _logInfo('Access token obtained successfully');
      return accessToken;
    } catch (e) {
      if (e is GithubAuthException) rethrow;
      _logError('Unexpected error in createAccessTokenFromDeviceCode', {
        'error': e.toString(),
      });
      throw GithubNonRecoverableException(
        'unexpected_error',
        'Failed to obtain access token: ${e.toString()}',
      );
    }
  }

  /// Makes the actual device code request
  Future<GithubDeviceCodeResult> _makeDeviceCodeRequest(Uri url) async {
    final response = await _makeHttpRequest(url, 'createDeviceCode');
    final parsedBody = _parseJsonResponse(response, 'createDeviceCode');

    // Check for OAuth errors in device code response
    final error = parsedBody['error'] as String?;
    if (error != null) {
      _logError('Device code request failed', {
        'error': error,
        'description': parsedBody['error_description'],
      });
      throw GithubNonRecoverableException(
        error,
        parsedBody['error_description'] ?? 'Unknown error',
      );
    }

    try {
      final result = GithubDeviceCodeResult.fromJson(parsedBody);
      _logInfo('Device code created successfully');
      return result;
    } catch (e) {
      _logError('Failed to parse device code response', {
        'error': e.toString(),
      });
      throw GithubNonRecoverableException(
        'invalid_response',
        'Failed to parse device code response: ${e.toString()}',
      );
    }
  }

  /// Makes an HTTP request with timeout and comprehensive error handling
  Future<http.Response> _makeHttpRequest(Uri url, String operationName) async {
    try {
      _logInfo('Making HTTP request', {
        'url': _sanitizeUrl(url),
        'operation': operationName,
      });

      final response = await _httpClient
          .post(
            url,
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'gh3-flutter-app',
            },
          )
          .timeout(_requestTimeout);

      _logInfo('HTTP request completed', {
        'statusCode': response.statusCode,
        'operation': operationName,
      });

      if (response.statusCode == 429) {
        _logWarning('Rate limit exceeded', {'operation': operationName});
        throw GithubNonRecoverableException(
          'rate_limit_exceeded',
          'GitHub API rate limit exceeded. Please try again later.',
        );
      }

      if (response.statusCode >= 500) {
        _logError('Server error', {
          'statusCode': response.statusCode,
          'operation': operationName,
        });
        throw GithubNonRecoverableException(
          'server_error',
          'GitHub server error (${response.statusCode}). Please try again later.',
        );
      }

      if (response.statusCode != 200) {
        _logError('Unexpected HTTP status', {
          'statusCode': response.statusCode,
          'operation': operationName,
        });
        throw GithubNonRecoverableException(
          'http_error',
          'HTTP request failed with status ${response.statusCode}',
        );
      }

      return response;
    } on TimeoutException {
      _logError('Request timeout', {
        'operation': operationName,
        'timeout': _requestTimeout.inSeconds,
      });
      throw GithubNonRecoverableException(
        'timeout',
        'Request timed out after ${_requestTimeout.inSeconds} seconds',
      );
    } on SocketException catch (e) {
      _logError('Network error', {
        'operation': operationName,
        'error': e.message,
      });
      throw GithubNonRecoverableException(
        'network_error',
        'Network connection failed: ${e.message}',
      );
    } on http.ClientException catch (e) {
      _logError('HTTP client error', {
        'operation': operationName,
        'error': e.message,
      });
      throw GithubNonRecoverableException(
        'client_error',
        'HTTP client error: ${e.message}',
      );
    }
  }

  /// Parses JSON response with error handling
  Map<String, dynamic> _parseJsonResponse(
    http.Response response,
    String operationName,
  ) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      _logError('JSON parsing failed', {
        'operation': operationName,
        'error': e.toString(),
        'bodyLength': response.body.length,
      });
      throw GithubNonRecoverableException(
        'invalid_response',
        'Failed to parse JSON response: ${e.toString()}',
      );
    }
  }

  /// Executes an operation with retry logic and exponential backoff
  Future<T> _executeWithRetry<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async {
    int attempt = 0;
    Duration delay = _baseRetryDelay;

    while (attempt < _maxRetryAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempt++;

        // Don't retry for certain types of errors
        if (e is GithubAuthException || e is ArgumentError) {
          rethrow;
        }

        if (attempt >= _maxRetryAttempts) {
          _logError('Max retry attempts reached', {
            'operation': operationName,
            'attempts': attempt,
            'finalError': e.toString(),
          });
          rethrow;
        }

        _logWarning('Operation failed, retrying', {
          'operation': operationName,
          'attempt': attempt,
          'maxAttempts': _maxRetryAttempts,
          'delay': delay.inSeconds,
          'error': e.toString(),
        });

        await Future.delayed(delay);

        // Exponential backoff with jitter
        delay = Duration(
          milliseconds: min(
            _maxRetryDelay.inMilliseconds,
            (delay.inMilliseconds * 2) + Random().nextInt(1000),
          ),
        );
      }
    }

    throw StateError('This should never be reached');
  }

  /// Sanitizes URL for logging (removes sensitive parameters)
  String _sanitizeUrl(Uri url) {
    final sanitizedQuery = <String, String>{};
    url.queryParameters.forEach((key, value) {
      if (key == 'client_id' || key == 'device_code') {
        sanitizedQuery[key] = '[REDACTED]';
      } else {
        sanitizedQuery[key] = value;
      }
    });

    return url.replace(queryParameters: sanitizedQuery).toString();
  }

  /// Logging methods using debugPrint for development
  void _logInfo(String message, [Map<String, dynamic>? context]) {
    debugPrint(
      '[GithubAuthClient] INFO: $message${context != null ? ' - $context' : ''}',
    );
  }

  void _logWarning(String message, [Map<String, dynamic>? context]) {
    debugPrint(
      '[GithubAuthClient] WARNING: $message${context != null ? ' - $context' : ''}',
    );
  }

  void _logError(String message, [Map<String, dynamic>? context]) {
    debugPrint(
      '[GithubAuthClient] ERROR: $message${context != null ? ' - $context' : ''}',
    );
  }
}
