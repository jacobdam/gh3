// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry/ferry.dart' as _i25;
import 'package:get_it/get_it.dart' as _i174;
import 'package:gh3/src/env/env.dart' as _i589;
import 'package:gh3/src/routing/route_collection_service.dart' as _i482;
import 'package:gh3/src/routing/route_provider.dart' as _i518;
import 'package:gh3/src/screens/app/auth_viewmodel.dart' as _i850;
import 'package:gh3/src/screens/home_screen/home_route_provider.dart' as _i176;
import 'package:gh3/src/screens/home_screen/home_viewmodel_factory.dart'
    as _i1013;
import 'package:gh3/src/screens/loading_screen/loading_route_provider.dart'
    as _i492;
import 'package:gh3/src/screens/login_screen/login_route_provider.dart'
    as _i468;
import 'package:gh3/src/screens/login_screen/login_viewmodel_factory.dart'
    as _i76;
import 'package:gh3/src/screens/user_details/user_details_route_provider.dart'
    as _i57;
import 'package:gh3/src/screens/user_details/user_details_viewmodel_factory.dart'
    as _i627;
import 'package:gh3/src/screens/user_organizations/user_organizations_route_provider.dart'
    as _i590;
import 'package:gh3/src/screens/user_repositories/user_repositories_route_provider.dart'
    as _i208;
import 'package:gh3/src/screens/user_repositories/user_repositories_viewmodel_factory.dart'
    as _i676;
import 'package:gh3/src/screens/user_starred/user_starred_route_provider.dart'
    as _i384;
import 'package:gh3/src/services/auth_service.dart' as _i336;
import 'package:gh3/src/services/ferry_module.dart' as _i762;
import 'package:gh3/src/services/github_auth_client.dart' as _i1035;
import 'package:gh3/src/services/scope_service.dart' as _i792;
import 'package:gh3/src/services/timer_service.dart' as _i1066;
import 'package:gh3/src/services/token_storage.dart' as _i895;
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
    final httpModule = _$HttpModule();
    final ferryModule = _$FerryModule();
    gh.factory<_i482.RouteCollectionService>(
      () => _i482.RouteCollectionService(),
    );
    gh.lazySingleton<_i589.Env>(() => envModule.env);
    gh.lazySingleton<_i519.Client>(() => httpModule.httpClient);
    gh.lazySingleton<_i1066.TimerService>(() => _i1066.DefaultTimerService());
    gh.lazySingleton<_i895.ITokenStorage>(() => _i895.PrefsTokenStorage());
    gh.singleton<_i518.RouteProvider>(
      () => _i384.UserStarredRouteProvider(),
      instanceName: 'UserStarredRouteProvider',
    );
    gh.factory<String>(
      () => envModule.githubClientId,
      instanceName: 'GithubClientID',
    );
    gh.singleton<_i518.RouteProvider>(
      () => _i590.UserOrganizationsRouteProvider(),
      instanceName: 'UserOrganizationsRouteProvider',
    );
    gh.factory<_i1035.GithubNonRecoverableException>(
      () => _i1035.GithubNonRecoverableException(gh<String>(), gh<String>()),
    );
    gh.lazySingleton<_i792.IScopeService>(
      () => _i792.ScopeService(gh<_i519.Client>()),
    );
    gh.factory<_i1035.GithubAuthClient>(
      () => _i1035.GithubAuthClient(
        gh<_i519.Client>(),
        gh<String>(instanceName: 'GithubClientID'),
      ),
    );
    gh.lazySingleton<_i336.AuthService>(
      () => _i336.AuthService(
        gh<_i1035.GithubAuthClient>(),
        gh<_i895.ITokenStorage>(),
        gh<_i792.IScopeService>(),
        gh<_i1066.TimerService>(),
      ),
    );
    gh.lazySingleton<_i25.Client>(
      () =>
          ferryModule.ferryClient(gh<_i336.AuthService>(), gh<_i519.Client>()),
    );
    gh.lazySingleton<_i850.AuthViewModel>(
      () => _i850.AuthViewModel(gh<_i336.AuthService>()),
    );
    gh.singleton<_i518.RouteProvider>(
      () => _i492.LoadingRouteProvider(gh<_i850.AuthViewModel>()),
      instanceName: 'LoadingRouteProvider',
    );
    gh.factory<_i627.UserDetailsViewModelFactory>(
      () => _i627.UserDetailsViewModelFactory(gh<_i25.Client>()),
    );
    gh.factory<_i676.UserRepositoriesViewModelFactory>(
      () => _i676.UserRepositoriesViewModelFactory(gh<_i25.Client>()),
    );
    gh.factory<_i1013.HomeViewModelFactory>(
      () => _i1013.HomeViewModelFactory(gh<_i25.Client>()),
    );
    gh.singleton<_i518.RouteProvider>(
      () => _i176.HomeRouteProvider(
        gh<_i1013.HomeViewModelFactory>(),
        gh<_i850.AuthViewModel>(),
      ),
      instanceName: 'HomeRouteProvider',
    );
    gh.factory<_i76.LoginViewModelFactory>(
      () => _i76.LoginViewModelFactory(
        gh<_i1035.GithubAuthClient>(),
        gh<_i336.AuthService>(),
        gh<_i850.AuthViewModel>(),
      ),
    );
    gh.singleton<_i518.RouteProvider>(
      () => _i57.UserDetailsRouteProvider(
        gh<_i627.UserDetailsViewModelFactory>(),
      ),
      instanceName: 'UserDetailsRouteProvider',
    );
    gh.factory<_i518.RouteProvider>(
      () => _i208.UserRepositoriesRouteProvider(
        gh<_i676.UserRepositoriesViewModelFactory>(),
      ),
      instanceName: 'UserRepositoriesRouteProvider',
    );
    gh.singleton<_i518.RouteProvider>(
      () => _i468.LoginRouteProvider(gh<_i76.LoginViewModelFactory>()),
      instanceName: 'LoginRouteProvider',
    );
    return this;
  }
}

class _$EnvModule extends _i589.EnvModule {}

class _$HttpModule extends _i1035.HttpModule {}

class _$FerryModule extends _i762.FerryModule {}
