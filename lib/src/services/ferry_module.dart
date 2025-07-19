import 'package:ferry/ferry.dart';
import 'package:injectable/injectable.dart';
import 'ferry_client_service.dart';

@module
abstract class FerryModule {
  @lazySingleton
  Future<Client> ferryClient(FerryClientService ferryClientService) async {
    return await ferryClientService.getClient();
  }
}
