import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:gh3/src/services/github_auth_client.dart';

void main() {
  const clientId = 'testClientId';
  group('GithubAuthClient', () {
    test(
      'createDeviceCode returns GithubDeviceCodeResult and calls correct endpoint',
      () async {
        late http.Request capturedRequest;
        final mockClient = MockClient((http.Request request) async {
          capturedRequest = request;
          final responseJson = {
            'device_code': 'device123',
            'user_code': 'user456',
          };
          return http.Response(
            jsonEncode(responseJson),
            200,
            headers: {'content-type': 'application/json'},
          );
        });
        final authClient = GithubAuthClient(mockClient, clientId);

        final result = await authClient.createDeviceCode(['repo', 'user']);

        expect(result.deviceCode, equals('device123'));
        expect(result.userCode, equals('user456'));

        expect(capturedRequest.method, equals('POST'));
        expect(capturedRequest.url.scheme, 'https');
        expect(capturedRequest.url.host, 'github.com');
        expect(capturedRequest.url.path, '/login/device/code');
        expect(capturedRequest.url.queryParameters['client_id'], clientId);
        expect(capturedRequest.url.queryParameters['scope'], 'repo user');
        expect(capturedRequest.headers['Accept'], 'application/json');
      },
    );

    test(
      'createAccessTokenFromDeviceCode throws AuthorizationPendingException on pending',
      () async {
        final mockClient = MockClient((http.Request request) async {
          return http.Response(
            jsonEncode({'error': 'authorization_pending'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        });
        final authClient = GithubAuthClient(mockClient, clientId);
        expect(
          authClient.createAccessTokenFromDeviceCode('deviceCode123'),
          throwsA(isA<AuthorizationPendingException>()),
        );
      },
    );

    test(
      'createAccessTokenFromDeviceCode throws GithubNonRecoverableException on invalid_request',
      () async {
        final mockClient = MockClient((http.Request request) async {
          return http.Response(
            jsonEncode({
              'error': 'invalid_request',
              'error_description': 'bad',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        });
        final authClient = GithubAuthClient(mockClient, clientId);
        expect(
          authClient.createAccessTokenFromDeviceCode('deviceCode123'),
          throwsA(isA<GithubNonRecoverableException>()),
        );
      },
    );

    test(
      'createAccessTokenFromDeviceCode returns access_token when successful',
      () async {
        final mockClient = MockClient((http.Request request) async {
          final responseJson = {'access_token': 'tokenXYZ'};
          return http.Response(
            jsonEncode(responseJson),
            200,
            headers: {'content-type': 'application/json'},
          );
        });
        final authClient = GithubAuthClient(mockClient, clientId);
        final token = await authClient.createAccessTokenFromDeviceCode(
          'deviceCode123',
        );
        expect(token, equals('tokenXYZ'));
      },
    );
  });
}
