abstract class AuthRepository {
  Future<String> login({required String email, required String password});
  Future<String?> validateToken();
  Future<void> logout();
}
