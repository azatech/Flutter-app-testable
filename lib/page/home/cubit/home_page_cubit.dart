import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_page_state.dart';

enum FilterKind {
  all,
  completed,
  incomplete,
}

class HomePageCubit extends Cubit<HomePageState> {
  final TodoRepository todoRepository;

  HomePageCubit({
    required this.todoRepository,
    TodoData? todo,
  }) : super(const HomePageInitial());

  void watchTodos() {
    todoRepository.watchTodos().listen((todos) {
      emit(
        HomePageUpdatedState(
          todos: todos,
          filter: state.filter,
        ),
      );
    });
  }

  Future<void> updateTodo({
    required TodoData entity,
    required bool? completed,
  }) async {
    final result = entity.copyWith(
      isCompleted: Value(completed),
    );
    await todoRepository.save(result);
    getTodos(state.filter);
  }

  void updateFilter({
    required FilterKind filter,
  }) =>
      getTodos(filter);

  Future<void> getTodos(FilterKind filter) async {
    final todos = await _getTodosOr(filter: filter);
    emit(
      HomePageUpdatedState(
        todos: todos,
        filter: filter,
      ),
    );
  }

  Future<List<TodoData>> _getTodosOr({
    required FilterKind filter,
  }) async {
    switch (filter) {
      case FilterKind.all:
        return await todoRepository.getTodos();
      case FilterKind.completed:
        return await todoRepository.getCompleteOrOnly(isCompleted: true);
      case FilterKind.incomplete:
        return await todoRepository.getCompleteOrOnly(isCompleted: false);
    }
  }

  Future<void> deleteCompletedTodos() async {
    await todoRepository.deleteCompletedTodos();
    getTodos(state.filter);
  }
}
