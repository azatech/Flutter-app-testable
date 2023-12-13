import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:drift_app_testble/page/details_page/todo_details_page.dart';
import 'package:drift_app_testble/page/home/widget/todo_card.dart';
import 'package:drift_app_testble/page/search_page/cubit/search_page_cubit.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTodosPage extends StatelessWidget {
  const SearchTodosPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchPageCubit, SearchPageState>(
      builder: (context, state) {
        final todos = state.todos;
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search TODO',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  context.read<SearchPageCubit>().search(value);
                }
              },
            ),
          ),
          body: (todos.isEmpty)
              ? const Center(
                  child: Text('No TODO found'),
                )
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return TodoCard(
                      todo: todo,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => getIt<TodoDetailsCubit>(
                                param1: todo,
                              ),
                              child: const TodoDetailsPage(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
