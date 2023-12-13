part of 'search_page_cubit.dart';

sealed class SearchPageState {
  final List<TodoData> todos;
  final String query;

  const SearchPageState({
    required this.todos,
    required this.query,
  });
}

class SearchPageInitial extends SearchPageState {
  SearchPageInitial({
    super.todos = const <TodoData>[],
    required super.query,
  });
}

class SearchPageUpdatedState extends SearchPageState {
  SearchPageUpdatedState({
    required super.todos,
    required super.query,
  });
}
