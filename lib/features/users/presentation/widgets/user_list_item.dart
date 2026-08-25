import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),
      title: Text(user.fullName),
      subtitle: Text(user.email),
    );
  }
}