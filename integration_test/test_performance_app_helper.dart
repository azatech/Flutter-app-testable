import 'dart:math';

import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/fake_home_page_for_performance_test/fake_home_performance_test_page.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/material_wrapper.dart';
import 'mocks/mock_todo_repository.dart';

abstract class TestPerformanceAppHelper {
  static (
    Widget,
    HomePageCubit,
    TodoDetailsCubit,
    TodoRepository,
    TodoData randomItem,
  ) setUpHomeWithItems(int itemsCount) {
    late Widget homeWidget;
    late HomePageCubit homeCubit;
    late TodoDetailsCubit detailsCubit;
    late TodoRepository mockRepository;
    late TodoData randomItem;

    /// Generate fake items
    List<TodoData> items = List.generate(
      itemsCount,
      (index) => TodoData(
        id: Random().nextInt(itemsCount + itemsCount),
        title: 'title_$index',
      ),
    );
    randomItem =
        items[max(Random().nextInt(items.length), itemsCount * 0.9).toInt()];

    /// get it base init
    mockRepository = MockTodoRepo();
    getIt.registerLazySingleton<TodoRepository>(() => mockRepository);
    homeCubit = HomePageCubit(todoRepository: getIt());
    detailsCubit = TodoDetailsCubit(
      todoRepository: getIt(),
      todo: randomItem,
    );
    getIt.registerFactory<HomePageCubit>(() => homeCubit);
    getIt.registerFactory<TodoDetailsCubit>(() => detailsCubit);

    when(() => mockRepository.getTodos()).thenAnswer((_) async => items);
    when(() => mockRepository.watchTodos()).thenAnswer(
      (_) => Stream.fromIterable([items]),
    );

    homeWidget = MaterialWrapper(
      BlocProvider(
        create: (context) => homeCubit,
        lazy: false,
        child: const FakeHomePerformanceTestPage(),
      ),
    );

    return (
      homeWidget,
      homeCubit,
      detailsCubit,
      mockRepository,
      randomItem,
    );
  }

  static void reset() {
    getIt.reset();
  }
}
