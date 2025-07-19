import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:gh3/src/services/scope_service.dart';

void main() {
  group('ScopeService', () {
    late ScopeService scopeService;
    late _MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = _MockHttpClient();
      scopeService = ScopeService(mockHttpClient);
    });

    group('getScopesFromAccessToken', () {
      test('should return scopes when token is valid', () async {
        // Arrange
        const token = 'valid_token_123';
        const expectedScopes = ['repo', 'read:user'];
        mockHttpClient.mockResponse = http.Response(
          '{"message": "API rate limit exceeded"}',
          200,
          headers: {'x-oauth-scopes': 'repo, read:user'},
        );

        // Act
        final result = await scopeService.getScopesFromAccessToken(token);

        // Assert
        expect(result, equals(expectedScopes));
        expect(
          mockHttpClient.lastRequest?.url.toString(),
          contains('api.github.com'),
        );
        expect(
          mockHttpClient.lastRequest?.headers['Authorization'],
          equals('token $token'),
        );
        expect(
          mockHttpClient.lastRequest?.headers['Accept'],
          equals('application/vnd.github.v3+json'),
        );
        expect(
          mockHttpClient.lastRequest?.headers['User-Agent'],
          equals('gh3-flutter-app'),
        );
      });

      test('should return empty list when no scopes are present', () async {
        // Arrange
        const token = 'valid_token_123';
        mockHttpClient.mockResponse = http.Response(
          '{}',
          200,
          headers: {'x-oauth-scopes': ''},
        );

        // Act
        final result = await scopeService.getScopesFromAccessToken(token);

        // Assert
        expect(result, isEmpty);
      });

      test('should handle scopes with extra whitespace', () async {
        // Arrange
        const token = 'valid_token_123';
        const expectedScopes = ['repo', 'read:user', 'write:repo_hook'];
        mockHttpClient.mockResponse = http.Response(
          '{}',
          200,
          headers: {'x-oauth-scopes': ' repo , read:user,  write:repo_hook '},
        );

        // Act
        final result = await scopeService.getScopesFromAccessToken(token);

        // Assert
        expect(result, equals(expectedScopes));
      });

      test('should throw ArgumentError when token is empty', () async {
        // Act & Assert
        expect(
          () => scopeService.getScopesFromAccessToken(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test(
        'should throw ScopeValidationException when token is invalid (401)',
        () async {
          // Arrange
          const token = 'invalid_token';
          mockHttpClient.mockResponse = http.Response(
            '{"message": "Bad credentials"}',
            401,
          );

          // Act & Assert
          expect(
            () => scopeService.getScopesFromAccessToken(token),
            throwsA(
              isA<ScopeValidationException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('Invalid or expired access token'),
                  )
                  .having((e) => e.statusCode, 'statusCode', equals(401)),
            ),
          );
        },
      );

      test(
        'should throw ScopeValidationException when access is forbidden (403)',
        () async {
          // Arrange
          const token = 'rate_limited_token';
          mockHttpClient.mockResponse = http.Response(
            '{"message": "API rate limit exceeded"}',
            403,
          );

          // Act & Assert
          expect(
            () => scopeService.getScopesFromAccessToken(token),
            throwsA(
              isA<ScopeValidationException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('Access forbidden'),
                  )
                  .having((e) => e.statusCode, 'statusCode', equals(403)),
            ),
          );
        },
      );

      test(
        'should throw ScopeValidationException for other HTTP errors',
        () async {
          // Arrange
          const token = 'valid_token';
          mockHttpClient.mockResponse = http.Response(
            '{"message": "Internal Server Error"}',
            500,
          );

          // Act & Assert
          expect(
            () => scopeService.getScopesFromAccessToken(token),
            throwsA(
              isA<ScopeValidationException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('GitHub API request failed with status 500'),
                  )
                  .having((e) => e.statusCode, 'statusCode', equals(500)),
            ),
          );
        },
      );

      test(
        'should throw ScopeValidationException when scopes header is missing',
        () async {
          // Arrange
          const token = 'valid_token';
          mockHttpClient.mockResponse = http.Response('{}', 200);

          // Act & Assert
          expect(
            () => scopeService.getScopesFromAccessToken(token),
            throwsA(
              isA<ScopeValidationException>().having(
                (e) => e.message,
                'message',
                contains('No scopes found in response headers'),
              ),
            ),
          );
        },
      );

      test('should throw ScopeValidationException on timeout', () async {
        // Arrange
        const token = 'valid_token';
        mockHttpClient.shouldTimeout = true;

        // Act & Assert
        expect(
          () => scopeService.getScopesFromAccessToken(token),
          throwsA(
            isA<ScopeValidationException>().having(
              (e) => e.message,
              'message',
              contains('Request timeout'),
            ),
          ),
        );
      });

      test(
        'should throw ScopeValidationException on socket exception',
        () async {
          // Arrange
          const token = 'valid_token';
          mockHttpClient.shouldThrowSocketException = true;

          // Act & Assert
          expect(
            () => scopeService.getScopesFromAccessToken(token),
            throwsA(
              isA<ScopeValidationException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('Network error'),
                  )
                  .having((e) => e.cause, 'cause', isA<SocketException>()),
            ),
          );
        },
      );

      test(
        'should throw ScopeValidationException on HTTP client exception',
        () async {
          // Arrange
          const token = 'valid_token';
          mockHttpClient.shouldThrowClientException = true;

          // Act & Assert
          expect(
            () => scopeService.getScopesFromAccessToken(token),
            throwsA(
              isA<ScopeValidationException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('HTTP client error'),
                  )
                  .having((e) => e.cause, 'cause', isA<http.ClientException>()),
            ),
          );
        },
      );

      test(
        'should throw ScopeValidationException on unexpected error',
        () async {
          // Arrange
          const token = 'valid_token';
          mockHttpClient.shouldThrowGenericException = true;

          // Act & Assert
          expect(
            () => scopeService.getScopesFromAccessToken(token),
            throwsA(
              isA<ScopeValidationException>().having(
                (e) => e.message,
                'message',
                contains('Unexpected error occurred'),
              ),
            ),
          );
        },
      );
    });

    group('ScopeValidationException', () {
      test('should create exception with message only', () {
        // Arrange & Act
        const exception = ScopeValidationException('Test message');

        // Assert
        expect(exception.message, equals('Test message'));
        expect(exception.statusCode, isNull);
        expect(exception.cause, isNull);
        expect(
          exception.toString(),
          equals('ScopeValidationException: Test message'),
        );
      });

      test('should create exception with message and status code', () {
        // Arrange & Act
        const exception = ScopeValidationException(
          'Test message',
          statusCode: 401,
        );

        // Assert
        expect(exception.message, equals('Test message'));
        expect(exception.statusCode, equals(401));
        expect(exception.cause, isNull);
      });

      test('should create exception with message, status code, and cause', () {
        // Arrange
        final cause = Exception('Root cause');
        final exception = ScopeValidationException(
          'Test message',
          statusCode: 500,
          cause: cause,
        );

        // Act & Assert
        expect(exception.message, equals('Test message'));
        expect(exception.statusCode, equals(500));
        expect(exception.cause, equals(cause));
      });
    });
  });
}

/// Mock HTTP client for testing
class _MockHttpClient extends http.BaseClient {
  http.Response? mockResponse;
  http.BaseRequest? lastRequest;
  bool shouldTimeout = false;
  bool shouldThrowSocketException = false;
  bool shouldThrowClientException = false;
  bool shouldThrowGenericException = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    lastRequest = request;

    if (shouldTimeout) {
      await Future.delayed(const Duration(seconds: 11));
      throw TimeoutException('Request timeout', const Duration(seconds: 10));
    }

    if (shouldThrowSocketException) {
      throw const SocketException('Network unreachable');
    }

    if (shouldThrowClientException) {
      throw http.ClientException('Client error');
    }

    if (shouldThrowGenericException) {
      throw Exception('Generic error');
    }

    if (mockResponse == null) {
      throw Exception('No mock response configured');
    }

    return http.StreamedResponse(
      Stream.fromIterable([mockResponse!.bodyBytes]),
      mockResponse!.statusCode,
      headers: mockResponse!.headers,
    );
  }
}
