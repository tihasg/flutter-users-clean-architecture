import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter/core/error/exceptions.dart';
import 'package:test_flutter/core/error/failures.dart';
import 'package:test_flutter/features/users/data/datasources/users_remote_data_source.dart';
import 'package:test_flutter/features/users/data/models/user_model.dart';
import 'package:test_flutter/features/users/data/repositories/users_repository_impl.dart';

class MockUsersRemoteDataSource extends Mock
    implements UsersRemoteDataSource {}

void main() {
  late UsersRepositoryImpl repository;
  late MockUsersRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = MockUsersRemoteDataSource();
    repository = UsersRepositoryImpl(remoteDataSource);
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

  test('should return users when the remote data source succeeds', () async {
    when(() => remoteDataSource.getUsers(page: 1))
        .thenAnswer((_) async => tUserModels);

    final result = await repository.getUsers(page: 1);

    expect(result, tUserModels);
  });

  test('should throw ServerFailure when the remote data source throws '
      'ServerException', () async {
    when(() => remoteDataSource.getUsers(page: 1))
        .thenThrow(const ServerException());

    expect(
      () => repository.getUsers(page: 1),
      throwsA(isA<ServerFailure>()),
    );
  });

  test('should throw NetworkFailure when the remote data source throws '
      'NetworkException', () async {
    when(() => remoteDataSource.getUsers(page: 1))
        .thenThrow(const NetworkException());

    expect(
      () => repository.getUsers(page: 1),
      throwsA(isA<NetworkFailure>()),
    );
  });
}