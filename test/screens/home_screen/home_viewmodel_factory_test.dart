import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel_factory.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart';
import 'package:ferry/ferry.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Client>()])
import 'home_viewmodel_factory_test.mocks.dart';

void main() {
  group('HomeViewModelFactory', () {
    late MockClient mockClient;
    late HomeViewModelFactory factory;

    setUp(() {
      mockClient = MockClient();
      factory = HomeViewModelFactory(mockClient);
    });

    group('Factory Creation', () {
      test('should create factory with Client dependency', () {
        expect(factory, isNotNull);
        expect(factory, isA<HomeViewModelFactory>());
      });

      test(
        'should create HomeViewModel instance with injected dependencies',
        () {
          // Act
          final viewModel = factory.create();

          // Assert
          expect(viewModel, isNotNull);
          expect(viewModel, isA<HomeViewModel>());

          // Clean up
          viewModel.dispose();
        },
      );

      test('should create multiple independent HomeViewModel instances', () {
        // Act
        final viewModel1 = factory.create();
        final viewModel2 = factory.create();

        // Assert
        expect(viewModel1, isNotNull);
        expect(viewModel2, isNotNull);
        expect(viewModel1, isNot(same(viewModel2)));
        expect(viewModel1, isA<HomeViewModel>());
        expect(viewModel2, isA<HomeViewModel>());

        // Clean up
        viewModel1.dispose();
        viewModel2.dispose();
      });
    });

    group('Dependency Injection', () {
      test('should inject Client correctly', () {
        // Act
        final viewModel = factory.create();

        // Assert - Verify the ViewModel has correct initial state
        expect(viewModel.currentUser, isNull);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, isNull);

        // Clean up
        viewModel.dispose();
      });
    });

    group('ViewModel Lifecycle', () {
      test('should create ViewModels that can be disposed independently', () {
        // Act
        final viewModel1 = factory.create();
        final viewModel2 = factory.create();

        // Assert - Should be able to dispose one without affecting the other
        expect(() => viewModel1.dispose(), returnsNormally);
        expect(() => viewModel2.dispose(), returnsNormally);
      });

      test('should create ViewModels with proper initial state', () {
        // Act
        final viewModel = factory.create();

        // Assert - Check all initial state properties
        expect(viewModel.currentUser, isNull);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, isNull);

        // Clean up
        viewModel.dispose();
      });
    });

    group('Factory Pattern Validation', () {
      test('should maintain factory pattern principles', () {
        // Act & Assert - Factory should create new instances each time
        final instances = List.generate(5, (_) => factory.create());

        // All instances should be different objects
        for (int i = 0; i < instances.length; i++) {
          for (int j = i + 1; j < instances.length; j++) {
            expect(instances[i], isNot(same(instances[j])));
          }
        }

        // All instances should be of the same type
        for (final instance in instances) {
          expect(instance, isA<HomeViewModel>());
        }

        // Clean up
        for (final instance in instances) {
          instance.dispose();
        }
      });
    });
  });
}
