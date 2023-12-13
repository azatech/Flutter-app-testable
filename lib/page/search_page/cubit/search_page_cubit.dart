import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_page_state.dart';

class SearchPageCubit extends Cubit<SearchPageState> {
  final TodoRepository todoRepository;

  SearchPageCubit({
    required this.todoRepository,
    TodoData? todo,
  }) : super(SearchPageInitial(query: ''));

  Future<void> search(String query) async {
    final todos = await todoRepository.getTodos(query: query);
    emit(
      SearchPageUpdatedState(
        todos: todos,
        query: state.query,
      ),
    );
  }
}
