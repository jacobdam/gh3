// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:gh3/src/env/env.dart' as _i589;
import 'package:gh3/src/services/github_auth_client.dart' as _i1035;
import 'package:gh3/src/services/route.dart' as _i312;
import 'package:gh3/src/services/service_a.dart' as _i412;
import 'package:gh3/src/services/service_b.dart' as _i947;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final envModule = _$EnvModule();
    final githubAuthHttpClientModule = _$GithubAuthHttpClientModule();
    final routeModule = _$RouteModule();
    gh.factory<_i412.ServiceA>(() => _i412.ServiceA());
    gh.lazySingleton<_i589.Env>(() => envModule.env);
    gh.lazySingleton<_i519.Client>(() => githubAuthHttpClientModule.httpClient);
    gh.factory<_i947.ServiceB>(() => _i947.ServiceB(gh<_i412.ServiceA>()));
    gh.factory<_i312.Route>(() => _i312.RouteA(), instanceName: 'RouteA');
    gh.lazySingleton<List<_i312.Route>>(
      () => routeModule.things,
      instanceName: 'routes',
    );
    gh.factory<String>(
      () => envModule.githubClientId,
      instanceName: 'GithubClientID',
    );
    gh.factory<_i312.Route>(() => _i312.RouteB(), instanceName: 'RouteB');
    gh.factory<_i312.RouteConsumer>(
      () => _i312.RouteConsumer(gh<List<_i312.Route>>(instanceName: 'routes')),
    );
    gh.factory<_i1035.GithubAuthClient>(
      () => _i1035.GithubAuthClient(
        gh<_i519.Client>(),
        gh<String>(instanceName: 'GithubClientID'),
      ),
    );
    return this;
  }
}

class _$EnvModule extends _i589.EnvModule {}

class _$GithubAuthHttpClientModule extends _i1035.GithubAuthHttpClientModule {}

class _$RouteModule extends _i312.RouteModule {}
