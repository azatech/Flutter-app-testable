// import 'dart:math';
//
// import 'package:equatable/equatable.dart';
//
// class Todo extends Equatable {
//   final int id;
//   final String title;
//   final String? description;
//   final bool isCompleted;
//   final DateTime dueDate;
//
//   const Todo({
//     required this.id,
//     required this.title,
//     this.description,
//     required this.dueDate,
//     this.isCompleted = false,
//   });
//
//   factory Todo.empty() {
//     return Todo(
//       id: Random().nextInt(1000),
//       title: '',
//       dueDate: DateTime.now(),
//     );
//   }
//
//   @override
//   List<Object?> get props => [id, title, description, isCompleted, dueDate];
//
//   Todo copyWith({
//     int? id,
//     String? title,
//     String? description,
//     bool? isCompleted,
//     DateTime? dueDate,
//   }) {
//     return Todo(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       isCompleted: isCompleted ?? this.isCompleted,
//       dueDate: dueDate ?? this.dueDate,
//     );
//   }
// }
//
// extension TodosExtension on List<Todo> {
//   List<Todo> filterByCompleted() {
//     return where((todo) => todo.isCompleted).toList();
//   }
//
//   List<Todo> filterByIncomplete() {
//     return where((todo) => !todo.isCompleted).toList();
//   }
// }
