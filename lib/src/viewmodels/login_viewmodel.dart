import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../services/github_auth_client.dart';

/// ViewModel for handling GitHub device-flow login logic.
@injectable
class LoginViewModel extends ChangeNotifier {
  final GithubAuthClient _authClient;

  LoginViewModel(this._authClient);

  bool _isLoading = false;
  String? _userCode;
  String? _accessToken;
  String? _errorMessage;

  /// Whether a login flow is in progress.
  bool get isLoading => _isLoading;

  /// The user code to show for device login.
  String? get userCode => _userCode;

  /// The obtained GitHub access token, if authorized.
  String? get accessToken => _accessToken;

  /// Any error message encountered during login.
  String? get errorMessage => _errorMessage;

  /// Whether the user has successfully authorized.
  bool get isAuthorized => _accessToken != null;

  /// Starts the device-login flow: creates a device code, then polls for an access token.
  Future<void> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Request a device code and user code
      final deviceResult = await _authClient.createDeviceCode(_scopes);
      _userCode = deviceResult.userCode;
      _isLoading = false;
      notifyListeners();

      // Poll for access token
      while (true) {
        try {
          final token = await _authClient.createAccessTokenFromDeviceCode(
            deviceResult.deviceCode,
          );
          _accessToken = token;
          notifyListeners();
          break;
        } on AuthorizationPendingException {
          // User hasn't authorized yet
          await Future.delayed(const Duration(seconds: 5));
        } on SlowDownException {
          // Slow down polling
          await Future.delayed(const Duration(seconds: 10));
        } on AccessDeniedException {
          _errorMessage = 'Access denied';
          notifyListeners();
          break;
        } on GithubAuthException catch (e) {
          _errorMessage = e.message;
          notifyListeners();
          break;
        }
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Scopes for GitHub authorization.
  static const List<String> _scopes = ['repo', 'read:user'];
}
