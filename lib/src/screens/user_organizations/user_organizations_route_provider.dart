import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../routing/route_provider.dart';
import 'user_organizations_screen.dart';

/// Route provider for the user organizations screen module.
/// Implements RouteProvider interface to provide modular route configuration
/// with parameterized routes.
@Named("UserOrganizationsRouteProvider")
@Singleton(as: RouteProvider)
class UserOrganizationsRouteProvider implements RouteProvider {
  UserOrganizationsRouteProvider();

  @override
  RouteBase getRoute() {
    return GoRoute(
      path: '/:login/organizations',
      builder: (context, state) {
        final login = state.pathParameters['login']!;
        return UserOrganizationsScreen(login: login);
      },
    );
  }
}
