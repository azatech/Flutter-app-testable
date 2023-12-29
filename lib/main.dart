import 'package:drift_app_testble/my_app.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // timeDilation = 5;
  await initGetIt();
  runApp(const MyApp());
  // runApp(const MyAppForTest());
}
