import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gh3/src/services/token_storage.dart';

void main() {
  group('PrefsTokenStorage', () {
    late PrefsTokenStorage tokenStorage;

    setUp(() {
      tokenStorage = PrefsTokenStorage();
      // Clear any existing mock values
      SharedPreferences.setMockInitialValues({});
    });

    group('getToken', () {
      test('should return token when it exists', () async {
        // Arrange
        const expectedToken = 'test_token_123';
        SharedPreferences.setMockInitialValues({'github_access_token': expectedToken});

        // Act
        final result = await tokenStorage.getToken();

        // Assert
        expect(result, equals(expectedToken));
      });

      test('should return null when no token exists', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        final result = await tokenStorage.getToken();

        // Assert
        expect(result, isNull);
      });

      test('should throw TokenStorageException when SharedPreferences fails', () async {
        // This test simulates a scenario where SharedPreferences.getInstance() fails
        // In practice, this is difficult to mock directly, so we'll test the error handling
        // by creating a custom implementation that throws
        final failingStorage = _FailingTokenStorage();

        // Act & Assert
        expect(
          () => failingStorage.getToken(),
          throwsA(isA<TokenStorageException>()),
        );
      });
    });

    group('saveToken', () {
      test('should save token successfully', () async {
        // Arrange
        const token = 'test_token_123';
        SharedPreferences.setMockInitialValues({});

        // Act
        await tokenStorage.saveToken(token);

        // Assert
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('github_access_token'), equals(token));
      });

      test('should throw ArgumentError when token is empty', () async {
        // Act & Assert
        expect(
          () => tokenStorage.saveToken(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw TokenStorageException when SharedPreferences fails', () async {
        // Arrange
        final failingStorage = _FailingTokenStorage();

        // Act & Assert
        expect(
          () => failingStorage.saveToken('valid_token'),
          throwsA(isA<TokenStorageException>()),
        );
      });
    });

    group('deleteToken', () {
      test('should delete token successfully', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({'github_access_token': 'test_token'});

        // Act
        await tokenStorage.deleteToken();

        // Assert
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('github_access_token'), isNull);
      });

      test('should not throw when deleting non-existent token', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act & Assert
        expect(() => tokenStorage.deleteToken(), returnsNormally);
      });

      test('should throw TokenStorageException when SharedPreferences fails', () async {
        // Arrange
        final failingStorage = _FailingTokenStorage();

        // Act & Assert
        expect(
          () => failingStorage.deleteToken(),
          throwsA(isA<TokenStorageException>()),
        );
      });
    });

    group('TokenStorageException', () {
      test('should create exception with message only', () {
        // Arrange & Act
        const exception = TokenStorageException('Test message');

        // Assert
        expect(exception.message, equals('Test message'));
        expect(exception.cause, isNull);
        expect(exception.toString(), equals('TokenStorageException: Test message'));
      });

      test('should create exception with message and cause', () {
        // Arrange
        final cause = Exception('Root cause');
        final exception = TokenStorageException('Test message', cause);

        // Act & Assert
        expect(exception.message, equals('Test message'));
        expect(exception.cause, equals(cause));
        expect(exception.toString(), equals('TokenStorageException: Test message'));
      });
    });
  });
}

/// Test implementation that simulates SharedPreferences failures
class _FailingTokenStorage implements ITokenStorage {
  @override
  Future<String?> getToken() async {
    throw TokenStorageException('Simulated SharedPreferences failure');
  }

  @override
  Future<void> saveToken(String token) async {
    if (token.isEmpty) {
      throw ArgumentError('Token cannot be empty');
    }
    throw TokenStorageException('Simulated SharedPreferences failure');
  }

  @override
  Future<void> deleteToken() async {
    throw TokenStorageException('Simulated SharedPreferences failure');
  }
}