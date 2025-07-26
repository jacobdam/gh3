import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../routing/route_provider.dart';
import 'user_repositories_screen.dart';
import 'user_repositories_viewmodel_factory.dart';

/// Route provider for the user repositories screen module.
/// Implements RouteProvider interface to provide modular route configuration
/// with parameterized routes.
@Named("UserRepositoriesRouteProvider")
@Singleton(as: RouteProvider)
class UserRepositoriesRouteProvider implements RouteProvider {
  final UserRepositoriesViewModelFactory _viewModelFactory;

  UserRepositoriesRouteProvider(this._viewModelFactory);

  @override
  RouteBase getRoute() {
    return GoRoute(
      path: '/:login/@repositories',
      builder: (context, state) {
        final login = state.pathParameters['login']!;
        return UserRepositoriesScreen(
          login: login,
          viewModel: _viewModelFactory.create(login),
        );
      },
    );
  }
}
