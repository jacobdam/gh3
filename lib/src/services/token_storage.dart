import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interface for token storage implementations.
abstract class ITokenStorage {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
}

@LazySingleton(as: ITokenStorage)
class PrefsTokenStorage implements ITokenStorage {
  static const _tokenKey = 'github_access_token';

  /// Retrieves the saved access token, if any.
  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Saves the access token to storage.
  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Deletes the saved access token from storage.
  @override
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
