import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gh3/src/services/ferry_client_service.dart';
import 'package:gh3/src/services/token_storage.dart';

import 'ferry_client_service_test.mocks.dart';

@GenerateMocks([ITokenStorage])
void main() {
  group('FerryClientService', () {
    late MockITokenStorage mockTokenStorage;
    late FerryClientService ferryClientService;

    setUp(() {
      mockTokenStorage = MockITokenStorage();
      ferryClientService = FerryClientService(mockTokenStorage);
    });

    tearDown(() {
      ferryClientService.dispose();
    });

    test('should create Ferry client with authentication token', () async {
      // Arrange
      const testToken = 'test-token-123';
      when(mockTokenStorage.getToken()).thenAnswer((_) async => testToken);

      // Act
      final client = await ferryClientService.getClient();

      // Assert
      expect(client, isNotNull);
      verify(mockTokenStorage.getToken()).called(1);
    });

    test(
      'should create Ferry client without token when none available',
      () async {
        // Arrange
        when(mockTokenStorage.getToken()).thenAnswer((_) async => null);

        // Act
        final client = await ferryClientService.getClient();

        // Assert
        expect(client, isNotNull);
        verify(mockTokenStorage.getToken()).called(1);
      },
    );

    test('should reuse existing client on subsequent calls', () async {
      // Arrange
      const testToken = 'test-token-123';
      when(mockTokenStorage.getToken()).thenAnswer((_) async => testToken);

      // Act
      final client1 = await ferryClientService.getClient();
      final client2 = await ferryClientService.getClient();

      // Assert
      expect(client1, same(client2));
      verify(mockTokenStorage.getToken()).called(1); // Only called once
    });

    test('should recreate client when token is updated', () async {
      // Arrange
      const initialToken = 'initial-token';
      const newToken = 'new-token';
      when(mockTokenStorage.getToken()).thenAnswer((_) async => initialToken);

      // Act
      final client1 = await ferryClientService.getClient();

      // Update token storage to return new token
      when(mockTokenStorage.getToken()).thenAnswer((_) async => newToken);
      await ferryClientService.updateAuthToken(newToken);
      final client2 = await ferryClientService.getClient();

      // Assert
      expect(client1, isNot(same(client2)));
      verify(mockTokenStorage.getToken()).called(2);
    });

    test('should clear cache successfully', () async {
      // Arrange
      when(mockTokenStorage.getToken()).thenAnswer((_) async => 'token');
      final client = await ferryClientService.getClient();

      // Act & Assert - should not throw
      expect(() => ferryClientService.clearCache(), returnsNormally);
    });

    test('should dispose resources properly', () {
      // Act & Assert - should not throw
      expect(() => ferryClientService.dispose(), returnsNormally);
    });
  });
}
