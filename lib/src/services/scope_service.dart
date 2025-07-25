import 'dart:async';
import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

/// Exception thrown when scope validation operations fail.
class ScopeValidationException implements Exception {
  final String message;
  final int? statusCode;
  final Exception? cause;

  const ScopeValidationException(this.message, {this.statusCode, this.cause});

  @override
  String toString() => 'ScopeValidationException: $message';
}

/// Interface for fetching scopes from a GitHub access token.
abstract class IScopeService {
  /// Retrieves the scopes associated with the given access token.
  /// Returns a list of scope strings.
  /// Throws [ScopeValidationException] if the token is invalid or API call fails.
  /// Throws [ArgumentError] if the access token is empty or null.
  Future<List<String>> getScopesFromAccessToken(String accessToken);
}

@LazySingleton(as: IScopeService)
class ScopeService implements IScopeService {
  final http.Client _httpClient;
  static const Duration _requestTimeout = Duration(seconds: 10);

  ScopeService(this._httpClient);

  @override
  Future<List<String>> getScopesFromAccessToken(String accessToken) async {
    if (accessToken.isEmpty) {
      throw ArgumentError('Access token cannot be empty');
    }

    try {
      final response = await _httpClient
          .get(
            Uri.https('api.github.com', '/'),
            headers: {'Authorization': 'token $accessToken'},
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 401) {
        throw ScopeValidationException(
          'Invalid or expired access token',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode == 403) {
        throw ScopeValidationException(
          'Access forbidden - rate limit exceeded or token lacks permissions',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode != 200) {
        throw ScopeValidationException(
          'Failed to fetch scopes: ${response.body}',
          statusCode: response.statusCode,
        );
      }

      final scopesHeader = response.headers['x-oauth-scopes'];
      if (scopesHeader == null) {
        throw ScopeValidationException('No scopes found in response headers');
      }

      return scopesHeader.split(',').map((scope) => scope.trim()).toList();
    } on TimeoutException {
      throw ScopeValidationException(
        'Request timeout - GitHub API did not respond within ${_requestTimeout.inSeconds} seconds',
      );
    } on SocketException catch (e) {
      throw ScopeValidationException(
        'Network error - unable to connect to GitHub API',
        cause: e,
      );
    } on http.ClientException catch (e) {
      throw ScopeValidationException('HTTP client error occurred', cause: e);
    } catch (e) {
      if (e is ArgumentError || e is ScopeValidationException) rethrow;
      throw ScopeValidationException(
        'Unexpected error occurred while validating token scopes',
        cause: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
