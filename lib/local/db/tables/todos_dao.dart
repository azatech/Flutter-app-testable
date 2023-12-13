// ignore_for_file: avoid_print

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:drift_app_testble/local/db/tables/todo.dart';

part 'todos_dao.g.dart';

@DriftAccessor(tables: [Todo])
class TodosDao extends DatabaseAccessor<AppDB> with _$TodosDaoMixin {
  TodosDao(AppDB db) : super(db);

  Future<List<TodoData>> _getTodos({
    String? query,
    bool? isCompleted,
  }) async {
    if (query != null) {
      final result = await (select(todo)
            ..where((tbl) =>
                tbl.title.contains(query) | tbl.description.contains(query)))
          .get();
      return result;
    }
    if (isCompleted != null) {
      return (select(todo)..where((tbl) => tbl.isCompleted.equals(isCompleted)))
          .get();
    }
    return (select(todo)
          ..orderBy(
            [
              (t) => OrderingTerm(
                    expression: t.isCompleted,
                    mode: OrderingMode.desc,
                  )
            ],
          ))
        .get();
  }

  Stream<List<TodoData>> watchTodos() => select(todo).watch();

  Future<List<TodoData>> getTodos({String? query}) => _getTodos(query: query);

  Future<List<TodoData>> getCompleteOrOnly({
    required bool isCompleted,
  }) =>
      _getTodos(isCompleted: isCompleted);

  Future<TodoData?> getTodo(int id) {
    return (select(todo)
          ..where(
            (tbl) => tbl.id.equals(id),
          ))
        .getSingleOrNull();
  }

  Future<void> deleteTodo(TodoData entity) => delete(todo).delete(entity);

  Future<TodoData?> saveTodo(TodoCompanion entity) async {
    final value = await getTodo(entity.id.value);
    if (value != null) {
      await transaction(
        () => update(todo).replace(entity),
      );
    } else {
      await transaction(
        () => into(todo).insert(entity),
      );
    }
    return await getTodo(entity.id.value);
  }

  Future<void> deleteCompletedTodos() {
    return transaction(() async {
      await (delete(todo)..where((tbl) => tbl.isCompleted.equals(true))).go();
    });
  }

  Future<void> deleteAllTodos() {
    return transaction(() {
      return delete(todo).go();
    });
  }
}
