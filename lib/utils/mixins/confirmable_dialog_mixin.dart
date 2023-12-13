import 'package:flutter/material.dart';

mixin ConfirmableDialogMixin<T extends StatefulWidget> on State<T> {
  Future<bool> confirm(
    BuildContext context, {
    String title = 'Confirm',
    String? content,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
