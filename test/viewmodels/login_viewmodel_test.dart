import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/viewmodels/login_viewmodel.dart';

// A fake implementation of GithubAuthClient to control behavior in tests.
class FakeGithubAuthClient implements GithubAuthClient {
  final List<Exception> _accessTokenResponses;
  final GithubDeviceCodeResult deviceResult;

  FakeGithubAuthClient({required this.deviceResult, List<Exception>? accessTokenErrors, String? successToken})
      : _accessTokenResponses = accessTokenErrors ?? [],
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
  Future<String> createAccessTokenFromDeviceCode(String deviceCode) async =>
      '';
}

void main() {
  group('LoginViewModel', () {
    test('successful login sets accessToken and userCode', () async {
      final fake = FakeGithubAuthClient(
        deviceResult: GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        successToken: 'token123',
      );
      final vm = LoginViewModel(fake);
      expect(vm.isLoading, isFalse);
      final future = vm.login();
      expect(vm.isLoading, isTrue);

      await future;

      expect(vm.isLoading, isFalse);
      expect(vm.userCode, 'uc');
      expect(vm.accessToken, 'token123');
      expect(vm.errorMessage, isNull);
      expect(vm.isAuthorized, isTrue);
    });

    test('pending then success polling', () async {
      final fake = FakeGithubAuthClient(
        deviceResult: GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        accessTokenErrors: [AuthorizationPendingException()],
        successToken: 'tok',
      );
      final vm = LoginViewModel(fake);
      await vm.login();
      expect(vm.accessToken, 'tok');
      expect(vm.errorMessage, isNull);
    });

    test('slowDown then success polling', () async {
      final fake = FakeGithubAuthClient(
        deviceResult: GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        accessTokenErrors: [SlowDownException()],
        successToken: 'tok2',
      );
      final vm = LoginViewModel(fake);
      await vm.login();
      expect(vm.accessToken, 'tok2');
      expect(vm.errorMessage, isNull);
    });

    test('accessDenied stops polling and sets error', () async {
      final fake = FakeGithubAuthClient(
        deviceResult: GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        accessTokenErrors: [AccessDeniedException()],
      );
      final vm = LoginViewModel(fake);
      await vm.login();
      expect(vm.accessToken, isNull);
      expect(vm.errorMessage, 'Access denied');
    });

    test('non-recoverable maps error message', () async {
      final nonRec = GithubNonRecoverableException('bad', 'desc');
      final fake = FakeGithubAuthClient(
        deviceResult: GithubDeviceCodeResult(deviceCode: 'dc', userCode: 'uc'),
        accessTokenErrors: [nonRec],
      );
      final vm = LoginViewModel(fake);
      await vm.login();
      expect(vm.accessToken, isNull);
      expect(vm.errorMessage, nonRec.message);
    });

    test('error during createDeviceCode sets error', () async {
      final vm = LoginViewModel(FailGithubAuthClient());
      await vm.login();
      expect(vm.accessToken, isNull);
      expect(vm.errorMessage, contains('fail dev'));
    });
  });
}
