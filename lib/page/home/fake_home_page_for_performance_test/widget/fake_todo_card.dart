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
    for (var i = 0; i < 30; i++) {
      // print(_fibonacci(i));
    }
    return Text(todo.title);
  }
}

extension on String? {
  bool get isEmpty => this == null || this!.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
