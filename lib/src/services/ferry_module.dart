import 'package:ferry/ferry.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

@module
abstract class FerryModule {
  @lazySingleton
  Client ferryClient(AuthService authService, http.Client httpClient) {
    final authLink = _AuthLink(authService);
    final httpLink = HttpLink(
      "https://api.github.com/graphql",
      httpClient: httpClient,
    );

    final link = Link.from([authLink, httpLink]);
    return Client(link: link);
  }
}

/// Private authentication link implementation for Ferry GraphQL client
/// Dynamically injects GitHub access tokens into GraphQL requests
class _AuthLink extends Link {
  final AuthService _authService;

  _AuthLink(this._authService);

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final token = _authService.accessToken;

    final updatedRequest = request.updateContextEntry<HttpLinkHeaders>(
      (headers) => HttpLinkHeaders(
        headers: {
          ...?headers?.headers,
          'User-Agent': 'gh3-flutter-app',
          'Accept': 'application/vnd.github.v4+json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    yield* forward!(updatedRequest);
  }
}
