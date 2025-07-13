import 'package:injectable/injectable.dart';
// Removed direct SharedPreferences usage; using ITokenStorage
import 'github_auth_client.dart';
import 'token_storage.dart';
import 'scope_service.dart';

@lazySingleton
class AuthService {
  final GithubAuthClient _authClient;
  final ITokenStorage _tokenStorage;
  final IScopeService _scopeService;
  // Scopes required for GitHub operations
  static const List<String> _requiredScopes = ['repo', 'read:user'];
  String? _accessToken;

  AuthService(this._authClient, this._tokenStorage, this._scopeService);

  /// Initialize service: load token from storage and validate.
  Future<void> init() async {
    // Load existing token
    final token = await _tokenStorage.getToken();
    if (token != null) {
      final valid = await _checkTokenValid(token);
      if (valid) {
        _accessToken = token;
      } else {
        await _tokenStorage.deleteToken();
      }
    }
  }

  Future<bool> _checkTokenValid(String token) async {
    // Validate token by fetching associated scopes
    try {
      final scopes = await _scopeService.getScopesFromAccessToken(token);
      return _requiredScopes.every((scope) => scopes.contains(scope));
    } catch (_) {
      return false;
    }
  }

  // Scopes are fetched via IScopeService

  /// Current access token.
  String? get accessToken => _accessToken;

  /// Whether user is logged in.
  bool get isLoggedIn => _accessToken != null;

  /// Perform login flow: request device code, poll for token, and store it.
  Future<String> login() async {
    // Initiate device flow with required scopes
    final device = await _authClient.createDeviceCode(_requiredScopes);

    while (true) {
      try {
        final token = await _authClient.createAccessTokenFromDeviceCode(
          device.deviceCode,
        );
        _accessToken = token;
        await _tokenStorage.saveToken(token);
        return token;
      } on AuthorizationPendingException {
        await Future.delayed(const Duration(seconds: 5));
      } on SlowDownException {
        await Future.delayed(const Duration(seconds: 10));
      }
    }
  }

  /// Logout and clear stored token.
  Future<void> logout() async {
    _accessToken = null;
    await _tokenStorage.deleteToken();
  }
}
