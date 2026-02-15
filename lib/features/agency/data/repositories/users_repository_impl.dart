import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_remote_data_source.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;
  UsersRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> createUser({
    required String fullName,
    required String password,
    String? phone,
  }) async {
    final model = await remoteDataSource.createUser(
      fullName: fullName,
      password: password,
      phone: phone,
    );
    return UserEntity(
      id: model.id,
      fullName: model.fullName,
      email: model.email,
      phone: model.phone,
    );
  }

  @override
  Future<List<UserEntity>> getAvailableUsers() async {
    final models = await remoteDataSource.fetchUsers();
    return models
        .map(
          (m) => UserEntity(
            id: m.id,
            fullName: m.fullName,
            email: m.email,
            phone: m.phone,
          ),
        )
        .toList();
  }
}
