import 'package:envied/envied.dart';
import 'package:injectable/injectable.dart';
part 'env.g.dart';

@Envied(path: '.env')
class Env {
  @EnviedField(varName: 'GITHUB_CLIENT_ID')
  String githubClientId = _Env.githubClientId;
}

@module
abstract class EnvModule {
  @lazySingleton
  Env get env => Env();

  @Named('GithubClientID')
  String get githubClientId => env.githubClientId;
}
