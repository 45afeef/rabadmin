abstract class AuthRepository {
  Future<void> login({required String email, required String password});
  Future<bool> validateToken();
  Future<void> logout();

  /// Returns the ID of the currently authenticated user, if known.
  ///
  /// This value may be cached in memory or persisted so that it survives
  /// app restarts. It is expected to be non-null once the user has logged in
  /// successfully.
  Future<String?> getCurrentUserId();
}
