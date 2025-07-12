import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

class GithubDeviceCodeResult {
  GithubDeviceCodeResult({required this.deviceCode, required this.userCode});

  String deviceCode;
  String userCode;

  factory GithubDeviceCodeResult.fromJson(Map<String, dynamic> json) =>
      GithubDeviceCodeResult(
        deviceCode: json['device_code'],
        userCode: json['user_code'],
      );
}

// Custom exceptions for GitHub OAuth flow
abstract class GithubAuthException implements Exception {
  final String message;
  GithubAuthException([this.message = '']);
  @override
  String toString() => 'GithubAuthException: $message';
}

abstract class GithubRecoverableException extends GithubAuthException {
  GithubRecoverableException([super.message]);
}

class AuthorizationPendingException extends GithubRecoverableException {
  AuthorizationPendingException([super.message = 'Authorization pending']);
}

class SlowDownException extends GithubRecoverableException {
  SlowDownException([super.message = 'Slow down']);
}

class AccessDeniedException extends GithubRecoverableException {
  AccessDeniedException([super.message = 'Access denied']);
}

@injectable
class GithubNonRecoverableException extends GithubAuthException {
  final String code;
  final String description;
  GithubNonRecoverableException(this.code, this.description)
    : super("$code: $description");
}

@module
abstract class GithubAuthHttpClientModule {
  @lazySingleton
  http.Client get httpClient => http.Client();
}

@injectable
class GithubAuthClient {
  final http.Client _httpClient;
  final String _githubClientID;

  const GithubAuthClient(
    http.Client httpClient,
    @Named('GithubClientID') String githubClientID,
  ) : _httpClient = httpClient,
      _githubClientID = githubClientID;

  Future<GithubDeviceCodeResult> createDeviceCode(List<String> scopes) async {
    var url = Uri.https('github.com', '/login/device/code', {
      'client_id': _githubClientID,
      'scope': scopes.join(' '),
    });
    var response = await _httpClient.post(
      url,
      headers: {'Accept': 'application/json'},
    );
    Map<String, dynamic> parsedBody = jsonDecode(response.body);
    return GithubDeviceCodeResult.fromJson(parsedBody);
  }

  // Update return type to always throw on error, never return null
  Future<String> createAccessTokenFromDeviceCode(String deviceCode) async {
    var url = Uri.https('github.com', '/login/oauth/access_token', {
      'client_id': _githubClientID,
      'device_code': deviceCode,
      'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
    });
    var response = await _httpClient.post(
      url,
      headers: {'Accept': 'application/json'},
    );
    Map<String, dynamic> parsedBody = jsonDecode(response.body);

    final error = parsedBody['error'] as String?;
    if (error != null) {
      switch (error) {
        case 'authorization_pending':
          throw AuthorizationPendingException();
        case 'slow_down':
          throw SlowDownException();
        case 'access_denied':
          throw AccessDeniedException();
        default:
          throw GithubNonRecoverableException(
            error,
            parsedBody['error_description'],
          );
      }
    }

    return parsedBody['access_token'] as String;
  }
}
