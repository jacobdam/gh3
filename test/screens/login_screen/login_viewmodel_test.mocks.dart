// Mocks generated by Mockito 5.4.6 from annotations
// in gh3/test/screens/login_screen/login_viewmodel_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:ui' as _i7;

import 'package:gh3/src/screens/app/auth_viewmodel.dart' as _i6;
import 'package:gh3/src/services/auth_service.dart' as _i5;
import 'package:gh3/src/services/github_auth_client.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGithubDeviceCodeResult_0 extends _i1.SmartFake
    implements _i2.GithubDeviceCodeResult {
  _FakeGithubDeviceCodeResult_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [GithubAuthClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockGithubAuthClient extends _i1.Mock implements _i2.GithubAuthClient {
  MockGithubAuthClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i2.GithubDeviceCodeResult> createDeviceCode(
    List<String>? scopes,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#createDeviceCode, [scopes]),
            returnValue: _i3.Future<_i2.GithubDeviceCodeResult>.value(
              _FakeGithubDeviceCodeResult_0(
                this,
                Invocation.method(#createDeviceCode, [scopes]),
              ),
            ),
          )
          as _i3.Future<_i2.GithubDeviceCodeResult>);

  @override
  _i3.Future<String> createAccessTokenFromDeviceCode(String? deviceCode) =>
      (super.noSuchMethod(
            Invocation.method(#createAccessTokenFromDeviceCode, [deviceCode]),
            returnValue: _i3.Future<String>.value(
              _i4.dummyValue<String>(
                this,
                Invocation.method(#createAccessTokenFromDeviceCode, [
                  deviceCode,
                ]),
              ),
            ),
          )
          as _i3.Future<String>);
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i5.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isLoggedIn =>
      (super.noSuchMethod(Invocation.getter(#isLoggedIn), returnValue: false)
          as bool);

  @override
  _i3.Future<void> init() =>
      (super.noSuchMethod(
            Invocation.method(#init, []),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<String> login() =>
      (super.noSuchMethod(
            Invocation.method(#login, []),
            returnValue: _i3.Future<String>.value(
              _i4.dummyValue<String>(this, Invocation.method(#login, [])),
            ),
          )
          as _i3.Future<String>);

  @override
  _i3.Future<String> loginWithDeviceCode(String? deviceCode) =>
      (super.noSuchMethod(
            Invocation.method(#loginWithDeviceCode, [deviceCode]),
            returnValue: _i3.Future<String>.value(
              _i4.dummyValue<String>(
                this,
                Invocation.method(#loginWithDeviceCode, [deviceCode]),
              ),
            ),
          )
          as _i3.Future<String>);

  @override
  _i3.Future<void> logout() =>
      (super.noSuchMethod(
            Invocation.method(#logout, []),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);
}

/// A class which mocks [AuthViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthViewModel extends _i1.Mock implements _i6.AuthViewModel {
  MockAuthViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get loading =>
      (super.noSuchMethod(Invocation.getter(#loading), returnValue: false)
          as bool);

  @override
  bool get loggedIn =>
      (super.noSuchMethod(Invocation.getter(#loggedIn), returnValue: false)
          as bool);

  @override
  set loading(bool? _loading) => super.noSuchMethod(
    Invocation.setter(#loading, _loading),
    returnValueForMissingStub: null,
  );

  @override
  set loggedIn(bool? _loggedIn) => super.noSuchMethod(
    Invocation.setter(#loggedIn, _loggedIn),
    returnValueForMissingStub: null,
  );

  @override
  bool get disposed =>
      (super.noSuchMethod(Invocation.getter(#disposed), returnValue: false)
          as bool);

  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);

  @override
  _i3.Future<void> init() =>
      (super.noSuchMethod(
            Invocation.method(#init, []),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<void> logout() =>
      (super.noSuchMethod(
            Invocation.method(#logout, []),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  void updateAuthState() => super.noSuchMethod(
    Invocation.method(#updateAuthState, []),
    returnValueForMissingStub: null,
  );

  @override
  void onDispose() => super.noSuchMethod(
    Invocation.method(#onDispose, []),
    returnValueForMissingStub: null,
  );

  @override
  void dispose() => super.noSuchMethod(
    Invocation.method(#dispose, []),
    returnValueForMissingStub: null,
  );

  @override
  void notifyListeners() => super.noSuchMethod(
    Invocation.method(#notifyListeners, []),
    returnValueForMissingStub: null,
  );

  @override
  void addListener(_i7.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#addListener, [listener]),
    returnValueForMissingStub: null,
  );

  @override
  void removeListener(_i7.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#removeListener, [listener]),
    returnValueForMissingStub: null,
  );
}
