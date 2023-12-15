import 'package:flutter_test/flutter_test.dart';

Future<void> waitSec(int seconds) => Future.delayed(Duration(seconds: seconds));

extension TesterExt on WidgetTester {
  Future<void> pumpAndWait({
    int pumpTimes = 60,
    int? waitSeconds,
    Duration? pumpDuration,
  }) async {
    for (var i = 0; i < pumpTimes; i++) {
      await pump(pumpDuration);
    }
    if (waitSeconds != null) {
      waitSec(waitSeconds);
    }
  }

  Future<void> pumpTimes(
    int times, [
    Duration? duration,
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
  ]) async {
    for (var i = 0; i < times; i++) {
      await pump(duration, phase);
    }
  }
}
