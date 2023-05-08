import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/logic/user_view_model.dart';
import 'package:mvvm_riverpod/model/user_model.dart';

class UserListView extends ConsumerWidget {
  const UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<UserModel>> userState = ref.watch(userViewModel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: userState.when(
          loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
          error: ((error, stackTrace) => Center(
                child: Text(error.toString()),
              )),
          data: (users) {
            if (users.isEmpty) {
              return const Center(
                child: Text('No users found'),
              );
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.first_name + ' ' + user.last_name),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        ref.read(userViewModel.notifier).deleteUser(user.id),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateUserDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openCreateUserDialog(
      BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final jobController = TextEditingController();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: jobController,
                  decoration: const InputDecoration(labelText: 'Job'),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text;
                    final job = jobController.text;
                    final data = {'name': name, 'job': job};
                    await ref.read(userViewModel.notifier).createUser(data);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Create'))
            ],
          );
        });
  }
}
