import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../models/user_model.dart';

abstract class UsersLocalDataSource {
  /// Returns the cached users for [page], or an empty list if nothing has
  /// been cached for that page yet.
  Future<List<UserModel>> getCachedUsers({int page = 1});

  /// Replaces the cached rows for [page] with [users].
  Future<void> cacheUsers(List<UserModel> users, {int page = 1});
}

class UsersLocalDataSourceImpl implements UsersLocalDataSource {
  final AppDatabase database;

  const UsersLocalDataSourceImpl(this.database);

  @override
  Future<List<UserModel>> getCachedUsers({int page = 1}) async {
    final rows = await (database.select(database.cachedUsers)
          ..where((row) => row.page.equals(page)))
        .get();

    return rows
        .map(
          (row) => UserModel(
            id: row.id,
            email: row.email,
            firstName: row.firstName,
            lastName: row.lastName,
            avatarUrl: row.avatarUrl,
          ),
        )
        .toList();
  }

  @override
  Future<void> cacheUsers(List<UserModel> users, {int page = 1}) async {
    await database.transaction(() async {
      await (database.delete(database.cachedUsers)
            ..where((row) => row.page.equals(page)))
          .go();

      await database.batch((batch) {
        batch.insertAll(
          database.cachedUsers,
          users.map(
            (user) => CachedUsersCompanion.insert(
              id: Value(user.id),
              email: user.email,
              firstName: user.firstName,
              lastName: user.lastName,
              avatarUrl: user.avatarUrl,
              page: page,
            ),
          ),
        );
      });
    });
  }
}