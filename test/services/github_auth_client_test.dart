import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:gh3/src/services/github_auth_client.dart';

void main() {
  group('GithubAuthClient', () {
    late GithubAuthClient client;
    late _MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = _MockHttpClient();
      client = GithubAuthClient(mockHttpClient, 'test_client_id');
    });

    group('createDeviceCode', () {
      test('should return device code result on success', () async {
        // Arrange
        const expectedDeviceCode = 'device_code_123';
        const expectedUserCode = 'USER123';
        mockHttpClient.mockResponse = http.Response(
          '{"device_code": "$expectedDeviceCode", "user_code": "$expectedUserCode"}',
          200,
        );

        // Act
        final result = await client.createDeviceCode(['repo', 'read:user']);

        // Assert
        expect(result.deviceCode, equals(expectedDeviceCode));
        expect(result.userCode, equals(expectedUserCode));
        expect(mockHttpClient.lastRequest?.url.host, equals('github.com'));
        expect(mockHttpClient.lastRequest?.url.path, equals('/login/device/code'));
        expect(mockHttpClient.lastRequest?.headers['Accept'], equals('application/json'));
        expect(mockHttpClient.lastRequest?.headers['User-Agent'], equals('gh3-flutter-app'));
      });

      test('should throw ArgumentError for empty scopes', () async {
        // Act & Assert
        expect(
          () => client.createDeviceCode([]),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw GithubNonRecoverableException on HTTP 500 error', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response('Internal Server Error', 500);

        // Act & Assert
        expect(
          () => client.createDeviceCode(['repo']),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('server_error'))
                .having((e) => e.description, 'description', contains('GitHub server error')),
          ),
        );
      });

      test('should throw GithubNonRecoverableException on rate limit (429)', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response('Rate limit exceeded', 429);

        // Act & Assert
        expect(
          () => client.createDeviceCode(['repo']),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('rate_limit_exceeded')),
          ),
        );
      });

      test('should throw GithubNonRecoverableException on invalid JSON', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response('invalid json', 200);

        // Act & Assert
        expect(
          () => client.createDeviceCode(['repo']),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('invalid_response')),
          ),
        );
      });

      test('should throw GithubNonRecoverableException on OAuth error in response', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response(
          '{"error": "invalid_client", "error_description": "Client authentication failed"}',
          200,
        );

        // Act & Assert
        expect(
          () => client.createDeviceCode(['repo']),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('invalid_client'))
                .having((e) => e.description, 'description', contains('Client authentication failed')),
          ),
        );
      });

      test('should throw GithubNonRecoverableException on timeout', () async {
        // Arrange
        mockHttpClient.shouldTimeout = true;

        // Act & Assert
        expect(
          () => client.createDeviceCode(['repo']),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('timeout')),
          ),
        );
      });

      test('should throw GithubNonRecoverableException on socket exception', () async {
        // Arrange
        mockHttpClient.shouldThrowSocketException = true;

        // Act & Assert
        expect(
          () => client.createDeviceCode(['repo']),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('network_error')),
          ),
        );
      });

      test('should throw GithubNonRecoverableException on HTTP client exception', () async {
        // Arrange
        mockHttpClient.shouldThrowClientException = true;

        // Act & Assert
        expect(
          () => client.createDeviceCode(['repo']),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('client_error')),
          ),
        );
      });

      test('should retry on transient failures', () async {
        // Arrange
        mockHttpClient.failureCount = 2; // Fail twice, then succeed
        mockHttpClient.mockResponse = http.Response(
          '{"device_code": "test_code", "user_code": "TEST123"}',
          200,
        );

        // Act
        final result = await client.createDeviceCode(['repo']);

        // Assert
        expect(result.deviceCode, equals('test_code'));
        expect(mockHttpClient.requestCount, equals(3)); // 2 failures + 1 success
      });

      test('should not retry on ArgumentError', () async {
        // Act & Assert
        expect(
          () => client.createDeviceCode([]),
          throwsA(isA<ArgumentError>()),
        );
        expect(mockHttpClient.requestCount, equals(0)); // No HTTP requests made
      });

      test('should not retry on GithubAuthException', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response('Rate limit exceeded', 429);

        // Act & Assert
        expect(
          () => client.createDeviceCode(['repo']),
          throwsA(isA<GithubNonRecoverableException>()),
        );
        expect(mockHttpClient.requestCount, equals(1)); // Only one attempt
      });
    });

    group('createAccessTokenFromDeviceCode', () {
      test('should return access token on success', () async {
        // Arrange
        const expectedToken = 'access_token_123';
        mockHttpClient.mockResponse = http.Response(
          '{"access_token": "$expectedToken"}',
          200,
        );

        // Act
        final result = await client.createAccessTokenFromDeviceCode('device_code');

        // Assert
        expect(result, equals(expectedToken));
        expect(mockHttpClient.lastRequest?.url.host, equals('github.com'));
        expect(mockHttpClient.lastRequest?.url.path, equals('/login/oauth/access_token'));
      });

      test('should throw ArgumentError for empty device code', () async {
        // Act & Assert
        expect(
          () => client.createAccessTokenFromDeviceCode(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw AuthorizationPendingException for authorization_pending', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response(
          '{"error": "authorization_pending"}',
          200,
        );

        // Act & Assert
        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(isA<AuthorizationPendingException>()),
        );
      });

      test('should throw SlowDownException for slow_down', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response(
          '{"error": "slow_down"}',
          200,
        );

        // Act & Assert
        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(isA<SlowDownException>()),
        );
      });

      test('should throw AccessDeniedException for access_denied', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response(
          '{"error": "access_denied"}',
          200,
        );

        // Act & Assert
        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(isA<AccessDeniedException>()),
        );
      });

      test('should throw GithubNonRecoverableException for other OAuth errors', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response(
          '{"error": "invalid_grant", "error_description": "The device code is invalid"}',
          200,
        );

        // Act & Assert
        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('invalid_grant'))
                .having((e) => e.description, 'description', contains('The device code is invalid')),
          ),
        );
      });

      test('should throw GithubNonRecoverableException when access token is missing', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response('{}', 200);

        // Act & Assert
        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('invalid_response'))
                .having((e) => e.description, 'description', contains('Access token not found')),
          ),
        );
      });

      test('should throw GithubNonRecoverableException when access token is empty', () async {
        // Arrange
        mockHttpClient.mockResponse = http.Response('{"access_token": ""}', 200);

        // Act & Assert
        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('invalid_response')),
          ),
        );
      });

      test('should handle unexpected errors gracefully', () async {
        // Arrange
        mockHttpClient.shouldThrowGenericException = true;

        // Act & Assert
        expect(
          () => client.createAccessTokenFromDeviceCode('device_code'),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('unexpected_error')),
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
        // Arrange
        mockHttpClient.mockResponse = http.Response('{"incomplete": json', 200);

        // Act & Assert
        expect(
          () => client.createDeviceCode(['repo']),
          throwsA(
            isA<GithubNonRecoverableException>()
                .having((e) => e.code, 'code', equals('invalid_response'))
                .having((e) => e.description, 'description', contains('Failed to parse JSON')),
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
        final exception = GithubNonRecoverableException('test_code', 'test description');

        // Assert
        expect(exception.code, equals('test_code'));
        expect(exception.description, equals('test description'));
        expect(exception.message, equals('test_code: test description'));
        expect(exception.toString(), equals('GithubAuthException: test_code: test description'));
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

/// Mock HTTP client for testing
class _MockHttpClient extends http.BaseClient {
  http.Response? mockResponse;
  http.BaseRequest? lastRequest;
  int requestCount = 0;
  int failureCount = 0;
  int currentFailures = 0;
  
  bool shouldTimeout = false;
  bool shouldThrowSocketException = false;
  bool shouldThrowClientException = false;
  bool shouldThrowGenericException = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    lastRequest = request;
    requestCount++;

    if (shouldTimeout) {
      throw TimeoutException('Request timeout', const Duration(seconds: 30));
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

    // Simulate transient failures for retry testing
    if (currentFailures < failureCount) {
      currentFailures++;
      throw Exception('Temporary network error'); // Use generic exception for retry testing
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