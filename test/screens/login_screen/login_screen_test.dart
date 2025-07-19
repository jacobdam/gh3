import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gh3/src/screens/login_screen/login_screen.dart';
import 'package:gh3/src/screens/login_screen/login_viewmodel.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';

class DummyGithubAuthClient implements GithubAuthClient {
  @override
  Future<GithubDeviceCodeResult> createDeviceCode(List<String> scopes) async =>
      throw UnimplementedError();
  @override
  Future<String> createAccessTokenFromDeviceCode(String deviceCode) async =>
      throw UnimplementedError();
}

class DummyAuthService implements AuthService {
  @override
  String? get accessToken => null;
  @override
  bool get isLoggedIn => false;
  @override
  Future<void> init() async {}
  @override
  Future<String> login() async => '';
  @override
  Future<String> loginWithDeviceCode(String deviceCode) async => '';
  @override
  Future<void> logout() async {}
}

class DummyAuthViewModel extends AuthViewModel {
  DummyAuthViewModel() : super(DummyAuthService());
  @override
  bool loggedIn = false;
  @override
  bool loading = false;
  @override
  Future<void> init() async {}
  @override
  Future<void> logout() async {}
  @override
  void updateAuthState() {}
}

class FakeLoginViewModel extends LoginViewModel {
  FakeLoginViewModel()
    : super(DummyGithubAuthClient(), DummyAuthService(), DummyAuthViewModel());
  @override
  bool get isLoading => false;
  @override
  String? get userCode => null;
  @override
  String? get errorMessage => null;
}

void main() {
  testWidgets('LoginScreen renders sign in button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(viewModel: FakeLoginViewModel())),
    );
    expect(find.text('Sign in with GitHub'), findsOneWidget);
  });
}
