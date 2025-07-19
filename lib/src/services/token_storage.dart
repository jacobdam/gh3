import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Exception thrown when token storage operations fail.
class TokenStorageException implements Exception {
  final String message;
  final Exception? cause;

  const TokenStorageException(this.message, [this.cause]);

  @override
  String toString() => 'TokenStorageException: $message';
}

/// Interface for token storage implementations.
abstract class ITokenStorage {
  /// Retrieves the saved access token, if any.
  /// Returns null if no token is stored.
  /// Throws [TokenStorageException] if storage access fails.
  Future<String?> getToken();

  /// Saves the access token to storage.
  /// Throws [TokenStorageException] if storage write fails.
  /// Throws [ArgumentError] if token is empty or null.
  Future<void> saveToken(String token);

  /// Deletes the saved access token from storage.
  /// Throws [TokenStorageException] if storage access fails.
  Future<void> deleteToken();
}

@LazySingleton(as: ITokenStorage)
class PrefsTokenStorage implements ITokenStorage {
  static const _tokenKey = 'github_access_token';

  /// Retrieves the saved access token, if any.
  @override
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      throw TokenStorageException(
        'Failed to retrieve token from storage',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Saves the access token to storage.
  @override
  Future<void> saveToken(String token) async {
    if (token.isEmpty) {
      throw ArgumentError('Token cannot be empty');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_tokenKey, token);
      if (!success) {
        throw TokenStorageException('Failed to save token to storage');
      }
    } catch (e) {
      if (e is ArgumentError) rethrow;
      throw TokenStorageException(
        'Failed to save token to storage',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Deletes the saved access token from storage.
  @override
  Future<void> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      throw TokenStorageException(
        'Failed to delete token from storage',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
