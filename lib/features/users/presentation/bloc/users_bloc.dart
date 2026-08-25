import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_users.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers getUsers;

  UsersBloc(this.getUsers) : super(const UsersInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(const UsersLoading());
    try {
      final users = await getUsers(page: event.page);
      emit(UsersLoaded(users));
    } on Failure catch (failure) {
      emit(UsersError(failure.message));
    }
  }
}