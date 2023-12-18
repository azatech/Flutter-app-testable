import 'package:flutter_test/flutter_test.dart';

import '../../../../../integration_test/test_app_helper.dart';

/// Usage: clean up after the test
Future<void> cleanUpAfterTheTest(WidgetTester tester) async {
  TestAppHelper.reset();
}
