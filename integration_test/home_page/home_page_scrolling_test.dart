// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, prefer_const_constructors

import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/helpers/unit_todo_factory.dart';
import 'package:drift_app_testble/page/details_page/todo_details_page.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test/unit_test/home_page/cubit/home_page_cubit_test.dart';
import '../test_app_helper.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  group('Test scrolling behaviour', () {
    testWidgets('Test many todos in list', (tester) async {
      final visibleTodo = UnitTodoFactory.todo15;
      when(() => mockRepository.getTodos()).thenAnswer(
        (_) async => [...UnitTodoFactory.fullListTodos],
      );
      await tester.pumpWidget(homeWidget);
      homeCubit.getTodos(FilterKind.all);

      /// Wait till network or cache request has done
      await tester.pumpAndSettle(Duration(seconds: 1));

      /// take last because the tab bar up top is also a Scrollable
      final scrollableListFinder = find.byType(Scrollable).last;

      final cardFinder = find.byKey(Key(todoCardKey(15)));
      await binding.traceAction(
        () async {
          await tester.scrollUntilVisible(
            cardFinder,
            200.0,
            scrollable: scrollableListFinder,
            duration: Duration(seconds: 1),
          );
        },
        reportKey: 'scrolling_timeline',
      );

      await tester.tap(cardFinder);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(TodoDetailsPage), findsOneWidget);

      final todoTitle = visibleTodo.title;
      final todoDesc = visibleTodo.description ?? '';

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
