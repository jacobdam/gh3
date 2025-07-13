import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

/// Interface for fetching scopes from a GitHub access token.
abstract class IScopeService {
  Future<List<String>> getScopesFromAccessToken(String accessToken);
}

@LazySingleton(as: IScopeService)
class ScopeService implements IScopeService {
  final http.Client _httpClient;

  ScopeService(this._httpClient);

  @override
  Future<List<String>> getScopesFromAccessToken(String accessToken) async {
    final response = await _httpClient.get(
      Uri.https('api.github.com', '/'),
      headers: {'Authorization': 'token $accessToken'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch scopes: ${response.body}');
    }
    final scopesHeader = response.headers['x-oauth-scopes'];
    if (scopesHeader == null) {
      throw Exception('No scopes found in response headers');
    }
    return scopesHeader.split(',').map((s) => s.trim()).toList();
  }
}
