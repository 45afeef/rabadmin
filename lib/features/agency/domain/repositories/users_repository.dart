import '../entities/user_entity.dart';

abstract class UsersRepository {
  Future<List<UserEntity>> getAvailableUsers();
  Future<UserEntity> createUser({
    required String fullName,
    required String password,
    String? phone,
  });
}
