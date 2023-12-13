import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_app_testble/helpers/unit_todo_factory.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:drift_app_testble/local/db/tables/todos_dao.dart';
import 'package:flutter_test/flutter_test.dart';

final _todo1 = UnitTodoFactory.todo1;
final _todo2 = UnitTodoFactory.todo2;
final _todo3 = UnitTodoFactory.todo3;

void main() {
  group(
    'Testing database CRUD - operations',
    () {
      late AppDB database;
      late TodosDao dao;

      setUp(() {
        database = AppDB.forTesting(NativeDatabase.memory());
        dao = TodosDao(database);
      });

      tearDown(() async {
        await database.close();
      });

      test('Test first item can be created', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        final actualTodo = await dao.watchTodos().first;

        /// First element in stream
        expect(actualTodo, [_todo1]);
      });

      test('Test creation of 2 items & stream watch', () async {
        final todosStream = dao.watchTodos();
        final expectation = expectLater(
          todosStream,
          emitsAnyOf([
            mayEmit([]),
            [_todo1],
            [_todo1, _todo2],
          ]),
        );

        await dao.saveTodo(_todo1.toCompanion(true));
        await dao.saveTodo(_todo2.toCompanion(true));

        /// Stream emits 2 elements
        await expectation;
      });

      test('Test creation of 2 items ', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        await dao.saveTodo(_todo2.toCompanion(true));
        final actual1 = await dao.getTodo(_todo1.id);
        final actual2 = await dao.getTodo(_todo2.id);
        expect(actual1, _todo1);
        expect(actual2, _todo2);
      });

      test('Test update todo item', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        final actual1 = await dao.getTodo(_todo1.id);
        expect(actual1, _todo1);

        /// Change title
        final editedNew = await dao.saveTodo(_todo1
            .copyWith(
              title: 'title_new',
            )
            .toCompanion(true));
        final actualNew = await dao.getTodo(_todo1.id);
        expect(actualNew, editedNew);
        expect(actualNew?.title, 'title_new');
      });

      test('Test get completed todos only', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        final completedTodo = _todo2.copyWith(isCompleted: const Value(true));
        await dao.saveTodo(completedTodo.toCompanion(true));
        await dao.saveTodo(_todo3.toCompanion(true));

        /// 3 items saved = 1 completed + 2 not completed

        /// get completed 1 item only
        final completed = await dao.getCompleteOrOnly(isCompleted: true);
        expect(completed.first, completedTodo);
        expect(completedTodo.isCompleted, true);
        expect(completed.length, 1);
      });

      test('Test get inCompleted todos only', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        final inCompletedTodo =
            _todo2.copyWith(isCompleted: const Value(false));
        await dao.saveTodo(inCompletedTodo.toCompanion(true));
        await dao.saveTodo(_todo3.toCompanion(true));

        /// 3 items saved = 1 inCompleted + 2 completed

        /// get inCompleted 1 item only
        final inCompleted = await dao.getCompleteOrOnly(isCompleted: false);
        expect(inCompleted.first, inCompletedTodo);
        expect(inCompletedTodo.isCompleted, false);
        expect(inCompleted.length, 1);
      });

      test('Test get todos', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        await dao.saveTodo(_todo2.toCompanion(true));
        await dao.saveTodo(_todo3.toCompanion(true));

        final todos = await dao.getTodos();
        expect(todos, hasLength(3));
        expect(todos.toSet(), {_todo1, _todo2, _todo3});
        expect(todos, contains(_todo1));
        expect(todos, contains(_todo2));
        expect(todos, contains(_todo3));
      });

      test('Test get todos with query', () async {
        final expected1 = _todo1.copyWith(title: 'test_1');
        final expected3 = _todo3.copyWith(title: 'test_3');
        await dao.saveTodo(expected1.toCompanion(true));
        await dao.saveTodo(_todo2.toCompanion(true));
        await dao.saveTodo(expected3.toCompanion(true));

        final todos = await dao.getTodos(query: 'test');

        /// 3 actual todos - with query expected = 2
        expect(todos, hasLength(2));
        expect(todos.toSet(), {expected1, expected3});
        expect(todos.map((e) => e.title), contains('test_1'));
        expect(todos.map((e) => e.title), contains('test_3'));
        expect(todos, containsAll([expected1, expected3]));
      });

      test('Test delete todo', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        List<TodoData> todos;

        /// get 1 todo item
        todos = await dao.getTodos();
        expect(todos, hasLength(1));

        /// delete todo item
        await dao.deleteTodo(_todo1);
        todos = await dao.getTodos();
        expect(todos, hasLength(0));
      });

      test('Test delete some todo items', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        await dao.saveTodo(_todo2.toCompanion(true));
        await dao.saveTodo(_todo3.toCompanion(true));
        List<TodoData> todos;

        /// get 3 todos
        todos = await dao.getTodos();
        expect(todos, hasLength(3));
        expect(todos, containsAll([_todo1, _todo2, _todo3]));

        /// delete 2 todos
        await dao.deleteTodo(_todo1);
        await dao.deleteTodo(_todo2);

        /// get 1 todo
        todos = await dao.getTodos();
        expect(todos, hasLength(1));
        expect(todos, contains(_todo3));

        /// Delete last todo
        await dao.deleteTodo(_todo3);
        todos = await dao.getTodos();
        expect(todos, hasLength(0));
        expect(todos, containsAll([]));
      });

      test('Test delete all todo items', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        await dao.saveTodo(_todo2.toCompanion(true));
        await dao.saveTodo(_todo3.toCompanion(true));
        List<TodoData> todos;

        /// get 3 todos
        todos = await dao.getTodos();
        expect(todos, hasLength(3));

        /// delete all todos
        await dao.deleteAllTodos();
        todos = await dao.getTodos();
        expect(todos, hasLength(0));
        expect(todos, hasLength(0));
        expect(todos, containsAll([]));
      });

      test('Test delete all completed items', () async {
        await dao.saveTodo(
            _todo1.copyWith(isCompleted: const Value(true)).toCompanion(true));
        await dao.saveTodo(
            _todo2.copyWith(isCompleted: const Value(true)).toCompanion(true));
        await dao.saveTodo(_todo3.toCompanion(true));
        List<TodoData> todos;

        /// get 3 todos
        todos = await dao.getTodos();
        expect(todos, hasLength(3));

        /// delete all todos
        await dao.deleteCompletedTodos();
        todos = await dao.getTodos();
        expect(todos, hasLength(1));
        expect(todos, contains(_todo3));
      });

      test('Test error on get todo item', () async {
        await dao.saveTodo(_todo1.toCompanion(true));
        final result = await dao.getTodo(-1);
        expect(result, null);
      });
    },
  );
}
