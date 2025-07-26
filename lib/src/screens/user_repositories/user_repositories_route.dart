import 'package:gh3/src/routing/app_route.dart';

/// Typed route for the user repositories screen with username parameter
class UserRepositoriesRoute extends AppRoute {
  final String login;

  UserRepositoriesRoute(this.login);

  @override
  String get path => '/$login/repositories';
}
