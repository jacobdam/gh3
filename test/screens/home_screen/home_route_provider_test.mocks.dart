// Mocks generated by Mockito 5.4.6 from annotations
// in gh3/test/screens/home_screen/home_route_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:ui' as _i8;

import 'package:flutter/foundation.dart' as _i4;
import 'package:flutter/src/widgets/notification_listener.dart' as _i9;
import 'package:flutter/widgets.dart' as _i3;
import 'package:gh3/src/screens/app/auth_viewmodel.dart' as _i6;
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart' as _i2;
import 'package:gh3/src/screens/home_screen/home_viewmodel_factory.dart' as _i5;
import 'package:go_router/src/state.dart' as _i10;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i11;

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

class _FakeHomeViewModel_0 extends _i1.SmartFake implements _i2.HomeViewModel {
  _FakeHomeViewModel_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeWidget_1 extends _i1.SmartFake implements _i3.Widget {
  _FakeWidget_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);

  @override
  String toString({_i4.DiagnosticLevel? minLevel = _i4.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeInheritedWidget_2 extends _i1.SmartFake
    implements _i3.InheritedWidget {
  _FakeInheritedWidget_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);

  @override
  String toString({_i4.DiagnosticLevel? minLevel = _i4.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeDiagnosticsNode_3 extends _i1.SmartFake
    implements _i4.DiagnosticsNode {
  _FakeDiagnosticsNode_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);

  @override
  String toString({
    _i4.TextTreeConfiguration? parentConfiguration,
    _i4.DiagnosticLevel? minLevel = _i4.DiagnosticLevel.info,
  }) => super.toString();
}

class _FakeUri_4 extends _i1.SmartFake implements Uri {
  _FakeUri_4(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeValueKey_5<T> extends _i1.SmartFake implements _i4.ValueKey<T> {
  _FakeValueKey_5(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [HomeViewModelFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeViewModelFactory extends _i1.Mock
    implements _i5.HomeViewModelFactory {
  MockHomeViewModelFactory() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.HomeViewModel create() =>
      (super.noSuchMethod(
            Invocation.method(#create, []),
            returnValue: _FakeHomeViewModel_0(
              this,
              Invocation.method(#create, []),
            ),
          )
          as _i2.HomeViewModel);
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
  _i7.Future<void> init() =>
      (super.noSuchMethod(
            Invocation.method(#init, []),
            returnValue: _i7.Future<void>.value(),
            returnValueForMissingStub: _i7.Future<void>.value(),
          )
          as _i7.Future<void>);

  @override
  _i7.Future<void> logout() =>
      (super.noSuchMethod(
            Invocation.method(#logout, []),
            returnValue: _i7.Future<void>.value(),
            returnValueForMissingStub: _i7.Future<void>.value(),
          )
          as _i7.Future<void>);

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
  void addListener(_i8.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#addListener, [listener]),
    returnValueForMissingStub: null,
  );

  @override
  void removeListener(_i8.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#removeListener, [listener]),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [HomeViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeViewModel extends _i1.Mock implements _i2.HomeViewModel {
  MockHomeViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isLoading =>
      (super.noSuchMethod(Invocation.getter(#isLoading), returnValue: false)
          as bool);

  @override
  bool get disposed =>
      (super.noSuchMethod(Invocation.getter(#disposed), returnValue: false)
          as bool);

  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);

  @override
  _i7.Future<void> loadCurrentUser() =>
      (super.noSuchMethod(
            Invocation.method(#loadCurrentUser, []),
            returnValue: _i7.Future<void>.value(),
            returnValueForMissingStub: _i7.Future<void>.value(),
          )
          as _i7.Future<void>);

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
  void addListener(_i8.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#addListener, [listener]),
    returnValueForMissingStub: null,
  );

  @override
  void removeListener(_i8.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#removeListener, [listener]),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [BuildContext].
///
/// See the documentation for Mockito's code generation for more information.
class MockBuildContext extends _i1.Mock implements _i3.BuildContext {
  MockBuildContext() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Widget get widget =>
      (super.noSuchMethod(
            Invocation.getter(#widget),
            returnValue: _FakeWidget_1(this, Invocation.getter(#widget)),
          )
          as _i3.Widget);

  @override
  bool get mounted =>
      (super.noSuchMethod(Invocation.getter(#mounted), returnValue: false)
          as bool);

  @override
  bool get debugDoingBuild =>
      (super.noSuchMethod(
            Invocation.getter(#debugDoingBuild),
            returnValue: false,
          )
          as bool);

  @override
  _i3.InheritedWidget dependOnInheritedElement(
    _i3.InheritedElement? ancestor, {
    Object? aspect,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #dependOnInheritedElement,
              [ancestor],
              {#aspect: aspect},
            ),
            returnValue: _FakeInheritedWidget_2(
              this,
              Invocation.method(
                #dependOnInheritedElement,
                [ancestor],
                {#aspect: aspect},
              ),
            ),
          )
          as _i3.InheritedWidget);

  @override
  void visitAncestorElements(_i3.ConditionalElementVisitor? visitor) =>
      super.noSuchMethod(
        Invocation.method(#visitAncestorElements, [visitor]),
        returnValueForMissingStub: null,
      );

  @override
  void visitChildElements(_i3.ElementVisitor? visitor) => super.noSuchMethod(
    Invocation.method(#visitChildElements, [visitor]),
    returnValueForMissingStub: null,
  );

  @override
  void dispatchNotification(_i9.Notification? notification) =>
      super.noSuchMethod(
        Invocation.method(#dispatchNotification, [notification]),
        returnValueForMissingStub: null,
      );

  @override
  _i4.DiagnosticsNode describeElement(
    String? name, {
    _i4.DiagnosticsTreeStyle? style = _i4.DiagnosticsTreeStyle.errorProperty,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#describeElement, [name], {#style: style}),
            returnValue: _FakeDiagnosticsNode_3(
              this,
              Invocation.method(#describeElement, [name], {#style: style}),
            ),
          )
          as _i4.DiagnosticsNode);

  @override
  _i4.DiagnosticsNode describeWidget(
    String? name, {
    _i4.DiagnosticsTreeStyle? style = _i4.DiagnosticsTreeStyle.errorProperty,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#describeWidget, [name], {#style: style}),
            returnValue: _FakeDiagnosticsNode_3(
              this,
              Invocation.method(#describeWidget, [name], {#style: style}),
            ),
          )
          as _i4.DiagnosticsNode);

  @override
  List<_i4.DiagnosticsNode> describeMissingAncestor({
    required Type? expectedAncestorType,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#describeMissingAncestor, [], {
              #expectedAncestorType: expectedAncestorType,
            }),
            returnValue: <_i4.DiagnosticsNode>[],
          )
          as List<_i4.DiagnosticsNode>);

  @override
  _i4.DiagnosticsNode describeOwnershipChain(String? name) =>
      (super.noSuchMethod(
            Invocation.method(#describeOwnershipChain, [name]),
            returnValue: _FakeDiagnosticsNode_3(
              this,
              Invocation.method(#describeOwnershipChain, [name]),
            ),
          )
          as _i4.DiagnosticsNode);
}

/// A class which mocks [GoRouterState].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockGoRouterState extends _i1.Mock implements _i10.GoRouterState {
  MockGoRouterState() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Uri get uri =>
      (super.noSuchMethod(
            Invocation.getter(#uri),
            returnValue: _FakeUri_4(this, Invocation.getter(#uri)),
          )
          as Uri);

  @override
  String get matchedLocation =>
      (super.noSuchMethod(
            Invocation.getter(#matchedLocation),
            returnValue: _i11.dummyValue<String>(
              this,
              Invocation.getter(#matchedLocation),
            ),
          )
          as String);

  @override
  Map<String, String> get pathParameters =>
      (super.noSuchMethod(
            Invocation.getter(#pathParameters),
            returnValue: <String, String>{},
          )
          as Map<String, String>);

  @override
  _i4.ValueKey<String> get pageKey =>
      (super.noSuchMethod(
            Invocation.getter(#pageKey),
            returnValue: _FakeValueKey_5<String>(
              this,
              Invocation.getter(#pageKey),
            ),
          )
          as _i4.ValueKey<String>);

  @override
  String namedLocation(
    String? name, {
    Map<String, String>? pathParameters = const {},
    Map<String, String>? queryParameters = const {},
    String? fragment,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #namedLocation,
              [name],
              {
                #pathParameters: pathParameters,
                #queryParameters: queryParameters,
                #fragment: fragment,
              },
            ),
            returnValue: _i11.dummyValue<String>(
              this,
              Invocation.method(
                #namedLocation,
                [name],
                {
                  #pathParameters: pathParameters,
                  #queryParameters: queryParameters,
                  #fragment: fragment,
                },
              ),
            ),
          )
          as String);
}
