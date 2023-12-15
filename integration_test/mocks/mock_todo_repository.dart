import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:mocktail/mocktail.dart';

@visibleForTesting
class MockTodoRepo extends Mock implements TodoRepository {}