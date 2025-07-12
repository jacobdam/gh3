import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
class ServiceA {
  void hello() {
    debugPrint('ServiceA says hello!');
  }
}
