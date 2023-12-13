part of 'home_page_cubit.dart';

sealed class HomePageState extends Equatable {
  final List<TodoData> todos;
  final FilterKind filter;

  const HomePageState({
    required this.todos,
    required this.filter,
  });

  bool get isFilteredByAll => filter == FilterKind.all;

  bool get isFilteredByCompleted => filter == FilterKind.completed;

  bool get isFilteredByIncomplete => filter == FilterKind.incomplete;
}

class HomePageInitial extends HomePageState {
  const HomePageInitial({
    super.todos = const <TodoData>[],
    super.filter = FilterKind.all,
  });

  @override
  List<Object?> get props => [todos, filter];
}

class HomePageUpdatedState extends HomePageState {
  const HomePageUpdatedState({
    required super.todos,
    required super.filter,
  });

  @override
  List<Object?> get props => [todos, filter];
}
