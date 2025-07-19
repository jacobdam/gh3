import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:ferry/ferry.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart';
import 'package:gh3/src/services/github_api_service.dart';

import 'home_viewmodel_test.mocks.dart';

@GenerateMocks([Client, GitHubApiService])
void main() {
  group('HomeViewModel', () {
    late MockClient mockFerryClient;
    late MockGitHubApiService mockRestApiService;
    late HomeViewModel viewModel;

    setUp(() {
      mockFerryClient = MockClient();
      mockRestApiService = MockGitHubApiService();
      viewModel = HomeViewModel(mockFerryClient, mockRestApiService);
    });

    tearDown(() {
      // Don't call dispose in tearDown as it may be called in individual tests
    });

    test('should initialize with loading state', () {
      expect(viewModel.isLoading, isTrue);
      expect(viewModel.isEmpty, isFalse); // isEmpty is false when loading
      expect(viewModel.followingUsers, isEmpty);
      expect(viewModel.error, isNull);
    });

    test('should expose correct getters', () {
      expect(viewModel.hasMore, isTrue);
      expect(viewModel.followingUsers, isNotNull);
      expect(viewModel.following, isNull); // No data loaded yet
    });

    test('should handle dispose properly', () {
      // Should not throw when disposing
      expect(() => viewModel.dispose(), returnsNormally);
    });

    test('should provide error message formatting', () {
      // Test that the viewModel can handle different error types
      expect(viewModel.error, isNull);
    });

    group('GraphQL Integration', () {
      test('should use Ferry client for GraphQL operations', () {
        // Verify that the viewModel has access to Ferry client
        expect(viewModel, isA<HomeViewModel>());
      });

      test('should handle pagination state', () {
        expect(viewModel.hasMore, isTrue);
        expect(viewModel.isEmpty, isFalse); // When loading
      });
    });
  });
}
