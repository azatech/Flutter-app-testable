// ignore_for_file: prefer_const_constructors

import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:drift_app_testble/page/details_page/todo_details_page.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/fake_home_page_for_performance_test/widget/fake_todo_card.dart';
import 'package:drift_app_testble/page/home/home_page.dart';
import 'package:drift_app_testble/page/home/widget/chips_bar_widget.dart';
import 'package:drift_app_testble/page/search_page/cubit/search_page_cubit.dart';
import 'package:drift_app_testble/page/search_page/search_page.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:drift_app_testble/utils/mixins/confirmable_dialog_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FakeHomePerformanceTestPage extends StatefulWidget {
  const FakeHomePerformanceTestPage({
    super.key,
  });

  @override
  State<FakeHomePerformanceTestPage> createState() =>
      _FakeHomePerformanceTestPageState();
}

class _FakeHomePerformanceTestPageState
    extends State<FakeHomePerformanceTestPage> with ConfirmableDialogMixin {
  @override
  void initState() {
    super.initState();
    context.read<HomePageCubit>().getTodos(FilterKind.all);
    context.read<HomePageCubit>().watchTodos();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        final todos = state.todos;
        return Scaffold(
          appBar: AppBar(
            title: const Text(titleAppName),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Delete Completed TODO',
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final deleteAll = await confirm(
                    context,
                    title: 'Warning',
                    content: 'Delete all completed TODO?',
                  );
                  if (deleteAll && mounted) {
                    context.read<HomePageCubit>().deleteCompletedTodos();
                    messenger.showSnackBar(const SnackBar(
                        content: Text('All completed TODO deleted')));
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search TODO',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => getIt<SearchPageCubit>(),
                        lazy: false,
                        child: const SearchTodosPage(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              ChipsBarWidget(),
              Divider(height: 2, color: theme.colorScheme.outlineVariant),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (todos.isEmpty) {
                      return const Center(child: Text(emptyListTitle));
                    }
                    return badPerformanceSlowList(context, todos);
                    // return WidgetList(todos: todos);
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => getIt<TodoDetailsCubit>(
                      param1: getIt<TodoRepository>(),
                    ),
                    lazy: false,
                    child: const TodoDetailsPage(),
                  ),
                ),
              );
            },
            tooltip: 'Add TODO',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

Widget badPerformanceSlowList(BuildContext context, List<TodoData> todos) {
  return ListView(
    key: Key(listViewHomePageKey),
    padding: const EdgeInsets.all(8),
    // itemCount: todos.length,
    shrinkWrap: true,
    children: [
      ...listWidgets(context, todos),
    ],
  );
}

List<Widget> listWidgets(BuildContext context, List<TodoData> todos) {
  final items = List.generate(
    todos.length,
    (index) {
      final todo = todos[index];
      return FakeTodoCard(
        key: Key(todoCardKey(index)),
        todo: todo,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => getIt<TodoDetailsCubit>(
                  param1: getIt<TodoRepository>(),
                  param2: todo,
                ),
                lazy: false,
                child: const TodoDetailsPage(),
              ),
            ),
          );
        },
        onCompleted: (value) {
          context.read<HomePageCubit>().updateTodo(
                entity: todo,
                completed: value,
              );
        },
      );
    },
  );
  return items;
}
