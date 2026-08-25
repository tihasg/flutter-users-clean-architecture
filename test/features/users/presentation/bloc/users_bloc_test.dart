import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter/core/error/failures.dart';
import 'package:test_flutter/features/users/domain/entities/user.dart';
import 'package:test_flutter/features/users/domain/usecases/get_users.dart';
import 'package:test_flutter/features/users/presentation/bloc/users_bloc.dart';
import 'package:test_flutter/features/users/presentation/bloc/users_event.dart';
import 'package:test_flutter/features/users/presentation/bloc/users_state.dart';

class MockGetUsers extends Mock implements GetUsers {}

void main() {
  late MockGetUsers getUsers;

  const tUsers = [
    User(
      id: 1,
      email: 'george.bluth@reqres.in',
      firstName: 'George',
      lastName: 'Bluth',
      avatarUrl: 'https://reqres.in/img/faces/1-image.jpg',
    ),
  ];

  setUp(() {
    getUsers = MockGetUsers();
  });

  blocTest<UsersBloc, UsersState>(
    'emits [UsersLoading, UsersLoaded] when GetUsers succeeds',
    build: () {
      when(() => getUsers(page: 1)).thenAnswer((_) async => tUsers);
      return UsersBloc(getUsers);
    },
    act: (bloc) => bloc.add(const FetchUsers()),
    expect: () => [
      const UsersLoading(),
      const UsersLoaded(tUsers),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emits [UsersLoading, UsersError] when GetUsers throws a Failure',
    build: () {
      when(() => getUsers(page: 1))
          .thenThrow(const ServerFailure('Server error'));
      return UsersBloc(getUsers);
    },
    act: (bloc) => bloc.add(const FetchUsers()),
    expect: () => [
      const UsersLoading(),
      const UsersError('Server error'),
    ],
  );
}