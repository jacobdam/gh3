import 'package:gh3/src/routing/app_route.dart';

/// Typed route for the user starred repositories screen with username parameter
class UserStarredRoute extends AppRoute {
  final String login;

  UserStarredRoute(this.login);

  @override
  String get path => '/$login/starred';
}
