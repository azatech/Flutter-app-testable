import 'dart:async';

import 'package:drift_app_testble/local/db/app_db.dart';

abstract class TodoRepository {
  FutureOr<List<TodoData>> getTodos({
    String? query,
  });

  FutureOr<List<TodoData>> getCompleteOrOnly({
    required bool isCompleted,
  });

  FutureOr<TodoData?> getTodo(int id);

  Stream<List<TodoData>> watchTodos();

  FutureOr<void> deleteTodo(TodoData entity);

  FutureOr<void> delete(TodoData entity);

  FutureOr<void> deleteAllTodos();

  FutureOr<void> deleteCompletedTodos();

  FutureOr<void> save(TodoData entity);
}
