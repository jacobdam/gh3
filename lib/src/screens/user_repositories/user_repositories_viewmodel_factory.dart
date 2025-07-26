import 'package:ferry/ferry.dart';
import 'package:injectable/injectable.dart';
import 'user_repositories_viewmodel.dart';

@injectable
class UserRepositoriesViewModelFactory {
  final Client _ferryClient;

  UserRepositoriesViewModelFactory(this._ferryClient);

  UserRepositoriesViewModel create(String userLogin) {
    return UserRepositoriesViewModel(_ferryClient, userLogin);
  }
}
