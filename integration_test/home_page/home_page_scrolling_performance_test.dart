// ignore_for_file: prefer_const_constructors

import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:drift_app_testble/page/details_page/todo_details_page.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test_app_helper.dart';
import '../test_performance_app_helper.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget homeWidget;
  late HomePageCubit homeCubit;
  late TodoRepository mockRepository;
  late TodoData randomItem;

  setUp(() async {
    final (homeW, homeC, _, mockR, randomI) =
        TestPerformanceAppHelper.setUpHomeWithItems(
      1500,
    );
    homeWidget = homeW;
    homeCubit = homeC;
    mockRepository = mockR;
    randomItem = randomI;
  });

  tearDown(() async {
    TestAppHelper.reset();
  });

  group('Test integration performance scrolling behaviour', () {
    testWidgets('Test many todos in list', (tester) async {
      // tester.binding.window.physicalSizeTestValue = Size(1430, 1932);
      tester.binding.window.devicePixelRatioTestValue = 2.5;

      await tester.pumpWidget(homeWidget);
      homeCubit.getTodos(FilterKind.all);

      /// Wait till network or cache request has done
      await tester.pumpAndSettle(Duration(seconds: 1));

      /// take last because the tab bar up top is also a Scrollable
      final scrollableListFinder = find.byType(Scrollable).last;

      /// Find index in random num -> item
      int r =
          int.tryParse(randomItem.title.replaceAll(RegExp(r'[^0-9.]'), '')) ??
              15;

      print('Random num is: ------> $r');

      final cardFinder = find.byKey(Key(todoCardKey(r)));
      await binding.traceAction(
        () async {
          await tester.scrollUntilVisible(
            cardFinder,
            250.0,
            scrollable: scrollableListFinder,
            maxScrolls: 1000,
            duration: Duration(milliseconds: 5),
          );
        },
        reportKey: 'scrolling_timeline',
      );

      await tester.tap(cardFinder);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(TodoDetailsPage), findsOneWidget);

      final todoTitle = randomItem.title;
      final todoDesc = randomItem.description ?? '';

      final titleForm = find.byKey(const Key('title_details_form'));
      final descForm = find.byKey(const Key('description_details_form'));
      final title = (tester.element(titleForm).widget as TextFormField)
              .controller
              ?.value
              .text ??
          '';
      expect(title, todoTitle);

      final desc = (tester.element(descForm).widget as TextFormField)
              .controller
              ?.value
              .text ??
          '';
      expect(desc, todoDesc);
      expect(titleForm, findsOneWidget);
      expect(descForm, findsOneWidget);
    });
  });
}
