// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/clean_up_after_the_test.dart';
import './step/im_opening_app.dart';
import './step/the_app_is_running.dart';
import './step/i_see_text.dart';
import './step/im_opening_app_with_todos_in_db.dart';

void main() {
  group('''Home''', () {
    Future<void> bddTearDown(WidgetTester tester) async {
      await cleanUpAfterTheTest(tester);
    }
    testWidgets('''Home page is presented''', (tester) async {
      try {
        await imOpeningApp(tester);
        await theAppIsRunning(tester);
        await iSeeText(tester, 'No TODO found');
        await iSeeText(tester, 'TODO App');
      } finally {
        await bddTearDown(tester);
      }
    });
    testWidgets('''Home page is presented with todo 1 and todo 2''', (tester) async {
      try {
        await imOpeningAppWithTodosInDb(tester);
        await theAppIsRunning(tester);
        await iSeeText(tester, 'TODO App');
        await iSeeText(tester, 'title_1');
        await iSeeText(tester, 'title_2');
      } finally {
        await bddTearDown(tester);
      }
    });
  });
}
