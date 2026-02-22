import 'dart:convert';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<void> login({required String email, required String password}) async {
    final token = await remoteDataSource.login(
      username: email,
      password: password,
    );
    await localDataSource.saveToken(token);

    // attempt to extract a user id from the token and persist it. if for some
    // reason parsing fails we simply ignore (getCurrentUserId will then return
    // null until something more reliable is available).
    final id = _extractUserIdFromToken(token);
    if (id != null) {
      await localDataSource.saveUserId(id);
    }
  }

  @override
  Future<bool> validateToken() async {
    try {
      // Validate token with the API
      await remoteDataSource.validateToken();
      return true;
    } catch (e) {
      // Token is invalid or expired – clear both token and stored user id
      await localDataSource.deleteToken();
      await localDataSource.deleteUserId();
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteToken();
    await localDataSource.deleteUserId();
  }

  @override
  Future<String?> getCurrentUserId() async {
    var id = await localDataSource.getUserId();
    if (id != null) return id;
    // maybe we ran before the user-id saving logic was added; try to parse
    // the token directly and persist the result for next time.
    final token = await localDataSource.getToken();
    if (token != null) {
      id = _extractUserIdFromToken(token);
      if (id != null) {
        await localDataSource.saveUserId(id);
      }
    }
    return id;
  }

  /// Decode a JWT and attempt to read a common user identifier claim.
  ///
  /// This implementation is deliberately minimal to avoid extra dependencies.
  /// It only handles base64url decoding and JSON parsing.
  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = String.fromCharCodes(base64Url.decode(normalized));
      final map = json.decode(decoded) as Map<String, dynamic>;
      // common claim names – adjust depending on API behaviour
      return map['sub']?.toString() ?? map['user_id']?.toString();
    } catch (_) {
      return null;
    }
  }
}
