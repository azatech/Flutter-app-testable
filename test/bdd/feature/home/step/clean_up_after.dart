import 'package:flutter_test/flutter_test.dart';

import '../../../../../integration_test/test_app_helper.dart';

/// Usage: clean up after
Future<void> cleanUpAfter(WidgetTester tester) async {
  TestAppHelper.reset();
}
