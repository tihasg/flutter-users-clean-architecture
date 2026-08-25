import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection_container.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';
import '../widgets/user_list_item.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UsersBloc>()..add(const FetchUsers()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Users')),
        body: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading || state is UsersInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UsersError) {
              return Center(child: Text(state.message));
            }
            if (state is UsersLoaded) {
              if (state.users.isEmpty) {
                return const Center(child: Text('No users found'));
              }
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  return UserListItem(user: state.users[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}