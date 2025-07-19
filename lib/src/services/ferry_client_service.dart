import 'package:ferry/ferry.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:injectable/injectable.dart';
import 'token_storage.dart';

/// Service for configuring and providing Ferry GraphQL client
@injectable
class FerryClientService {
  final ITokenStorage _tokenStorage;
  Client? _client;

  FerryClientService(this._tokenStorage);

  /// Get or create Ferry client instance
  Future<Client> getClient() async {
    if (_client != null) return _client!;

    _client = await _createClient();
    return _client!;
  }

  /// Create a new Ferry client with authentication
  Future<Client> _createClient() async {
    final token = await _tokenStorage.getToken();

    final httpLink = HttpLink(
      'https://api.github.com/graphql',
      defaultHeaders: {
        'User-Agent': 'gh3-flutter-app',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final cache = Cache();

    return Client(link: httpLink, cache: cache);
  }

  /// Update authentication token and recreate client
  Future<void> updateAuthToken(String? token) async {
    _client = null; // Force recreation with new token
    _client = await _createClient();
  }

  /// Clear cache (useful for logout)
  void clearCache() {
    _client?.cache.clear();
  }

  /// Dispose resources
  void dispose() {
    _client?.dispose();
    _client = null;
  }
}
