import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/viewmodels/auth_viewmodel.dart';
import 'package:gh3/src/screens/login_screen/login_viewmodel.dart';

// A fake implementation of GithubAuthClient to control behavior in tests.
class FakeGithubAuthClient implements GithubAuthClient {
  final List<Exception> _accessTokenResponses;
  final GithubDeviceCodeResult deviceResult;

  FakeGithubAuthClient({
    required this.deviceResult,
    List<Exception>? accessTokenErrors,
    String? successToken,
  }) : _accessTokenResponses = accessTokenErrors ?? [],
       _accessTokenSuccess = successToken ?? '';

  late final String _accessTokenSuccess;

  @override
  Future<GithubDeviceCodeResult> createDeviceCode(List<String> scopes) async {
    return deviceResult;
  }

  @override
  Future<String> createAccessTokenFromDeviceCode(String deviceCode) async {
    if (_accessTokenResponses.isNotEmpty) {
      final e = _accessTokenResponses.removeAt(0);
      throw e;
    }
    return _accessTokenSuccess;
  }
}

// A fake client that fails to get device code
class FailGithubAuthClient implements GithubAuthClient {
  @override
  Future<GithubDeviceCodeResult> createDeviceCode(List<String> scopes) =>
      throw Exception('fail dev');

  @override
  Future<String> createAccessTokenFromDeviceCode(String deviceCode) async => '';
}

// Mock AuthService for testing
class MockAuthService implements AuthService {
  bool _isLoggedIn = false;
  String? _accessToken;
  final FakeGithubAuthClient? _fakeClient;

  MockAuthService([this._fakeClient]);

  @override
  String? get accessToken => _accessToken;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  Future<void> init() async {}

  @override
  Future<String> login() async {
    throw UnimplementedError('Use loginWithDeviceCode instead');
  }

  @override
  Future<String> loginWithDeviceCode(String deviceCode) async {
    if (_fakeClient != null) {
      // Simulate the same polling logic as the real AuthService
      while (true) {
        try {
          final token = await _fakeClient.createAccessTokenFromDeviceCode(
            deviceCode,
          );
          _accessToken = token;
          _isLoggedIn = true;
          return token;
        } on AuthorizationPendingException {
          // Continue polling (no delay for tests)
          continue;
        } on SlowDownException {
          // Continue polling (no delay for tests)
          continue;
        } catch (e) {
          // Other exceptions break the loop
          rethrow;
        }
      }
    } else {
      _accessToken = 'mock_token';
      _isLoggedIn = true;
      return _accessToken!;
    }
  }

  @override
  Future<void> logout() async {
    _accessToken = null;
    _isLoggedIn = false;
  }
}

// Mock AuthViewModel for testing
class MockAuthViewModel extends ChangeNotifier implements AuthViewModel {
  @override
  bool loggedIn = false;

  @override
  bool loading = false;

  @override
  Future<void> init() async {}

  @override
  Future<void> logout() async {}

  @override
  void updateAuthState() {
    loggedIn = true;
    notifyListeners();
  }
}

void main() {
  group('LoginViewModel', () {
    test(
      'successful login sets userCode and triggers auth state update',
      () async {
        final fake = FakeGithubAuthClient(
          deviceResult: GithubDeviceCodeResult(
            deviceCode: 'dc',
            userCode: 'uc',
          ),
          successToken: 'token123',
        );
        final mockAuthService = MockAuthService(fake);
        final mockAuthViewModel = MockAuthViewModel();
        final vm = LoginViewModel(fake, mockAuthService, mockAuthViewModel);

        expect(vm.isLoading, isFalse);
        final future = vm.login();
        expect(vm.isLoading, isTrue);

        await future;

        expect(vm.isLoading, isFalse);
        expect(vm.userCode, 'uc');
        expect(vm.isAuthorized, isTrue); // Uses AuthService.isLoggedIn
        expect(vm.errorMessage, isNull);
        expect(mockAuthViewModel.loggedIn, isTrue); // AuthViewModel was updated
      },
    );

    test('pending then success polling', () async {
      final fake = FakeGithubAuthClient(
        deviceResult: GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        accessTokenErrors: [AuthorizationPendingException()],
        successToken: 'tok',
      );
      final mockAuthService = MockAuthService(fake);
      final mockAuthViewModel = MockAuthViewModel();
      final vm = LoginViewModel(fake, mockAuthService, mockAuthViewModel);

      await vm.login();
      expect(vm.isAuthorized, isTrue);
      expect(vm.errorMessage, isNull);
    });

    test('slowDown then success polling', () async {
      final fake = FakeGithubAuthClient(
        deviceResult: GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        accessTokenErrors: [SlowDownException()],
        successToken: 'tok2',
      );
      final mockAuthService = MockAuthService(fake);
      final mockAuthViewModel = MockAuthViewModel();
      final vm = LoginViewModel(fake, mockAuthService, mockAuthViewModel);

      await vm.login();
      expect(vm.isAuthorized, isTrue);
      expect(vm.errorMessage, isNull);
    });

    test('accessDenied stops polling and sets error', () async {
      final fake = FakeGithubAuthClient(
        deviceResult: GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        accessTokenErrors: [AccessDeniedException()],
      );
      final mockAuthService = MockAuthService(fake);
      final mockAuthViewModel = MockAuthViewModel();
      final vm = LoginViewModel(fake, mockAuthService, mockAuthViewModel);

      await vm.login();
      expect(vm.isAuthorized, isFalse);
      expect(vm.errorMessage, 'Access denied');
    });

    test('non-recoverable maps error message', () async {
      final nonRec = GithubNonRecoverableException('bad', 'desc');
      final fake = FakeGithubAuthClient(
        deviceResult: GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        accessTokenErrors: [nonRec],
      );
      final mockAuthService = MockAuthService(fake);
      final mockAuthViewModel = MockAuthViewModel();
      final vm = LoginViewModel(fake, mockAuthService, mockAuthViewModel);

      await vm.login();
      expect(vm.isAuthorized, isFalse);
      expect(vm.errorMessage, nonRec.message);
    });

    test('error during createDeviceCode sets error', () async {
      final mockAuthService = MockAuthService();
      final mockAuthViewModel = MockAuthViewModel();
      final vm = LoginViewModel(
        FailGithubAuthClient(),
        mockAuthService,
        mockAuthViewModel,
      );

      await vm.login();
      expect(vm.isAuthorized, isFalse);
      expect(vm.errorMessage, contains('fail dev'));
    });
  });
}
