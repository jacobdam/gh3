import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ferry/ferry.dart';
import 'package:built_collection/built_collection.dart';
import 'package:gh3/src/screens/user_repositories/user_repositories_viewmodel.dart';
import 'package:gh3/src/screens/user_repositories/__generated__/user_repositories_viewmodel.data.gql.dart';
import 'package:gh3/src/screens/user_repositories/__generated__/user_repositories_viewmodel.req.gql.dart';
import 'package:gh3/__generated__/github_schema.schema.gql.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:ferry_exec/ferry_exec.dart';

import 'user_repositories_viewmodel_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  group('UserRepositoriesViewModel', () {
    late MockClient mockClient;
    late UserRepositoriesViewModel viewModel;
    const testUserLogin = 'testuser';

    setUp(() {
      mockClient = MockClient();
      viewModel = UserRepositoriesViewModel(mockClient, testUserLogin);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initialization', () {
      test('should initialize with default state', () {
        expect(viewModel.repositories, isEmpty);
        expect(viewModel.filteredRepositories, isEmpty);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, isNull);
        expect(viewModel.hasNextPage, true);
        expect(viewModel.isLoadingMore, false);
        expect(viewModel.nextCursor, isNull);
        expect(viewModel.totalCount, 0);
        expect(viewModel.searchQuery, '');
        expect(viewModel.selectedType, RepositoryType.all);
        expect(viewModel.selectedLanguage, isNull);
        expect(viewModel.sortOption, RepositorySortOption.recentlyPushed);
        expect(viewModel.availableLanguages, isEmpty);
        expect(viewModel.languageCounts, isEmpty);
        expect(viewModel.canLoadMore, true);
        expect(viewModel.showLoadingIndicator, false);
      });

      test('should properly dispose', () {
        expect(() => viewModel.dispose(), returnsNormally);
        expect(viewModel.disposed, true);
      });
    });

    group('Repository Loading', () {
      test('should handle loading state correctly', () async {
        // Arrange
        final mockResponse = _createSuccessResponse([], false, null, 0);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(mockResponse).cast());

        // Act
        final loadingFuture = viewModel.loadRepositories();
        
        // Assert loading state - Note: loading state is set synchronously
        expect(viewModel.isLoading, true);
        expect(viewModel.error, isNull);
        
        await loadingFuture;
        
        // Assert final state
        expect(viewModel.isLoading, false);
      });

      test('should handle GraphQL errors', () async {
        // Arrange
        final errorResponse = _createErrorResponse('User not found');
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(errorResponse).cast());

        // Act
        await viewModel.loadRepositories();

        // Assert
        expect(viewModel.isLoading, false);
        expect(viewModel.error, 'User not found');
        expect(viewModel.repositories, isEmpty);
      });

      test('should handle network exceptions', () async {
        // Arrange
        when(mockClient.request(any)).thenAnswer((_) => Stream.error(Exception('Network error')));

        // Act
        await viewModel.loadRepositories();

        // Assert
        expect(viewModel.isLoading, false);
        expect(viewModel.error, contains('Failed to load repositories'));
        expect(viewModel.repositories, isEmpty);
      });

      test('should handle user not found', () async {
        // Arrange
        final mockResponse = _createUserNotFoundResponse();
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(mockResponse).cast());

        // Act
        await viewModel.loadRepositories();

        // Assert
        expect(viewModel.isLoading, false);
        expect(viewModel.error, 'User not found');
        expect(viewModel.repositories, isEmpty);
      });
    });

    group('Pagination', () {
      test('should handle load more state correctly', () async {
        // Arrange - Initial load
        final initialResponse = _createSuccessResponse([], true, 'cursor1', 1);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(initialResponse).cast());
        await viewModel.loadRepositories();

        // Arrange - Load more
        final moreResponse = _createSuccessResponse([], false, null, 2);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(moreResponse).cast());

        // Act
        final loadMoreFuture = viewModel.loadMoreRepositories();
        
        // Assert loading state
        expect(viewModel.isLoadingMore, true);
        
        await loadMoreFuture;
        
        // Assert final state
        expect(viewModel.isLoadingMore, false);
      });

      test('should prevent race conditions in load more', () async {
        // Arrange - Initial load
        final initialResponse = _createSuccessResponse([], true, 'cursor1', 1);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(initialResponse).cast());
        await viewModel.loadRepositories();

        // Arrange - Load more with delay
        final moreResponse = _createSuccessResponse([], false, null, 2);
        when(mockClient.request(any)).thenAnswer((_) => Stream.fromFuture(
          Future.delayed(Duration(milliseconds: 100), () => moreResponse)
        ).cast());

        // Act - Call load more multiple times simultaneously
        final future1 = viewModel.loadMoreRepositories();
        final future2 = viewModel.loadMoreRepositories();
        final future3 = viewModel.loadMoreRepositories();
        
        await Future.wait([future1, future2, future3]);

        // Assert - Only one request should have been made after initial load
        verify(mockClient.request(any)).called(2); // Initial load + one load more
      });

      test('should not load more when canLoadMore is false', () async {
        // Arrange - Set state where canLoadMore is false
        final response = _createSuccessResponse([], false, null, 1); // hasNextPage = false
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(response).cast());
        await viewModel.loadRepositories();

        // Reset mock to track additional calls
        reset(mockClient);

        // Act
        await viewModel.loadMoreRepositories();

        // Assert - No additional calls should have been made
        verifyNever(mockClient.request(any));
        expect(viewModel.canLoadMore, false);
      });

      test('should handle load more errors', () async {
        // Arrange - Initial load
        final initialResponse = _createSuccessResponse([], true, 'cursor1', 1);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(initialResponse).cast());
        await viewModel.loadRepositories();

        // Arrange - Load more error
        when(mockClient.request(any)).thenAnswer((_) => Stream.error(Exception('Network error')));

        // Act
        await viewModel.loadMoreRepositories();

        // Assert
        expect(viewModel.error, contains('Failed to load more repositories'));
        expect(viewModel.isLoadingMore, false);
      });

      test('should handle scroll near end', () async {
        // Arrange - Initial load
        final response = _createSuccessResponse([], true, 'cursor1', 1);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(response).cast());
        await viewModel.loadRepositories();

        // Arrange - Load more
        final moreResponse = _createSuccessResponse([], false, null, 2);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(moreResponse).cast());

        // Act
        viewModel.onScrollNearEnd();
        await Future.delayed(Duration(milliseconds: 10)); // Allow async operation to complete

        // Assert - Should have triggered load more
        verify(mockClient.request(any)).called(2); // Initial + load more
      });
    });

    group('Search Filtering', () {
      test('should update search query', () {
        // Act
        viewModel.updateSearchQuery('flutter');

        // Assert
        expect(viewModel.searchQuery, 'flutter');
      });

      test('should clear search filter', () {
        // Arrange
        viewModel.updateSearchQuery('flutter');
        expect(viewModel.searchQuery, 'flutter');

        // Act
        viewModel.updateSearchQuery('');

        // Assert
        expect(viewModel.searchQuery, '');
      });
    });

    group('Repository Type Filtering', () {
      test('should update type filter and trigger reload', () async {
        // Arrange
        final response = _createSuccessResponse([], false, null, 0);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(response).cast());

        // Act
        viewModel.updateTypeFilter(RepositoryType.private);

        // Assert
        expect(viewModel.selectedType, RepositoryType.private);
        // Should trigger a reload
        await Future.delayed(Duration(milliseconds: 10));
        verify(mockClient.request(any)).called(1);
      });

      test('should handle all repository types', () {
        // Test all enum values
        for (final type in RepositoryType.values) {
          viewModel.updateTypeFilter(type);
          expect(viewModel.selectedType, type);
        }
      });
    });

    group('Language Filtering', () {
      test('should filter repositories by language', () {
        // Act
        viewModel.updateLanguageFilter('Dart');

        // Assert
        expect(viewModel.selectedLanguage, 'Dart');
      });

      test('should clear language filter', () {
        // Arrange
        viewModel.updateLanguageFilter('Dart');
        expect(viewModel.selectedLanguage, 'Dart');

        // Act
        viewModel.updateLanguageFilter(null);

        // Assert
        expect(viewModel.selectedLanguage, isNull);
      });
    });

    group('Sorting', () {
      test('should update sort option and trigger reload', () async {
        // Arrange
        final response = _createSuccessResponse([], false, null, 0);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(response).cast());

        // Act
        viewModel.updateSortOption(RepositorySortOption.nameAscending);

        // Assert
        expect(viewModel.sortOption, RepositorySortOption.nameAscending);
        // Should trigger a reload
        await Future.delayed(Duration(milliseconds: 10));
        verify(mockClient.request(any)).called(1);
      });

      test('should handle all sort options', () {
        // Test all enum values
        for (final option in RepositorySortOption.values) {
          viewModel.updateSortOption(option);
          expect(viewModel.sortOption, option);
        }
      });
    });

    group('Combined Filters', () {
      test('should clear all filters', () async {
        // Arrange
        final response = _createSuccessResponse([], false, null, 0);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(response).cast());

        // Apply filters
        viewModel.updateSearchQuery('flutter');
        viewModel.updateLanguageFilter('Dart');
        viewModel.updateTypeFilter(RepositoryType.private);
        viewModel.updateSortOption(RepositorySortOption.nameAscending);

        // Act
        viewModel.clearAllFilters();

        // Assert
        expect(viewModel.searchQuery, '');
        expect(viewModel.selectedLanguage, isNull);
        expect(viewModel.selectedType, RepositoryType.all);
        expect(viewModel.sortOption, RepositorySortOption.recentlyPushed);
        
        // Should trigger a reload
        await Future.delayed(Duration(milliseconds: 10));
        verify(mockClient.request(any)).called(greaterThan(0));
      });
    });

    group('Refresh', () {
      test('should refresh repositories', () async {
        // Arrange - Initial load
        final initialResponse = _createSuccessResponse([], false, null, 1);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(initialResponse).cast());
        await viewModel.loadRepositories();

        // Arrange - Refresh with new data
        final refreshResponse = _createSuccessResponse([], false, null, 2);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(refreshResponse).cast());

        // Act
        await viewModel.refreshRepositories();

        // Assert
        expect(viewModel.totalCount, 2);
        expect(viewModel.hasNextPage, false);
        expect(viewModel.nextCursor, isNull);
        verify(mockClient.request(any)).called(2); // Initial load + refresh
      });
    });

    group('Error Handling', () {
      test('should handle GraphQL errors in load more', () async {
        // Arrange - Initial load
        final response = _createSuccessResponse([], true, 'cursor1', 1);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(response).cast());
        await viewModel.loadRepositories();

        // Arrange - Load more with GraphQL error
        final errorResponse = _createErrorResponse('Rate limit exceeded');
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(errorResponse).cast());

        // Act
        await viewModel.loadMoreRepositories();

        // Assert
        expect(viewModel.error, 'Rate limit exceeded');
        expect(viewModel.isLoadingMore, false);
      });

      test('should handle null data in response', () async {
        // Arrange
        final nullResponse = _createNullDataResponse();
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(nullResponse).cast());

        // Act
        await viewModel.loadRepositories();

        // Assert
        expect(viewModel.error, isNotNull);
        expect(viewModel.repositories, isEmpty);
      });
    });

    group('Disposal', () {
      test('should cancel ongoing operations on dispose', () {
        // Arrange
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(
          _createSuccessResponse([], false, null, 0)
        ).cast());

        // Act
        viewModel.dispose();

        // Assert
        expect(viewModel.disposed, true);
        expect(() => viewModel.dispose(), returnsNormally); // Should handle multiple dispose calls
      });
    });

    group('State Properties', () {
      test('should compute canLoadMore correctly', () async {
        // Test various states
        expect(viewModel.canLoadMore, true); // Initial state
        
        // Set up mock response
        final response = _createSuccessResponse([], false, null, 0);
        when(mockClient.request(any)).thenAnswer((_) => Stream.value(response).cast());
        
        // Simulate loading state
        final loadingFuture = viewModel.loadRepositories();
        expect(viewModel.canLoadMore, false); // Should be false when loading
        
        await loadingFuture;
        expect(viewModel.canLoadMore, false); // Should be false when hasNextPage is false
      });

      test('should compute showLoadingIndicator correctly', () {
        expect(viewModel.showLoadingIndicator, false); // Initial state
      });
    });
  });
}

