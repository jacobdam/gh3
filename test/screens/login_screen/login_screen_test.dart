import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gh3/src/screens/login_screen/login_screen.dart';
import 'package:gh3/src/screens/login_screen/login_viewmodel.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'login_screen_test.mocks.dart';

@GenerateMocks([GithubAuthClient, AuthService, AuthViewModel, LoginViewModel])
void main() {
  testWidgets('LoginScreen renders sign in button', (
    WidgetTester tester,
  ) async {
    final mockLoginViewModel = MockLoginViewModel();
    when(mockLoginViewModel.userCode).thenReturn(null);
    when(mockLoginViewModel.isLoading).thenReturn(false);
    when(mockLoginViewModel.errorMessage).thenReturn(null);
    when(mockLoginViewModel.isAuthorized).thenReturn(false);

    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(viewModel: mockLoginViewModel)),
    );
    expect(find.text('Sign in with GitHub'), findsOneWidget);
  });
}
