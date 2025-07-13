import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/token_storage.dart';
import 'package:gh3/src/services/scope_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    late FakeAuthClient fakeAuthClient;
    late FakeScopeService fakeScopeService;
    late ITokenStorage tokenStorage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      fakeAuthClient = FakeAuthClient();
      fakeScopeService = FakeScopeService();
      tokenStorage = PrefsTokenStorage();
      authService = AuthService(fakeAuthClient, tokenStorage, fakeScopeService);
    });

    test('init sets accessToken when scopes present', () async {
      SharedPreferences.setMockInitialValues({'github_access_token': 'token1'});
      fakeScopeService.scopes = ['repo', 'read:user'];

      await authService.init();

      expect(authService.accessToken, 'token1');
      expect(authService.isLoggedIn, isTrue);
    });

    test('init clears token when scopes missing', () async {
      SharedPreferences.setMockInitialValues({'github_access_token': 'token1'});
      fakeScopeService.scopes = ['read:user'];

      await authService.init();

      expect(authService.accessToken, isNull);
      expect(authService.isLoggedIn, isFalse);
    });

    test('login completes and stores token', () async {
      fakeAuthClient.deviceCodeResult = GithubDeviceCodeResult(
        deviceCode: 'dc',
        userCode: 'uc',
      );
      fakeAuthClient.nextToken = 'new_token';

      final token = await authService.login();

      expect(token, 'new_token');
      expect(authService.accessToken, 'new_token');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('github_access_token'), 'new_token');
    });

    test('logout clears token', () async {
      SharedPreferences.setMockInitialValues({'github_access_token': 'token1'});
      fakeScopeService.scopes = ['repo', 'read:user'];

      await authService.init();
      await authService.logout();

      expect(authService.accessToken, isNull);
      expect(authService.isLoggedIn, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('github_access_token'), isNull);
    });
  });
}

// Fake implementations
class FakeAuthClient implements GithubAuthClient {
  late GithubDeviceCodeResult deviceCodeResult;
  late String nextToken;

  @override
  Future<GithubDeviceCodeResult> createDeviceCode(List<String> scopes) async =>
      deviceCodeResult;

  @override
  Future<String> createAccessTokenFromDeviceCode(String deviceCode) async =>
      nextToken;
}

class FakeScopeService implements IScopeService {
  List<String> scopes = [];

  @override
  Future<List<String>> getScopesFromAccessToken(String accessToken) async =>
      scopes;
}
