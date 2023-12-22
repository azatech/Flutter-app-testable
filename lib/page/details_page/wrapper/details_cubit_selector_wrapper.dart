import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsCubitSelectorWrapper<T> extends StatelessWidget {
  final T Function(TodoDetailsState) selector;
  final Widget Function(T value) builder;

  const DetailsCubitSelectorWrapper({
    super.key,
    required this.selector,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TodoDetailsCubit, TodoDetailsState, T>(
      selector: selector,
      builder: (context, value) {
        return builder(value);
      },
    );
  }
}
