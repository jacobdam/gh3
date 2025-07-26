import 'package:gh3/src/routing/app_route.dart';

/// Typed route for the user organizations screen with username parameter
class UserOrganizationsRoute extends AppRoute {
  final String login;

  UserOrganizationsRoute(this.login);

  @override
  String get path => '/$login/organizations';
}
