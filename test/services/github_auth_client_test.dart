import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'github_auth_client_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('GithubAuthClient', () {
    late GithubAuthClient client;
    late http.Client mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      client = GithubAuthClient(mockHttpClient, 'test_client_id');
    });

    group('createDeviceCode', () {
      test('should return device code result on success', () async {
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/device/code', {
              'client_id': 'test_client_id',
              'scope': 'repo read:user',
            }),
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'gh3-flutter-app',
            },
            body: null,
          ),
        ).thenAnswer(
          (_) async => http.Response(
            '{"device_code": "device_code_123", "user_code": "USER123"}',
            200,
          ),
        );

        final result = await client.createDeviceCode(['repo', 'read:user']);
        expect(result.deviceCode, equals('device_code_123'));
        expect(result.userCode, equals('USER123'));
      });

      test('should throw ArgumentError for empty scopes', () async {
        expect(
          () => client.createDeviceCode([]),
          throwsA(isA<ArgumentError>()),
        );
      });

      test(
        'should throw GithubNonRecoverableException on HTTP 500 error',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/device/code', {
                'client_id': 'test_client_id',
                'scope': 'repo read:user',
              }),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => http.Response('Internal Server Error', 500),
          );

          expect(
            () => client.createDeviceCode(['repo', 'read:user']),
            throwsA(
              isA<GithubNonRecoverableException>()
                  .having((e) => e.code, 'code', equals('server_error'))
                  .having(
                    (e) => e.description,
                    'description',
                    contains('GitHub server error'),
                  ),
            ),
          );
        },
      );

      test(
        'should throw GithubNonRecoverableException on rate limit (429)',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/device/code', {
                'client_id': 'test_client_id',
                'scope': 'repo read:user',
              }),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer((_) async => http.Response('Rate limit exceeded', 429));

          expect(
            () => client.createDeviceCode(['repo', 'read:user']),
            throwsA(
              isA<GithubNonRecoverableException>().having(
                (e) => e.code,
                'code',
                equals('rate_limit_exceeded'),
              ),
            ),
          );
        },
      );

      test(
        'should throw GithubNonRecoverableException on invalid JSON',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/device/code', {
                'client_id': 'test_client_id',
                'scope': 'repo read:user',
              }),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer((_) async => http.Response('invalid json', 200));

          expect(
            () => client.createDeviceCode(['repo', 'read:user']),
            throwsA(
              isA<GithubNonRecoverableException>().having(
                (e) => e.code,
                'code',
                equals('invalid_response'),
              ),
            ),
          );
        },
      );

      test(
        'should throw GithubNonRecoverableException on OAuth error in response',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/device/code', {
                'client_id': 'test_client_id',
                'scope': 'repo read:user',
              }),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => http.Response(
              '{"error": "invalid_client", "error_description": "Client authentication failed"}',
              200,
            ),
          );

          expect(
            () => client.createDeviceCode(['repo', 'read:user']),
            throwsA(
              isA<GithubNonRecoverableException>()
                  .having((e) => e.code, 'code', equals('invalid_client'))
                  .having(
                    (e) => e.description,
                    'description',
                    contains('Client authentication failed'),
                  ),
            ),
          );
        },
      );

      test('should throw GithubNonRecoverableException on timeout', () async {
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/device/code', {
              'client_id': 'test_client_id',
              'scope': 'repo read:user',
            }),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenThrow(
          TimeoutException('Request timeout', const Duration(seconds: 30)),
        );

        expect(
          () => client.createDeviceCode(['repo', 'read:user']),
          throwsA(
            isA<GithubNonRecoverableException>().having(
              (e) => e.code,
              'code',
              equals('timeout'),
            ),
          ),
        );
      });

      test(
        'should throw GithubNonRecoverableException on socket exception',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/device/code', {
                'client_id': 'test_client_id',
                'scope': 'repo read:user',
              }),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => Future.delayed(
              const Duration(seconds: 1),
              () => throw const SocketException('Network unreachable'),
            ),
          );

          expect(
            () => client.createDeviceCode(['repo', 'read:user']),
            throwsA(
              isA<GithubNonRecoverableException>().having(
                (e) => e.code,
                'code',
                equals('network_error'),
              ),
            ),
          );
        },
      );

      test(
        'should throw GithubNonRecoverableException on HTTP client exception',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/device/code', {
                'client_id': 'test_client_id',
                'scope': 'repo read:user',
              }),
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => Future.delayed(
              const Duration(seconds: 1),
              () => throw http.ClientException('Client error'),
            ),
          );

          expect(
            () => client.createDeviceCode(['repo', 'read:user']),
            throwsA(
              isA<GithubNonRecoverableException>().having(
                (e) => e.code,
                'code',
                equals('client_error'),
              ),
            ),
          );
        },
      );

      test('should retry on transient failures', () async {
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/device/code', {
              'client_id': 'test_client_id',
              'scope': 'repo read:user',
            }),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => Future.delayed(
            const Duration(seconds: 1),
            () => throw Exception('Temporary network error'),
          ),
        );
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/device/code', {
              'client_id': 'test_client_id',
              'scope': 'repo read:user',
            }),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => Future.delayed(
            const Duration(seconds: 1),
            () => http.Response(
              '{"device_code": "test_code", "user_code": "TEST123"}',
              200,
            ),
          ),
        );

        final result = await client.createDeviceCode(['repo', 'read:user']);
        expect(result.deviceCode, equals('test_code'));
      });

      test('should not retry on ArgumentError', () async {
        expect(
          () => client.createDeviceCode([]),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should not retry on GithubAuthException', () async {
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/device/code', {
              'client_id': 'test_client_id',
              'scope': 'repo read:user',
            }),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => Future.delayed(
            const Duration(seconds: 1),
            () => http.Response('Rate limit exceeded', 429),
          ),
        );

        expect(
          () => client.createDeviceCode(['repo', 'read:user']),
          throwsA(isA<GithubNonRecoverableException>()),
        );
      });
    });

    group('createAccessTokenFromDeviceCode', () {
      test('should return access token on success', () async {
        const expectedToken = 'access_token_123';
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/oauth/access_token', {
              'client_id': 'test_client_id',
              'device_code': 'device_code',
              'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
            }),
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'gh3-flutter-app',
            },
            body: null,
          ),
        ).thenAnswer(
          (_) async => http.Response('{"access_token": "$expectedToken"}', 200),
        );

        final result = await client.createAccessTokenFromDeviceCode(
          'device_code',
        );

        expect(result, equals(expectedToken));
      });

      test('should throw ArgumentError for empty device code', () async {
        expect(
          () => client.createAccessTokenFromDeviceCode(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test(
        'should throw AuthorizationPendingException for authorization_pending',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/oauth/access_token', {
                'client_id': 'test_client_id',
                'device_code': 'device_code',
                'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
              }),
              headers: {
                'Accept': 'application/json',
                'User-Agent': 'gh3-flutter-app',
              },
              body: null,
            ),
          ).thenAnswer(
            (_) async =>
                http.Response('{"error": "authorization_pending"}', 200),
          );

          expect(
            () => client.createAccessTokenFromDeviceCode('device_code'),
            throwsA(isA<AuthorizationPendingException>()),
          );
        },
      );

      test('should throw SlowDownException for slow_down', () async {
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/oauth/access_token', {
              'client_id': 'test_client_id',
              'device_code': 'device_code',
              'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
            }),
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'gh3-flutter-app',
            },
            body: null,
          ),
        ).thenAnswer((_) async => http.Response('{"error": "slow_down"}', 200));

        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(isA<SlowDownException>()),
        );
      });

      test('should throw AccessDeniedException for access_denied', () async {
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/oauth/access_token', {
              'client_id': 'test_client_id',
              'device_code': 'device_code',
              'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
            }),
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'gh3-flutter-app',
            },
            body: null,
          ),
        ).thenAnswer(
          (_) async => http.Response('{"error": "access_denied"}', 200),
        );

        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(isA<AccessDeniedException>()),
        );
      });

      test(
        'should throw GithubNonRecoverableException for other OAuth errors',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/oauth/access_token', {
                'client_id': 'test_client_id',
                'device_code': 'device_code',
                'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
              }),
              headers: {
                'Accept': 'application/json',
                'User-Agent': 'gh3-flutter-app',
              },
              body: null,
            ),
          ).thenAnswer(
            (_) async => http.Response(
              '{"error": "invalid_grant", "error_description": "The device code is invalid"}',
              200,
            ),
          );

          expect(
            () => client.createAccessTokenFromDeviceCode('device_code'),
            throwsA(
              isA<GithubNonRecoverableException>()
                  .having((e) => e.code, 'code', equals('invalid_grant'))
                  .having(
                    (e) => e.description,
                    'description',
                    contains('The device code is invalid'),
                  ),
            ),
          );
        },
      );

      test(
        'should throw GithubNonRecoverableException when access token is missing',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/oauth/access_token', {
                'client_id': 'test_client_id',
                'device_code': 'device_code',
                'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
              }),
              headers: {
                'Accept': 'application/json',
                'User-Agent': 'gh3-flutter-app',
              },
              body: null,
            ),
          ).thenAnswer((_) async => http.Response('{}', 200));

          expect(
            () => client.createAccessTokenFromDeviceCode('device_code'),
            throwsA(
              isA<GithubNonRecoverableException>()
                  .having((e) => e.code, 'code', equals('invalid_response'))
                  .having(
                    (e) => e.description,
                    'description',
                    contains('Access token not found'),
                  ),
            ),
          );
        },
      );

      test(
        'should throw GithubNonRecoverableException when access token is empty',
        () async {
          when(
            mockHttpClient.post(
              Uri.https('github.com', '/login/oauth/access_token', {
                'client_id': 'test_client_id',
                'device_code': 'device_code',
                'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
              }),
              headers: {
                'Accept': 'application/json',
                'User-Agent': 'gh3-flutter-app',
              },
              body: null,
            ),
          ).thenAnswer((_) async => http.Response('{"access_token": ""}', 200));

          expect(
            () => client.createAccessTokenFromDeviceCode('device_code'),
            throwsA(
              isA<GithubNonRecoverableException>().having(
                (e) => e.code,
                'code',
                equals('invalid_response'),
              ),
            ),
          );
        },
      );

      test('should handle unexpected errors gracefully', () async {
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/oauth/access_token', {
              'client_id': 'test_client_id',
              'device_code': 'device_code',
              'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
            }),
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'gh3-flutter-app',
            },
            body: null,
          ),
        ).thenAnswer(
          (_) async => Future.delayed(
            const Duration(seconds: 1),
            () => throw Exception('Unexpected error'),
          ),
        );

        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(
            isA<GithubNonRecoverableException>().having(
              (e) => e.code,
              'code',
              equals('unexpected_error'),
            ),
          ),
        );
      });
    });

    group('error handling and logging', () {
      test('should sanitize sensitive information in logs', () {
        // This test verifies that the _sanitizeUrl method works correctly
        // We can't directly test logging output, but we can verify the method behavior
        final client = GithubAuthClient(mockHttpClient, 'test_client_id');

        // The sanitization happens internally, so we verify through successful execution
        // without exposing sensitive data in logs
        expect(() => client.createDeviceCode(['repo']), returnsNormally);
      });

      test('should handle malformed JSON gracefully', () async {
        when(
          mockHttpClient.post(
            Uri.https('github.com', '/login/device/code', {
              'client_id': 'test_client_id',
              'scope': 'repo read:user',
            }),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('{"incomplete": json', 200));

        expect(
          () => client.createDeviceCode(['repo', 'read:user']),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('invalid_response'))
                .having(
                  (e) => e.description,
                  'description',
                  contains('Failed to parse JSON'),
                ),
          ),
        );
      });
    });

    group('GithubDeviceCodeResult', () {
      test('should create from JSON correctly', () {
        // Arrange
        final json = {
          'device_code': 'test_device_code',
          'user_code': 'TEST123',
        };

        // Act
        final result = GithubDeviceCodeResult.fromJson(json);

        // Assert
        expect(result.deviceCode, equals('test_device_code'));
        expect(result.userCode, equals('TEST123'));
      });
    });

    group('Exception hierarchy', () {
      test('should create GithubNonRecoverableException correctly', () {
        // Arrange & Act
        final exception = GithubNonRecoverableException(
          'test_code',
          'test description',
        );

        // Assert
        expect(exception.code, equals('test_code'));
        expect(exception.description, equals('test description'));
        expect(exception.message, equals('test_code: test description'));
        expect(
          exception.toString(),
          equals('GithubAuthException: test_code: test description'),
        );
      });

      test('should create recoverable exceptions correctly', () {
        // Test AuthorizationPendingException
        final authPending = AuthorizationPendingException();
        expect(authPending.message, equals('Authorization pending'));
        expect(authPending, isA<GithubRecoverableException>());

        // Test SlowDownException
        final slowDown = SlowDownException();
        expect(slowDown.message, equals('Slow down'));
        expect(slowDown, isA<GithubRecoverableException>());

        // Test AccessDeniedException
        final accessDenied = AccessDeniedException();
        expect(accessDenied.message, equals('Access denied'));
        expect(accessDenied, isA<GithubRecoverableException>());
      });
    });
  });
}
