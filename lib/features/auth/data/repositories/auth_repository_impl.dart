import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final token = await remoteDataSource.login(
      username: email,
      password: password,
    );
    await localDataSource.saveToken(token);
  }

  @override
  Future<bool> validateToken() async {
    try {
      // Validate token with the API
      await remoteDataSource.validateToken();
      return true;
    } catch (e) {
      // Token is invalid or expired
      await localDataSource.deleteToken();
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteToken();
  }
}
