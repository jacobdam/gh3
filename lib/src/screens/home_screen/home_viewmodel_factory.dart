import 'package:injectable/injectable.dart';
import 'home_viewmodel.dart';
import '../../services/ferry_client_service.dart';

@injectable
class HomeViewModelFactory {
  final FerryClientService _ferryClientService;

  HomeViewModelFactory(this._ferryClientService);

  HomeViewModel create() {
    return HomeViewModel(_ferryClientService.getClient());
  }
}
