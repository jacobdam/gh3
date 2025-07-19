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
import 'package:gh3/src/services/auth_service.dart' as _i336;
import 'package:gh3/src/services/github_api_service.dart' as _i143;
import 'package:gh3/src/services/github_auth_client.dart' as _i1035;
import 'package:gh3/src/services/scope_service.dart' as _i792;
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
    final githubAuthHttpClientModule = _$GithubAuthHttpClientModule();
    gh.lazySingleton<_i589.Env>(() => envModule.env);
    gh.lazySingleton<_i519.Client>(() => githubAuthHttpClientModule.httpClient);
    gh.lazySingleton<_i895.ITokenStorage>(() => _i895.PrefsTokenStorage());
    gh.factory<String>(
      () => envModule.githubClientId,
      instanceName: 'GithubClientID',
    );
    gh.factory<_i143.GitHubApiService>(
      () =>
          _i143.GitHubApiService(gh<_i519.Client>(), gh<_i895.ITokenStorage>()),
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
      ),
    );
    return this;
  }
}

class _$EnvModule extends _i589.EnvModule {}

class _$GithubAuthHttpClientModule extends _i1035.GithubAuthHttpClientModule {}
