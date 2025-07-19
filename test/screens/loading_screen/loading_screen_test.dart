import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gh3/src/screens/loading_screen/loading_screen.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';

class FakeAuthViewModel extends ChangeNotifier implements AuthViewModel {
  @override
  bool loggedIn = false;
  @override
  bool loading;
  FakeAuthViewModel({this.loading = true});
  @override
  Future<void> init() async {}
  @override
  Future<void> logout() async {}
  @override
  void updateAuthState() {}
}

void main() {
  testWidgets('LoadingScreen renders loading indicator when loading', (
    WidgetTester tester,
  ) async {
    final viewModel = FakeAuthViewModel(loading: true);
    await tester.pumpWidget(
      MaterialApp(home: LoadingScreen(authViewModel: viewModel)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoadingScreen hides loading indicator when not loading', (
    WidgetTester tester,
  ) async {
    final viewModel = FakeAuthViewModel(loading: false);
    await tester.pumpWidget(
      MaterialApp(home: LoadingScreen(authViewModel: viewModel)),
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('LoadingScreen updates when viewModel changes', (
    WidgetTester tester,
  ) async {
    final viewModel = FakeAuthViewModel(loading: false);
    await tester.pumpWidget(
      MaterialApp(home: LoadingScreen(authViewModel: viewModel)),
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // Update the viewModel
    viewModel.loading = true;
    viewModel.notifyListeners();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
