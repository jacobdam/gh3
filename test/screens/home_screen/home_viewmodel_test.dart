import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ferry/ferry.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart';
import 'package:gh3/src/screens/home_screen/__generated__/home_viewmodel.req.gql.dart';
import 'package:gh3/src/widgets/user_card/__generated__/user_card.data.gql.dart';

import 'home_viewmodel_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  group('HomeViewModel', () {
    late MockClient mockClient;
    late HomeViewModel viewModel;

    setUp(() {
      mockClient = MockClient();
      viewModel = HomeViewModel(mockClient);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('should initialize with default state', () {
      expect(viewModel.currentUser, isNull);
      expect(viewModel.isLoading, false);
      expect(viewModel.error, isNull);
    });

    test('should properly dispose', () {
      expect(() => viewModel.dispose(), returnsNormally);
      expect(viewModel.disposed, true);
    });

    test('should handle multiple dispose calls gracefully', () {
      expect(() {
        viewModel.dispose();
        viewModel.dispose();
        viewModel.dispose();
      }, returnsNormally);

      expect(viewModel.disposed, true);
    });

    test('should not notify listeners after disposal', () {
      bool listenerCalled = false;
      viewModel.addListener(() {
        listenerCalled = true;
      });

      viewModel.dispose();
      listenerCalled = false;

      // After disposal, notifications should not be sent
      expect(listenerCalled, false);
    });
  });
}
