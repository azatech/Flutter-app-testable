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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

final _todo2 = UnitTodoFactory.todo2.copyWith(isCompleted: Value(true));
final _todo3 = UnitTodoFactory.todo3.copyWith(isCompleted: Value(false));

class MockTodoRepo extends Mock implements TodoRepository {}

Widget wrapMaterialWidget(Widget child) => MaterialApp(home: child);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget homeBaseWidget;
  late HomePageCubit homePageCubit;
  late TodoDetailsCubit todoDetailsPageCubit;
  late TodoRepository mockTodoRepo;

  setUp(() async {
    /// get it base init
    mockTodoRepo = MockTodoRepo();
    getIt.registerLazySingleton<TodoRepository>(() => mockTodoRepo);
    homePageCubit = HomePageCubit(todoRepository: getIt());

    getIt.registerFactory<HomePageCubit>(() => homePageCubit);

    when(() => mockTodoRepo.getTodos()).thenAnswer((_) async => []);
    when(() => mockTodoRepo.watchTodos()).thenAnswer(
      (_) => Stream.fromIterable([]),
    );

    homeBaseWidget = wrapMaterialWidget(
      BlocProvider(
        create: (context) => homePageCubit,
        lazy: false,
        child: const HomePage(),
      ),
    );
  });

  tearDown(() async {
    /// destroy get it
    getIt.reset();
  });

  group('test isCompleted value in todo', () {
    testWidgets('is completed true', (tester) async {
      final currentTodo = _todo2;
      todoDetailsPageCubit = TodoDetailsCubit(
        todoRepository: getIt(),
        todo: currentTodo,
      );

      getIt.registerFactory<TodoDetailsCubit>(() => todoDetailsPageCubit);

      when(() => mockTodoRepo.getTodos())
          .thenAnswer((_) async => [...UnitTodoFactory.fullListTodos]);
      when(() => mockTodoRepo.getCompleteOrOnly(isCompleted: true)).thenAnswer(
        (_) => List.from([currentTodo]),
      );
      await tester.pumpWidget(homeBaseWidget);
      homePageCubit.getTodos(FilterKind.completed);
      await tester.pumpAndSettle();

      expect(homePageCubit.state.todos.length, 1);

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
      todoDetailsPageCubit = TodoDetailsCubit(
        todoRepository: getIt(),
        todo: currentTodo,
      );

      getIt.registerFactory<TodoDetailsCubit>(() => todoDetailsPageCubit);

      when(() => mockTodoRepo.getTodos())
          .thenAnswer((_) async => [...UnitTodoFactory.fullListTodos]);
      when(() => mockTodoRepo.getCompleteOrOnly(isCompleted: false)).thenAnswer(
            (_) => List.from([currentTodo]),
      );
      await tester.pumpWidget(homeBaseWidget);
      homePageCubit.getTodos(FilterKind.incomplete);
      await tester.pumpAndSettle();

      expect(homePageCubit.state.todos.length, 1);

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