// Helper functions for creating mock responses
OperationResponse<GGetUserRepositoriesData, Object> _createSuccessResponse(
  List<dynamic> repositories,
  bool hasNextPage,
  String? endCursor,
  int totalCount,
) {
  return OperationResponse<GGetUserRepositoriesData, Object>(
    operationRequest: GGetUserRepositoriesReq((b) => b
      ..vars.login = 'testuser'
      ..vars.first = 20),
    data: GGetUserRepositoriesData((b) => b
      ..G__typename = 'Query'
      ..user = (GGetUserRepositoriesData_userBuilder()
        ..G__typename = 'User'
        ..repositories = (GGetUserRepositoriesData_user_repositoriesBuilder()
          ..G__typename = 'RepositoryConnection'
          ..totalCount = totalCount
          ..pageInfo = (GGetUserRepositoriesData_user_repositories_pageInfoBuilder()
            ..G__typename = 'PageInfo'
            ..hasNextPage = hasNextPage
            ..hasPreviousPage = false
            ..startCursor = null
            ..endCursor = endCursor)
          ..nodes = BuiltList<GGetUserRepositoriesData_user_repositories_nodes?>(repositories).toBuilder()))),
  );
}

OperationResponse<GGetUserRepositoriesData, Object> _createErrorResponse(String message) {
  return OperationResponse<GGetUserRepositoriesData, Object>(
    operationRequest: GGetUserRepositoriesReq((b) => b
      ..vars.login = 'testuser'
      ..vars.first = 20),
    data: null,
    graphqlErrors: [
      GraphQLError(message: message),
    ],
  );
}

OperationResponse<GGetUserRepositoriesData, Object> _createUserNotFoundResponse() {
  return OperationResponse<GGetUserRepositoriesData, Object>(
    operationRequest: GGetUserRepositoriesReq((b) => b
      ..vars.login = 'testuser'
      ..vars.first = 20),
    data: GGetUserRepositoriesData((b) => b
      ..G__typename = 'Query'
      ..user = null),
  );
}

OperationResponse<GGetUserRepositoriesData, Object> _createNullDataResponse() {
  return OperationResponse<GGetUserRepositoriesData, Object>(
    operationRequest: GGetUserRepositoriesReq((b) => b
      ..vars.login = 'testuser'
      ..vars.first = 20),
    data: null,
  );
}