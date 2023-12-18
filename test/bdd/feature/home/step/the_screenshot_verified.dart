import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Usage: The {Home} screenshot verified
Future<void> theScreenshotVerified(
    WidgetTester tester, String scenarioName) async {
  await screenMatchesGolden(tester, scenarioName);
}
