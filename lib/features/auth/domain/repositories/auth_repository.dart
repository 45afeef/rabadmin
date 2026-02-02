abstract class AuthRepository {
  Future<void> login({required String email, required String password});
  Future<bool> validateToken();
  Future<void> logout();
}
