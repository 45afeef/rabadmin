import 'package:dio/dio.dart';
import 'package:rab_dio/rab_dio.dart'
    show UserCreate, UserPublic, UsersApi, standardSerializers;

import '../models/user_model.dart';

abstract class UsersRemoteDataSource {
  Future<List<UserModel>> fetchUsers();

  Future<UserModel> createUser({
    required String fullName,
    required String password,
    required String phone,
  });
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final UsersApi usersApi;
  UsersRemoteDataSourceImpl(this.usersApi);

  @override
  Future<List<UserModel>> fetchUsers() async {
    final response = await usersApi.usersReadUsers();
    if (response.data != null) {
      if (response.data!.count == 0) return [];

      final List data = response.data!.data.map((user) {
        final userJson = standardSerializers.serializeWith(
          UserPublic.serializer,
          user,
        );
        return userJson;
      }).toList();

      return data
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load users');
  }

  @override
  Future<UserModel> createUser({
    required String fullName,
    required String password,
    required String phone,
  }) async {
    final userCreate = UserCreate(
      (b) => b
        ..fullName = fullName
        ..password = password
        ..phoneNumber = phone,
    );

    try {
      final response = await usersApi.usersCreateUser(userCreate: userCreate);

      if (response.data != null) {
        final userData = standardSerializers.serializeWith(
          UserPublic.serializer,
          response.data,
        );

        return UserModel.fromMap(userData as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      String newMessage = e.response == null
          ? e.message.toString()
          : "${e.response!.data['detail'][0]["loc"][1]} ${e.response!.data['detail'][0]["msg"]}";
      throw Exception(newMessage);
    } catch (e) {
      rethrow;
    }

    throw Exception('Failed to create user');
  }
}
