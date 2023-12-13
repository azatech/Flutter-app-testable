// These imports are necessary to open the sqlite3 database
import 'package:drift/drift.dart';
import 'package:drift_app_testble/local/db/tables/todo.dart';
import 'package:drift_app_testble/local/db/tables/todos_dao.dart';

import '../connection/connection.dart' as impl;

part 'app_db.g.dart';

@DriftDatabase(
  tables: [Todo],
  daos: [TodosDao],
  // include: {'sql.drift'},
)
class AppDB extends _$AppDB {
  AppDB() : super(impl.connect());

  AppDB.forTesting(QueryExecutor connection) : super(connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            /// ...
          }
        },
      );
}

/*
LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
 */
