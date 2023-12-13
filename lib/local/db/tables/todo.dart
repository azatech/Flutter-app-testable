import 'package:drift/drift.dart';
import 'package:drift_app_testble/local/db/util/table_utils.dart';

class Todo extends Table with AutoIncrementingPrimaryKey {
  TextColumn get title => text().named('title').withLength(
        min: 1,
        max: 32,
      )();

  TextColumn get description => text()
      .named('description')
      .nullable()
      .withLength(
        min: 1,
        max: 32,
      )
      .nullable()();

  DateTimeColumn get dueDate => dateTime().named('due_date').nullable()();

  BoolColumn get isCompleted => boolean().named('is_completed').nullable()();
}
