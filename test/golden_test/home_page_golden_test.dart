// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, prefer_const_constructors

import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/helpers/unit_todo_factory.dart';
import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/home_page.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final _todo1 = UnitTodoFactory.todo1;
final _todo2 = UnitTodoFactory.todo2;
final _todo3 = UnitTodoFactory.todo3;

class MockTodoRepo extends Mock implements TodoRepository {}

Widget wrapMaterialWidget(Widget child) => MaterialApp(home: child);

void main() {
  late Widget homeBaseWidget;
  late HomePageCubit homePageCubit;
  late TodoDetailsCubit todoDetailsPageCubit;
  late TodoRepository mockTodoRepo;

  setUp(() async {
    /// get it base init
    mockTodoRepo = MockTodoRepo();
    getIt.registerLazySingleton<TodoRepository>(() => mockTodoRepo);
    homePageCubit = HomePageCubit(todoRepository: getIt());
    todoDetailsPageCubit = TodoDetailsCubit(
      todoRepository: getIt(),
      todo: _todo1,
    );
    getIt.registerFactory<HomePageCubit>(() => homePageCubit);
    getIt.registerFactory<TodoDetailsCubit>(() => todoDetailsPageCubit);

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

  group('Golden test home page check UI', () {
    testWidgets(
      'CHECK ME by tag exception',
      (tester) async {
        await tester.pumpWidget(homeBaseWidget);
        expect(true, false);
      },
      tags: 'no-ci',
    );
  });
}
