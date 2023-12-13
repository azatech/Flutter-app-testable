// ignore_for_file: prefer_const_constructors

import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:drift_app_testble/page/details_page/widget/article_widget.dart';
import 'package:drift_app_testble/page/details_page/widget/forms.dart';
import 'package:drift_app_testble/page/details_page/widget/save_button.dart';
import 'package:drift_app_testble/utils/constants.dart';
import 'package:drift_app_testble/utils/date.dart';
import 'package:drift_app_testble/utils/mixins/confirmable_dialog_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoDetailsPage extends StatefulWidget {
  const TodoDetailsPage({
    super.key,
  });

  @override
  State<TodoDetailsPage> createState() => _TodoDetailsPageState();
}

class _TodoDetailsPageState extends State<TodoDetailsPage>
    with ConfirmableDialogMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoDetailsCubit, TodoDetailsState>(
      listener: (context, state) {
        if (state is TodoDetailsSavedState ||
            state is TodoDetailsDeletedState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final todo = state.todo;
        final isNew = state.isNew;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              isNew ? 'Add TODO' : 'Edit TODO',
            ),
            actions: [
              if (!isNew) ...[
                IconButton(
                  tooltip: 'Delete Todo',
                  onPressed: () async {
                    final bool result = await showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          content: const Text('Delete TODO?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('DELETE'),
                            ),
                          ],
                        );
                      },
                    );
                    if (result && mounted) {
                      context.read<TodoDetailsCubit>().delete();
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ],
          ),
          body: Center(
            child: ArticleWidget(
              child: Form(
                key: _formKey,
                onChanged: () {},
                onWillPop: () async {
                  final modified = state.modified;
                  if (modified) {
                    return confirm(
                      context,
                      title: 'Discard changes?',
                      content: 'Are you sure you want to discard your changes?',
                    );
                  }
                  return true;
                },
                autovalidateMode: AutovalidateMode.always,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 24,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Builder(builder: (context) {
                              return StringFormField(
                                label: 'Title',
                                value: todo.title,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    context.read<TodoDetailsCubit>().updateTodo(
                                          title: value,
                                        );
                                  }
                                },
                                builder: (context, controller) {
                                  return TextFormField(
                                    controller: controller,
                                    key: Key('title_details_form'),
                                    maxLength: 150,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter a title.';
                                      } else if (value.length > 20) {
                                        return 'Limit the title to 20 characters.';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.title),
                                      labelText: 'Title',
                                      border: OutlineInputBorder(),
                                    ),
                                  );
                                },
                              );
                            }),
                            StringFormField(
                              label: 'Description',
                              value: todo.description,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  context.read<TodoDetailsCubit>().updateTodo(
                                        description: value,
                                      );
                                }
                              },
                              builder: (context, controller) {
                                return TextFormField(
                                  controller: controller,
                                  maxLength: 150,
                                  key: Key('description_details_form'),
                                  validator: (value) {
                                    if (value != null && value.length > 100) {
                                      return 'Limit the description to 100 characters.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.view_headline),
                                    labelText: 'Description',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              },
                            ),
                            Builder(builder: (context) {
                              final dueDate = todo.dueDate ?? DateTime.now();
                              return StringFormField(
                                label: 'Due Date',
                                value: dateFormat.format(dueDate),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    final date = DateTime.tryParse(value);
                                    if (date != null) {
                                      context
                                          .read<TodoDetailsCubit>()
                                          .updateTodo(
                                            dueDate: date,
                                          );
                                    }
                                  }
                                },
                                builder: (context, controller) {
                                  return TextFormField(
                                    focusNode: _DisabledFocusNode(),
                                    controller: controller,
                                    maxLength: 50,
                                    onTap: () async {
                                      final selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: dueDate,
                                        firstDate: dueDate.pickerStartDate,
                                        lastDate: dueDate.pickerEndDate,
                                      );
                                      if (selectedDate != null &&
                                          context.mounted) {
                                        context
                                            .read<TodoDetailsCubit>()
                                            .updateTodo(
                                              dueDate: selectedDate,
                                            );
                                        controller.text =
                                            dateFormat.format(selectedDate);
                                      }
                                    },
                                    validator: (value) {
                                      if (isNew &&
                                          dueDate.isBefore(
                                            DateTime.now().toUtc(),
                                          )) {
                                        return "DueDate must be after today's date.";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.calendar_today_rounded),
                                      labelText: 'DueDate',
                                      helperText: 'Required',
                                      border: OutlineInputBorder(),
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      SaveButton(
                        isActive: state.modified,
                        onPressed: () => _save(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _save(BuildContext context) async {
    final currentState = _formKey.currentState;
    if (currentState != null && currentState.validate()) {
      context.read<TodoDetailsCubit>().save();
    }
  }
}

class _DisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
