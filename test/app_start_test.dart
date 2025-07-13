import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:gh3/main.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/screens/home_screen.dart';
import 'package:gh3/src/screens/login_screen.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/token_storage.dart';
import 'package:gh3/src/services/scope_service.dart';
import 'package:gh3/src/viewmodels/login_viewmodel.dart';
import 'package:gh3/src/viewmodels/auth_viewmodel.dart';

/// Dummy implementations to satisfy AuthService constructor, not used directly.
class DummyAuthClient implements GithubAuthClient {
  @override
  Future<GithubDeviceCodeResult> createDeviceCode(List<String> scopes) {
    throw UnimplementedError();
  }

  @override
  Future<String> createAccessTokenFromDeviceCode(String deviceCode) {
    throw UnimplementedError();
  }
}

class DummyTokenStorage implements ITokenStorage {
  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> saveToken(String token) async {}

  @override
  Future<void> deleteToken() async {}
}

class DummyScopeService implements IScopeService {
  @override
  Future<List<String>> getScopesFromAccessToken(String accessToken) async => [];
}

/// Fake AuthService that simulates init and login state.
class FakeAuthService extends AuthService {
  final bool _loggedIn;
  FakeAuthService(this._loggedIn)
    : super(DummyAuthClient(), DummyTokenStorage(), DummyScopeService());

  @override
  Future<void> init() async {
    // No delay for testing
  }

  @override
  bool get isLoggedIn => _loggedIn;
}

void main() {
  setUp(() {
    // Reset DI before each test
    GetIt.I.reset();
  });

  testWidgets('eventually shows HomeScreen when already logged in', (
    WidgetTester tester,
  ) async {
    // Register required dependencies
    final fakeAuthService = FakeAuthService(true);
    final dummyAuthClient = DummyAuthClient();

    GetIt.I.registerSingleton<AuthService>(fakeAuthService);
    GetIt.I.registerSingleton<GithubAuthClient>(dummyAuthClient);
    GetIt.I.registerLazySingleton<LoginViewModel>(
      () => LoginViewModel(dummyAuthClient),
    );

    // Create and initialize AuthViewModel
    final authViewModel = AuthViewModel(fakeAuthService);
    await authViewModel.init();
    GetIt.I.registerSingleton(authViewModel);

    await tester.pumpWidget(MyApp(authVM: authViewModel));

    // Wait for router redirects to complete
    await tester.pump();
    await tester.pump();

    // Should show home screen
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('eventually shows LoginScreen when not logged in', (
    WidgetTester tester,
  ) async {
    // Register required dependencies
    final fakeAuthService = FakeAuthService(false);
    final dummyAuthClient = DummyAuthClient();

    GetIt.I.registerSingleton<AuthService>(fakeAuthService);
    GetIt.I.registerSingleton<GithubAuthClient>(dummyAuthClient);
    GetIt.I.registerLazySingleton<LoginViewModel>(
      () => LoginViewModel(dummyAuthClient),
    );

    // Create and initialize AuthViewModel
    final authViewModel = AuthViewModel(fakeAuthService);
    await authViewModel.init();
    GetIt.I.registerSingleton(authViewModel);

    await tester.pumpWidget(MyApp(authVM: authViewModel));

    // Wait for router redirects to complete
    await tester.pump();
    await tester.pump();

    // Should show login screen
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
