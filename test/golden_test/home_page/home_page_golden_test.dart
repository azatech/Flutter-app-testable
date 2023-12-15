// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, prefer_const_constructors

import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../integration_test/helpers/font_wrapper_golden_helper.dart';
import '../../../integration_test/helpers/material_wrapper.dart';
import '../../../integration_test/test_app_helper.dart';

void main() {
  late Widget homeWidget;
  late HomePageCubit homeCubit;
  late TodoRepository mockRepository;

  setUp(() async {
    final (homeW, homeC, _, mockR) = TestAppHelper.setUpHomeMain();
    homeWidget = homeW;
    homeCubit = homeC;
    mockRepository = mockR;
  });

  tearDown(() async {
    TestAppHelper.reset();
  });

  testWidgets(
    'Golden test simple my App test',
    (tester) async {
      testExecutable(() async {
        await tester.pumpWidget(
          MaterialWrapper(homeWidget),
        );

        await expectLater(
          find.byType(HomePage),
          matchesGoldenFile('home_page_test_app.png'),
        );
      });
    },
  );
}
