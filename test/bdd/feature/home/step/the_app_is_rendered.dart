import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift_app_testble/my_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'im_opening_app_with_todos_in_db.dart';

/// Usage: The app is rendered
Future<void> theAppIsRendered(WidgetTester tester) async {
  /// This helps us to see app fonts in golden file
  // await loadAppFonts();

  /// Different scenarios of device builder
  final builder = DeviceBuilder()
    ..overrideDevicesForAllScenarios(
      devices: [
        Device.phone,
        Device.tabletPortrait,
        const Device(name: 'tablet_medium', size: Size(800, 1200)),
        const Device(name: 'phone_small', size: Size(425, 800)),
        const Device(name: 'phone_smalles', size: Size(255, 540)),
      ],
    )
    ..addScenario(widget: const MyApp());

  /// Init app
  await imOpeningAppWithTodosInDb(tester);
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  /// Pump
  return tester.pumpDeviceBuilder(builder);
}
