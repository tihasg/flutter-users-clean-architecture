import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter/core/error/exceptions.dart';
import 'package:test_flutter/core/error/failures.dart';
import 'package:test_flutter/features/users/data/datasources/users_local_data_source.dart';
import 'package:test_flutter/features/users/data/datasources/users_remote_data_source.dart';
import 'package:test_flutter/features/users/data/models/user_model.dart';
import 'package:test_flutter/features/users/data/repositories/users_repository_impl.dart';

class MockUsersRemoteDataSource extends Mock
    implements UsersRemoteDataSource {}

class MockUsersLocalDataSource extends Mock implements UsersLocalDataSource {}

void main() {
  late UsersRepositoryImpl repository;
  late MockUsersRemoteDataSource remoteDataSource;
  late MockUsersLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockUsersRemoteDataSource();
    localDataSource = MockUsersLocalDataSource();
    repository = UsersRepositoryImpl(remoteDataSource, localDataSource);
  });

  const tUserModels = [
    UserModel(
      id: 1,
      email: 'george.bluth@reqres.in',
      firstName: 'George',
      lastName: 'Bluth',
      avatarUrl: 'https://reqres.in/img/faces/1-image.jpg',
    ),
  ];

  test(
      'should return users and cache them when the remote data source '
      'succeeds', () async {
    when(() => remoteDataSource.getUsers(page: 1))
        .thenAnswer((_) async => tUserModels);
    when(() => localDataSource.cacheUsers(any(), page: 1))
        .thenAnswer((_) async {});

    final result = await repository.getUsers(page: 1);

    expect(result, tUserModels);
    verify(() => localDataSource.cacheUsers(tUserModels, page: 1)).called(1);
  });

  test(
      'should return cached users when the remote data source throws '
      'ServerException and the cache is not empty', () async {
    when(() => remoteDataSource.getUsers(page: 1))
        .thenThrow(const ServerException());
    when(() => localDataSource.getCachedUsers(page: 1))
        .thenAnswer((_) async => tUserModels);

    final result = await repository.getUsers(page: 1);

    expect(result, tUserModels);
  });

  test(
      'should throw ServerFailure when the remote data source throws '
      'ServerException and the cache is empty', () async {
    when(() => remoteDataSource.getUsers(page: 1))
        .thenThrow(const ServerException());
    when(() => localDataSource.getCachedUsers(page: 1))
        .thenAnswer((_) async => []);

    expect(
      () => repository.getUsers(page: 1),
      throwsA(isA<ServerFailure>()),
    );
  });

  test(
      'should return cached users when the remote data source throws '
      'NetworkException and the cache is not empty', () async {
    when(() => remoteDataSource.getUsers(page: 1))
        .thenThrow(const NetworkException());
    when(() => localDataSource.getCachedUsers(page: 1))
        .thenAnswer((_) async => tUserModels);

    final result = await repository.getUsers(page: 1);

    expect(result, tUserModels);
  });

  test(
      'should throw NetworkFailure when the remote data source throws '
      'NetworkException and the cache is empty', () async {
    when(() => remoteDataSource.getUsers(page: 1))
        .thenThrow(const NetworkException());
    when(() => localDataSource.getCachedUsers(page: 1))
        .thenAnswer((_) async => []);

    expect(
      () => repository.getUsers(page: 1),
      throwsA(isA<NetworkFailure>()),
    );
  });
}