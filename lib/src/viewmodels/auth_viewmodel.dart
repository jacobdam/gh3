import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:gh3/src/services/auth_service.dart';

/// ViewModel exposing AuthService init and login state for GoRouter refresh/redirect.
@lazySingleton
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  bool loading = true;
  bool loggedIn = false;

  AuthViewModel(this._authService);

  Future<void> init() async {
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
