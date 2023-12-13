part of 'todo_details_cubit.dart';

sealed class TodoDetailsState {
  final TodoData todo;
  final bool modified;
  final bool isNew;

  const TodoDetailsState({
    required this.todo,
    this.modified = false,
    this.isNew = true,
  });
}

class TodoDetailsInitial extends TodoDetailsState {
  TodoDetailsInitial({
    required super.todo,
    super.modified,
    super.isNew,
  });
}

class TodoDetailsUpdatedState extends TodoDetailsState {
  TodoDetailsUpdatedState({
    required super.todo,
    super.modified,
    super.isNew,
  });
}

class TodoDetailsSavedState extends TodoDetailsState {
  TodoDetailsSavedState({
    required super.todo,
    super.modified,
    super.isNew,
  });
}

class TodoDetailsDeletedState extends TodoDetailsState {
  TodoDetailsDeletedState({
    required super.todo,
    super.modified,
    super.isNew,
  });
}
