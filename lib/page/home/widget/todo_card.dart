import 'package:drift_app_testble/local/db/app_db.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final TodoData todo;
  final Function() onTap;
  final Function(bool?)? onCompleted;

  const TodoCard({
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
        title: Text(todo.title),
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
}

extension on String? {
  bool get isEmpty => this == null || this!.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
