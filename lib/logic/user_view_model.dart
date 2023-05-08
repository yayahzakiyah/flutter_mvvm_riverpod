import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/data/api/service/user_service.dart';
import 'package:mvvm_riverpod/model/user_model.dart';

final userViewModel = StateNotifierProvider.autoDispose<UserViewModel,
    AsyncValue<List<UserModel>>>((ref) {
  final userServiceViewModel = ref.watch(userService);
  return UserViewModel(userServiceViewModel);
});

class UserViewModel extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserService _userService;

  UserViewModel(this._userService) : super(AsyncValue.loading()) {
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      final resp = await _userService.getUsers();
      final data = resp.data['data'] as List<dynamic>;
      final users = data.map((user) => UserModel.fromJson(user)).toList();
      state = AsyncValue.data(users);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createUser(Map<String, dynamic> data) async {
    try {
      final resp = await _userService.createUser(data);
      print('create user');
      print(resp);
      // final user = UserModel.fromJson(resp);
      // state.whenData((users) => state = AsyncValue.data([...users, user]));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final resp = await _userService.updateUser(id, data);
      final user = UserModel.fromJson(resp);
      state.whenData((users) {
        final index = users.indexWhere((user) => user.id == id);
        final updatedUsers = [...users];
        updatedUsers[index] = user;
        state = AsyncValue.data(updatedUsers);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _userService.deleteUser(id);
      state.whenData((users) {
        final updatedUsers = users.where((user) => user.id != id).toList();
        state = AsyncValue.data(updatedUsers);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
