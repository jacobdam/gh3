import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:gh3/src/env/env.dart';
import 'package:injectable/injectable.dart';

abstract class Route {
  String getName();
}

@Named("RouteA")
@Injectable(as: Route)
class RouteA implements Route {
  @override
  String getName() => 'RouteA';
}

@Named("RouteB")
@Injectable(as: Route)
class RouteB implements Route {
  @override
  String getName() => 'RouteB';
}

@module
abstract class RouteModule {
  @Named("routes")
  @lazySingleton
  List<Route> get things =>
      GetIt.instance.getAll<Route>().toList(growable: false);
}

@injectable
class RouteConsumer {
  final List<Route> routes;

  RouteConsumer(@Named("routes") this.routes);

  void printRoutes() {
    for (var route in routes) {
      log(route.getName());
    }
  }

  void printGithubClientId() {
    final githubClientId = GetIt.instance<Env>().githubClientId;
    log('GitHub Client ID: $githubClientId');
  }
}
