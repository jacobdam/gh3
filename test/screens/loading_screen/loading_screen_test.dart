import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gh3/src/screens/loading_screen/loading_screen.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'loading_screen_test.mocks.dart';

@GenerateMocks([AuthViewModel])
void main() {
  testWidgets('LoadingScreen renders loading indicator when loading', (
    WidgetTester tester,
  ) async {
    final viewModel = MockAuthViewModel();
    when(viewModel.loading).thenReturn(true);

    await tester.pumpWidget(
      MaterialApp(home: LoadingScreen(authViewModel: viewModel)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoadingScreen hides loading indicator when not loading', (
    WidgetTester tester,
  ) async {
    final viewModel = MockAuthViewModel();
    when(viewModel.loading).thenReturn(false);

    await tester.pumpWidget(
      MaterialApp(home: LoadingScreen(authViewModel: viewModel)),
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
