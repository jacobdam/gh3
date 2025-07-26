import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../routing/route_provider.dart';
import 'user_starred_screen.dart';

/// Route provider for the user starred repositories screen module.
/// Implements RouteProvider interface to provide modular route configuration
/// with parameterized routes.
@Named("UserStarredRouteProvider")
@Singleton(as: RouteProvider)
class UserStarredRouteProvider implements RouteProvider {
  UserStarredRouteProvider();

  @override
  RouteBase getRoute() {
    return GoRoute(
      path: '/:login/starred',
      builder: (context, state) {
        final login = state.pathParameters['login']!;
        return UserStarredScreen(login: login);
      },
    );
  }
}
