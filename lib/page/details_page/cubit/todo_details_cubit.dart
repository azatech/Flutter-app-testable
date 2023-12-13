import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_details_state.dart';

class TodoDetailsCubit extends Cubit<TodoDetailsState> {
  final TodoRepository todoRepository;

  TodoDetailsCubit({
    required this.todoRepository,
    TodoData? todo,
  }) : super(
          TodoDetailsInitial(
            todo: todo ??
                TodoData(
                  id: Random().nextInt(100),
                  title: '',
                ),
            isNew: todo == null,
          ),
        );

  Future<void> updateTodo({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) async {
    emit(
      TodoDetailsUpdatedState(
        todo: state.todo.copyWith(
          title: title,
          description: Value(description ?? state.todo.description),
          dueDate: Value(dueDate ?? state.todo.dueDate),
          isCompleted: Value(isCompleted ?? state.todo.isCompleted),
        ),
        modified: true,
      ),
    );
  }

  Future<void> save() async {
    final todo = state.todo;
    await todoRepository.save(todo);
    emit(
      TodoDetailsSavedState(
        todo: todo,
      ),
    );
  }

  Future<void> delete() async {
    /// Delete from cache
    await todoRepository.delete(state.todo);
    emit(
      TodoDetailsDeletedState(
        todo: state.todo,
        modified: true,
      ),
    );
  }
}
