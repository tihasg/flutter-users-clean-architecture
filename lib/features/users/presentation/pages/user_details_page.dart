import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class UserDetailsPage extends StatelessWidget {
  final User user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.fullName)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 64,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              user.fullName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(user.email),
          ),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('ID'),
            subtitle: Text('${user.id}'),
          ),
        ],
      ),
    );
  }
}