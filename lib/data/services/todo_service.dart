import 'dart:async';

import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:drift_app_testble/local/db/tables/todos_dao.dart';

class TodoService implements TodoRepository {
  final AppDB appDb;

  const TodoService({
    required this.appDb,
  });

  TodosDao get db => appDb.todosDao;

  @override
  FutureOr<void> delete(TodoData entity) async {
    await db.deleteTodo(entity);
  }

  @override
  FutureOr<void> deleteAllTodos() {
    db.deleteAllTodos();
  }

  @override
  FutureOr<void> deleteCompletedTodos() {
    db.deleteCompletedTodos();
  }

  @override
  Future<void> deleteTodo(TodoData entity) {
    return db.deleteTodo(entity);
  }

  @override
  Future<TodoData?> getTodo(int id) {
    return db.getTodo(id);
  }

  @override
  Future<List<TodoData>> getTodos({
    String? query,
  }) {
    return db.getTodos(query: query);
  }

  @override
  Future<List<TodoData>> getCompleteOrOnly({
    required bool isCompleted,
  }) {
    return db.getCompleteOrOnly(isCompleted: isCompleted);
  }

  @override
  FutureOr<void> save(TodoData entity) async {
    await db.saveTodo(entity.toCompanion(true));
  }

  @override
  Stream<List<TodoData>> watchTodos() {
    return db.watchTodos();
  }
}
