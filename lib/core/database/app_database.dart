import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Cached users. `page` records which reqres.in page a row belongs to so a
/// page can be refreshed independently of the rest of the cache.
class CachedUsers extends Table {
  IntColumn get id => integer()();
  TextColumn get email => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get avatarUrl => text()();
  IntColumn get page => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CachedUsers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_db');
  }
}