// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:flutter/material.dart';

class FakeTodoCard extends StatelessWidget {
  final TodoData todo;
  final Function() onTap;
  final Function(bool?)? onCompleted;

  const FakeTodoCard({
    super.key,
    required this.todo,
    required this.onTap,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surfaceVariant,
      child: ListTile(
        onTap: onTap,
        isThreeLine: todo.description.isNotEmpty,
        title: getTitle(),
        subtitle: Text(todo.description ?? ''),
        trailing: onCompleted != null
            ? Checkbox(
                value: todo.isCompleted ?? false,
                onChanged: (val) => onCompleted?.call(val),
              )
            : null,
      ),
    );
  }

  static int _fibonacci(int n) {
    if (n <= 1) return n;
    return _fibonacci(n - 1) + _fibonacci(n - 2);
  }

  Widget getTitle() {
    /// Performance timeline check!
    Timeline.startSync("Looooooong method call!!");
    final ind =
        int.tryParse(todo.title.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 15;
    if (ind % 50 == 0) {
      print(ind);
      print(_fibonacci(44));
    }
    Timeline.finishSync();
    return Text(todo.title);
  }
}

extension on String? {
  bool get isEmpty => this == null || this!.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
