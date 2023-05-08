import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/data/api/api_helper.dart';
import 'package:mvvm_riverpod/data/api/endpoint.dart';

final userService = Provider((ref) => UserService());

class UserService {

  Future<dynamic> getUsers() async {
    try {
      final response = await ApiHelper.get(Endpoints.user);
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> createUser(Map<String, dynamic> data) async {
    try {
      final response = await ApiHelper.post(Endpoints.user, data);
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final response = await ApiHelper.put(Endpoints.user+'/$id', data);
      return response;
    } catch (e) {
      print(e);
    }
  }

   Future<dynamic> deleteUser(int id) async {
    try {
      final response = await ApiHelper.delete(Endpoints.user+'/$id');
      return response;
    } catch (e) {
      print(e);
    }
  }
}
