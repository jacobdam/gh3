import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:gh3/src/services/scope_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'scope_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ScopeService', () {
    late ScopeService scopeService;
    late http.Client mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      scopeService = ScopeService(mockHttpClient);
    });

    group('getScopesFromAccessToken', () {
      test('should return scopes when token is valid', () async {
        // Arrange
        const token = 'valid_token_123';
        const expectedScopes = ['repo', 'read:user'];
        when(
          mockHttpClient.get(
            Uri.parse('https://api.github.com/applications/token/scopes'),
            headers: {
              'Authorization': 'token $token',
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'gh3-flutter-app',
            },
          ),
        ).thenAnswer(
          (_) async => http.Response(
            '{"message": "API rate limit exceeded"}',
            200,
            headers: {'x-oauth-scopes': 'repo, read:user'},
          ),
        );

        // Act
        final result = await scopeService.getScopesFromAccessToken(token);

        // Assert
        expect(result, equals(expectedScopes));
        verify(mockHttpClient).called(1);
        verify(
          mockHttpClient.get(
            Uri.parse('https://api.github.com/applications/token/scopes'),
            headers: {
              'Authorization': 'token $token',
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'gh3-flutter-app',
            },
          ),
        ).called(1);
      });

      test('should return empty list when no scopes are present', () async {
        // Arrange
        const token = 'valid_token_123';
        when(
          mockHttpClient.get(
            Uri.parse('https://api.github.com/applications/token/scopes'),
            headers: {
              'Authorization': 'token $token',
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'gh3-flutter-app',
            },
          ),
        ).thenAnswer(
          (_) async =>
              http.Response('{}', 200, headers: {'x-oauth-scopes': ''}),
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
        when(
          mockHttpClient.get(
            Uri.parse('https://api.github.com/applications/token/scopes'),
            headers: {
              'Authorization': 'token $token',
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'gh3-flutter-app',
            },
          ),
        ).thenAnswer(
          (_) async => http.Response(
            '{}',
            200,
            headers: {'x-oauth-scopes': ' repo , read:user,  write:repo_hook '},
          ),
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
          when(
            mockHttpClient.get(
              Uri.parse('https://api.github.com/applications/token/scopes'),
              headers: {
                'Authorization': 'token $token',
                'Accept': 'application/vnd.github.v3+json',
                'User-Agent': 'gh3-flutter-app',
              },
            ),
          ).thenAnswer(
            (_) async => http.Response('{"message": "Bad credentials"}', 401),
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
          when(
            mockHttpClient.get(
              Uri.parse('https://api.github.com/applications/token/scopes'),
              headers: {
                'Authorization': 'token $token',
                'Accept': 'application/vnd.github.v3+json',
                'User-Agent': 'gh3-flutter-app',
              },
            ),
          ).thenAnswer(
            (_) async =>
                http.Response('{"message": "API rate limit exceeded"}', 403),
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
          when(
            mockHttpClient.get(
              Uri.parse('https://api.github.com/applications/token/scopes'),
              headers: {
                'Authorization': 'token $token',
                'Accept': 'application/vnd.github.v3+json',
                'User-Agent': 'gh3-flutter-app',
              },
            ),
          ).thenAnswer(
            (_) async =>
                http.Response('{"message": "Internal Server Error"}', 500),
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
          when(
            mockHttpClient.get(
              Uri.parse('https://api.github.com/applications/token/scopes'),
              headers: {
                'Authorization': 'token $token',
                'Accept': 'application/vnd.github.v3+json',
                'User-Agent': 'gh3-flutter-app',
              },
            ),
          ).thenAnswer((_) async => http.Response('{}', 200));

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
        when(
          mockHttpClient.get(
            Uri.parse('https://api.github.com/applications/token/scopes'),
            headers: {
              'Authorization': 'token $token',
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'gh3-flutter-app',
            },
          ),
        ).thenThrow(
          TimeoutException('Request timeout', const Duration(seconds: 10)),
        );

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
          when(
            mockHttpClient.get(
              Uri.parse('https://api.github.com/applications/token/scopes'),
              headers: {
                'Authorization': 'token $token',
                'Accept': 'application/vnd.github.v3+json',
                'User-Agent': 'gh3-flutter-app',
              },
            ),
          ).thenThrow(const SocketException('Network unreachable'));

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
          when(
            mockHttpClient.get(
              Uri.parse('https://api.github.com/applications/token/scopes'),
              headers: {
                'Authorization': 'token $token',
                'Accept': 'application/vnd.github.v3+json',
                'User-Agent': 'gh3-flutter-app',
              },
            ),
          ).thenThrow(http.ClientException('Client error'));

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
          when(
            mockHttpClient.get(
              Uri.parse('https://api.github.com/applications/token/scopes'),
              headers: {
                'Authorization': 'token $token',
                'Accept': 'application/vnd.github.v3+json',
                'User-Agent': 'gh3-flutter-app',
              },
            ),
          ).thenThrow(Exception('Generic error'));

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
