// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, prefer_const_constructors

import 'package:drift/drift.dart';
import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/helpers/unit_todo_factory.dart';
import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:drift_app_testble/page/details_page/todo_details_page.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/home_page.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test_app_helper.dart';

final _todo2 = UnitTodoFactory.todo2.copyWith(isCompleted: Value(true));
final _todo3 = UnitTodoFactory.todo3.copyWith(isCompleted: Value(false));

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget homeWidget;
  late HomePageCubit homeCubit;
  late TodoDetailsCubit detailsCubit;
  late TodoRepository mockRepository;

  setUp(() async {
    final (homeW, homeC, detailsC, mockR) = TestAppHelper.setUpHomeMain();
    homeWidget = homeW;
    homeCubit = homeC;
    detailsCubit = detailsC;
    mockRepository = mockR;
  });

  tearDown(() async {
    TestAppHelper.reset();
  });

  group('test isCompleted value in todo', () {
    testWidgets('is completed true', (tester) async {
      final currentTodo = _todo2;
      detailsCubit = TodoDetailsCubit(
        todoRepository: getIt(),
        todo: currentTodo,
      );

      if (getIt.isRegistered<TodoDetailsCubit>()) {
        getIt.unregister<TodoDetailsCubit>();
        getIt.registerFactory<TodoDetailsCubit>(() => detailsCubit);
      }

      when(() => mockRepository.getTodos())
          .thenAnswer((_) async => [...UnitTodoFactory.fullListTodos]);
      when(() => mockRepository.getCompleteOrOnly(isCompleted: true))
          .thenAnswer(
        (_) => List.from([currentTodo]),
      );
      await tester.pumpWidget(homeWidget);
      homeCubit.getTodos(FilterKind.completed);
      await tester.pumpAndSettle();

      expect(homeCubit.state.todos.length, 1);

      final todoFinder = find.text(currentTodo.title);
      await tester.tap(todoFinder);
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(TodoDetailsPage), findsOneWidget);

      await tester.pump();

      final todoTitle = currentTodo.title;
      final todoDesc = currentTodo.description ?? '';

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

    testWidgets('is completed false', (tester) async {
      final currentTodo = _todo3;
      detailsCubit = TodoDetailsCubit(
        todoRepository: getIt(),
        todo: currentTodo,
      );

      if (getIt.isRegistered<TodoDetailsCubit>()) {
        getIt.unregister<TodoDetailsCubit>();
        getIt.registerFactory<TodoDetailsCubit>(() => detailsCubit);
      }

      when(() => mockRepository.getTodos())
          .thenAnswer((_) async => [...UnitTodoFactory.fullListTodos]);
      when(() => mockRepository.getCompleteOrOnly(isCompleted: false))
          .thenAnswer(
        (_) => List.from([currentTodo]),
      );
      await tester.pumpWidget(homeWidget);
      homeCubit.getTodos(FilterKind.incomplete);
      await tester.pumpAndSettle();

      expect(homeCubit.state.todos.length, 1);

      final todoFinder = find.text(currentTodo.title);
      await tester.tap(todoFinder);
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(TodoDetailsPage), findsOneWidget);

      await tester.pump();

      final todoTitle = currentTodo.title;
      final todoDesc = currentTodo.description ?? '';

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
