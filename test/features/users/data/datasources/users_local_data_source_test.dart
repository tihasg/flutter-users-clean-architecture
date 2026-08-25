import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter/core/database/app_database.dart';
import 'package:test_flutter/features/users/data/datasources/users_local_data_source.dart';
import 'package:test_flutter/features/users/data/models/user_model.dart';

void main() {
  late AppDatabase database;
  late UsersLocalDataSourceImpl dataSource;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = UsersLocalDataSourceImpl(database);
  });

  tearDown(() => database.close());

  const tUserModels = [
    UserModel(
      id: 1,
      email: 'george.bluth@reqres.in',
      firstName: 'George',
      lastName: 'Bluth',
      avatarUrl: 'https://reqres.in/img/faces/1-image.jpg',
    ),
  ];

  test('should return an empty list when nothing is cached', () async {
    final result = await dataSource.getCachedUsers(page: 1);
    expect(result, isEmpty);
  });

  test('should return the cached users for the given page', () async {
    await dataSource.cacheUsers(tUserModels, page: 1);

    final result = await dataSource.getCachedUsers(page: 1);

    expect(result, tUserModels);
  });

  test('should not return users cached for a different page', () async {
    await dataSource.cacheUsers(tUserModels, page: 1);

    final result = await dataSource.getCachedUsers(page: 2);

    expect(result, isEmpty);
  });

  test('should replace the previous cache for a page on re-caching',
      () async {
    await dataSource.cacheUsers(tUserModels, page: 1);
    await dataSource.cacheUsers(const [], page: 1);

    final result = await dataSource.getCachedUsers(page: 1);

    expect(result, isEmpty);
  });
}