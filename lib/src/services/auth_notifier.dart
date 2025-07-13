import 'package:flutter/foundation.dart';
import 'package:gh3/src/services/auth_service.dart';

/// Notifier exposing AuthService state for GoRouter refresh and redirect logic.
class AuthNotifier extends ChangeNotifier {
  final AuthService _authService;
  bool loading = true;
  bool loggedIn = false;

  AuthNotifier(this._authService) {
    _init();
  }

  Future<void> _init() async {
    await _authService.init();
    loggedIn = _authService.isLoggedIn;
    loading = false;
    notifyListeners();
  }

  Future<void> login() async {
    await _authService.login();
    loggedIn = _authService.isLoggedIn;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    loggedIn = false;
    notifyListeners();
  }
}
