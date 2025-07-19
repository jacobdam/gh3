import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/token_storage.dart';
import 'package:gh3/src/services/scope_service.dart';
import 'package:gh3/src/services/timer_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_service_test.mocks.dart';

@GenerateMocks([GithubAuthClient, IScopeService, TimerService])
void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockGithubAuthClient fakeAuthClient;
    late MockIScopeService fakeScopeService;
    late MockTimerService fakeTimerService;
    late ITokenStorage tokenStorage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      fakeAuthClient = MockGithubAuthClient();
      fakeScopeService = MockIScopeService();
      fakeTimerService = MockTimerService();
      tokenStorage = PrefsTokenStorage();
      authService = AuthService(
        fakeAuthClient,
        tokenStorage,
        fakeScopeService,
        fakeTimerService,
      );
    });

    test('init sets accessToken when scopes present', () async {
      SharedPreferences.setMockInitialValues({'github_access_token': 'token1'});
      when(
        fakeScopeService.getScopesFromAccessToken(any),
      ).thenAnswer((_) async => ['repo', 'read:user']);

      await authService.init();

      expect(authService.accessToken, 'token1');
      expect(authService.isLoggedIn, isTrue);
    });

    test('init clears token when scopes missing', () async {
      SharedPreferences.setMockInitialValues({'github_access_token': 'token1'});
      when(
        fakeScopeService.getScopesFromAccessToken(any),
      ).thenAnswer((_) async => ['read:user']);

      await authService.init();

      expect(authService.accessToken, isNull);
      expect(authService.isLoggedIn, isFalse);
    });

    test('login completes and stores token', () async {
      when(fakeAuthClient.createDeviceCode(any)).thenAnswer(
        (_) async => GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
      );
      when(
        fakeAuthClient.createAccessTokenFromDeviceCode(any),
      ).thenAnswer((_) async => 'new_token');

      final token = await authService.login();

      expect(token, 'new_token');
      expect(authService.accessToken, 'new_token');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('github_access_token'), 'new_token');
    });

    test('logout clears token', () async {
      SharedPreferences.setMockInitialValues({'github_access_token': 'token1'});
      when(
        fakeScopeService.getScopesFromAccessToken(any),
      ).thenAnswer((_) async => ['repo', 'read:user']);

      await authService.init();
      await authService.logout();

      expect(authService.accessToken, isNull);
      expect(authService.isLoggedIn, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('github_access_token'), isNull);
    });

    test('login uses TimerService for AuthorizationPendingException', () async {
      when(fakeAuthClient.createDeviceCode(any)).thenAnswer(
        (_) async => GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
      );

      int callCount = 0;
      when(fakeAuthClient.createAccessTokenFromDeviceCode(any)).thenAnswer((
        _,
      ) async {
        callCount++;
        if (callCount == 1) {
          throw AuthorizationPendingException();
        } else {
          return 'success_token';
        }
      });
      when(fakeTimerService.delay(any)).thenAnswer((_) async {});

      final token = await authService.login();

      expect(token, 'success_token');
      verify(fakeTimerService.delay(const Duration(seconds: 5))).called(1);
    });

    test('login uses TimerService for SlowDownException', () async {
      when(fakeAuthClient.createDeviceCode(any)).thenAnswer(
        (_) async => GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
      );

      int callCount = 0;
      when(fakeAuthClient.createAccessTokenFromDeviceCode(any)).thenAnswer((
        _,
      ) async {
        callCount++;
        if (callCount == 1) {
          throw SlowDownException();
        } else {
          return 'success_token';
        }
      });
      when(fakeTimerService.delay(any)).thenAnswer((_) async {});

      final token = await authService.login();

      expect(token, 'success_token');
      verify(fakeTimerService.delay(const Duration(seconds: 10))).called(1);
    });
  });
}
