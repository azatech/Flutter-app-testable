import 'package:drift_app_testble/data/services/todo_service.dart';
import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:drift_app_testble/local/db/tables/todos_dao.dart';
import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/search_page/cubit/search_page_cubit.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> unregisterGetIt() async {
  getIt.reset();
}
Future<void> initGetIt() async {
  /// Singletons
  getIt.registerSingleton<AppDB>(AppDB());
  getIt.registerSingleton<TodosDao>(TodosDao(getIt()));
  getIt.registerSingleton<TodoRepository>(TodoService(appDb: getIt()));

  /// Factories
  getIt.registerFactory<HomePageCubit>(
    () => HomePageCubit(todoRepository: getIt()),
  );
  getIt.registerFactoryParam<TodoDetailsCubit, TodoRepository, TodoData?>(
    (_, todo) => TodoDetailsCubit(
      todoRepository: getIt(),
      todo: todo,
    ),
  );
  getIt.registerFactory<SearchPageCubit>(
    () => SearchPageCubit(
      todoRepository: getIt(),
    ),
  );
}
