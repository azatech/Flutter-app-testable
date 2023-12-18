import 'package:drift/drift.dart';
import 'package:drift_app_testble/helpers/unit_todo_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../integration_test/test_app_helper.dart';

/// Usage: I'm opening app with todos in DB
Future<void> imOpeningAppWithTodosInDb(WidgetTester tester) async {
  final (_, _, _, mockRepository) = TestAppHelper.setUpHomeMain();
  when(() => mockRepository.getTodos()).thenAnswer(
    (_) async => UnitTodoFactory.fullListTodos,
  );
  when(() => mockRepository.watchTodos()).thenAnswer(
    (_) => Stream.fromIterable([
      UnitTodoFactory.fullListTodos,
    ]),
  );
}
