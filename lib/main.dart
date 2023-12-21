import 'package:drift_app_testble/my_app_for_test.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // timeDilation = 5;
  await initGetIt();
  runApp(const MyAppForTest());
}
