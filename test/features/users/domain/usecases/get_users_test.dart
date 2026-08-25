import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter/features/users/domain/entities/user.dart';
import 'package:test_flutter/features/users/domain/repositories/users_repository.dart';
import 'package:test_flutter/features/users/domain/usecases/get_users.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  late GetUsers usecase;
  late MockUsersRepository repository;

  setUp(() {
    repository = MockUsersRepository();
    usecase = GetUsers(repository);
  });

  const tUsers = [
    User(
      id: 1,
      email: 'george.bluth@reqres.in',
      firstName: 'George',
      lastName: 'Bluth',
      avatarUrl: 'https://reqres.in/img/faces/1-image.jpg',
    ),
  ];

  test('should fetch users from the repository for the given page', () async {
    when(() => repository.getUsers(page: 1)).thenAnswer((_) async => tUsers);

    final result = await usecase(page: 1);

    expect(result, tUsers);
    verify(() => repository.getUsers(page: 1)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should default to page 1 when no page is provided', () async {
    when(() => repository.getUsers(page: 1)).thenAnswer((_) async => tUsers);

    await usecase();

    verify(() => repository.getUsers(page: 1)).called(1);
  });
}