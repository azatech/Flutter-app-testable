import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/helpers/unit_todo_factory.dart';
import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/home_page.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/material_wrapper.dart';
import 'mocks/mock_todo_repository.dart';

abstract class TestAppHelper {
  static (
    Widget,
    HomePageCubit,
    TodoDetailsCubit,
    TodoRepository,
  ) setUpHomeMain() {
    late Widget homeWidget;
    late HomePageCubit homeCubit;
    late TodoDetailsCubit detailsCubit;
    late TodoRepository mockRepository;

    /// get it base init
    mockRepository = MockTodoRepo();
    getIt.registerLazySingleton<TodoRepository>(() => mockRepository);
    homeCubit = HomePageCubit(todoRepository: getIt());
    detailsCubit = TodoDetailsCubit(
      todoRepository: getIt(),
      todo: UnitTodoFactory.todo1,
    );
    getIt.registerFactory<HomePageCubit>(() => homeCubit);
    getIt.registerFactory<TodoDetailsCubit>(() => detailsCubit);

    when(() => mockRepository.getTodos()).thenAnswer((_) async => []);
    when(() => mockRepository.watchTodos()).thenAnswer(
      (_) => Stream.fromIterable([]),
    );

    homeWidget = MaterialWrapper(
      BlocProvider(
        create: (context) => homeCubit,
        lazy: false,
        child: const HomePage(),
      ),
    );

    return (
      homeWidget,
      homeCubit,
      detailsCubit,
      mockRepository,
    );
  }

  static void reset() {
    getIt.reset();
  }
}
