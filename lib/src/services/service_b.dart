import 'package:flutter/foundation.dart';
import 'package:gh3/src/services/service_a.dart';
import 'package:injectable/injectable.dart';

@injectable
class ServiceB {
  final ServiceA serviceA;

  ServiceB(this.serviceA);

  void hello() {
    debugPrint('ServiceB says hello!');
    serviceA.hello();
  }
}
