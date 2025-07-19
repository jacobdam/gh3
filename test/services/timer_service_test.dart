import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/services/timer_service.dart';

void main() {
  group('DefaultTimerService', () {
    late DefaultTimerService timerService;

    setUp(() {
      timerService = DefaultTimerService();
    });

    test('should delay for specified duration', () async {
      final stopwatch = Stopwatch()..start();

      await timerService.delay(const Duration(milliseconds: 100));

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(100));
    });

    test('should complete immediately for zero duration', () async {
      final stopwatch = Stopwatch()..start();

      await timerService.delay(Duration.zero);

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(10));
    });
  });
}
