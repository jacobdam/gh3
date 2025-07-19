import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';
import 'package:gh3/src/screens/login_screen/login_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'login_viewmodel_test.mocks.dart';

@GenerateMocks([GithubAuthClient, AuthService, AuthViewModel])
void main() {
  group('LoginViewModel', () {
    test(
      'successful login sets userCode and triggers auth state update',
      () async {
        final mockAuthClient = MockGithubAuthClient();
        final mockAuthService = MockAuthService();
        final mockAuthViewModel = MockAuthViewModel();

        when(mockAuthClient.createDeviceCode(any)).thenAnswer(
          (_) async => GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        );
        when(
          mockAuthService.loginWithDeviceCode(any),
        ).thenAnswer((_) async => 'token123');
        when(mockAuthService.isLoggedIn).thenReturn(true);
        when(mockAuthViewModel.loggedIn).thenReturn(false);

        final vm = LoginViewModel(
          mockAuthClient,
          mockAuthService,
          mockAuthViewModel,
        );

        expect(vm.isLoading, isFalse);
        final future = vm.login();
        expect(vm.isLoading, isTrue);

        await future;

        expect(vm.isLoading, isFalse);
        expect(vm.userCode, 'uc');
        expect(vm.isAuthorized, isTrue);
        expect(vm.errorMessage, isNull);
        verify(mockAuthViewModel.updateAuthState()).called(1);
      },
    );

    test('pending then success polling', () async {
      final mockAuthClient = MockGithubAuthClient();
      final mockAuthService = MockAuthService();
      final mockAuthViewModel = MockAuthViewModel();

      when(mockAuthClient.createDeviceCode(any)).thenAnswer(
        (_) async => GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
      );
      when(
        mockAuthService.loginWithDeviceCode(any),
      ).thenAnswer((_) async => 'tok');
      when(mockAuthService.isLoggedIn).thenReturn(true);

      final vm = LoginViewModel(
        mockAuthClient,
        mockAuthService,
        mockAuthViewModel,
      );

      await vm.login();
      expect(vm.isAuthorized, isTrue);
      expect(vm.errorMessage, isNull);
    });

    test('slowDown then success polling', () async {
      final mockAuthClient = MockGithubAuthClient();
      final mockAuthService = MockAuthService();
      final mockAuthViewModel = MockAuthViewModel();

      when(mockAuthClient.createDeviceCode(any)).thenAnswer(
        (_) async => GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
      );
      when(
        mockAuthService.loginWithDeviceCode(any),
      ).thenAnswer((_) async => 'tok2');
      when(mockAuthService.isLoggedIn).thenReturn(true);

      final vm = LoginViewModel(
        mockAuthClient,
        mockAuthService,
        mockAuthViewModel,
      );

      await vm.login();
      expect(vm.isAuthorized, isTrue);
      expect(vm.errorMessage, isNull);
    });

    test('accessDenied stops polling and sets error', () async {
      final mockAuthClient = MockGithubAuthClient();
      final mockAuthService = MockAuthService();
      final mockAuthViewModel = MockAuthViewModel();

      when(mockAuthClient.createDeviceCode(any)).thenAnswer(
        (_) async => GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
      );
      when(
        mockAuthService.loginWithDeviceCode(any),
      ).thenAnswer((_) async => throw AccessDeniedException());
      when(mockAuthService.isLoggedIn).thenReturn(false);

      final vm = LoginViewModel(
        mockAuthClient,
        mockAuthService,
        mockAuthViewModel,
      );

      await vm.login();
      expect(vm.isAuthorized, isFalse);
      expect(vm.errorMessage, 'Access denied');
    });

    test('non-recoverable maps error message', () async {
      final nonRec = GithubNonRecoverableException('bad', 'desc');
      final mockAuthClient = MockGithubAuthClient();
      final mockAuthService = MockAuthService();
      final mockAuthViewModel = MockAuthViewModel();

      when(mockAuthClient.createDeviceCode(any)).thenAnswer(
        (_) async => GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
      );
      when(
        mockAuthService.loginWithDeviceCode(any),
      ).thenAnswer((_) async => throw nonRec);
      when(mockAuthService.isLoggedIn).thenReturn(false);

      final vm = LoginViewModel(
        mockAuthClient,
        mockAuthService,
        mockAuthViewModel,
      );

      await vm.login();
      expect(vm.isAuthorized, isFalse);
      expect(vm.errorMessage, nonRec.message);
    });

    test('error during createDeviceCode sets error', () async {
      final mockAuthClient = MockGithubAuthClient();
      final mockAuthService = MockAuthService();
      final mockAuthViewModel = MockAuthViewModel();

      when(
        mockAuthClient.createDeviceCode(any),
      ).thenAnswer((_) async => throw Exception('fail dev'));
      when(mockAuthService.isLoggedIn).thenReturn(false);

      final vm = LoginViewModel(
        mockAuthClient,
        mockAuthService,
        mockAuthViewModel,
      );

      await vm.login();
      expect(vm.isAuthorized, isFalse);
      expect(vm.errorMessage, contains('fail dev'));
    });
  });
}
