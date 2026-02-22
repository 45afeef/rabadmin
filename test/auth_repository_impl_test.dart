import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rabadmin/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:rabadmin/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rabadmin/features/auth/data/repositories/auth_repository_impl.dart';

class _InMemoryLocal implements AuthLocalDataSource {
  String? _token;
  String? _userId;

  @override
  Future<void> deleteToken() async {
    _token = null;
  }

  @override
  Future<void> deleteUserId() async {
    _userId = null;
  }

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<String?> getUserId() async => _userId;

  @override
  Future<void> saveToken(String token) async {
    _token = token;
  }

  @override
  Future<void> saveUserId(String userId) async {
    _userId = userId;
  }
}

class _DummyRemote implements AuthRemoteDataSource {
  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    // produce a fake JWT whose payload encodes a user id of "u-123".
    final header = base64Url.encode(utf8.encode(json.encode({'alg': 'none'})));
    final payload = base64Url.encode(
      utf8.encode(json.encode({'sub': 'u-123'})),
    );
    return '$header.$payload.'; // trailing dot for signature
  }

  @override
  Future<void> validateToken() async {}
}

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repo;
    late _InMemoryLocal local;
    setUp(() {
      local = _InMemoryLocal();
      repo = AuthRepositoryImpl(_DummyRemote(), local);
    });

    test('login saves token and user id', () async {
      await repo.login(email: 'a', password: 'b');
      expect(local._token, isNotNull);
      final id = await repo.getCurrentUserId();
      expect(id, 'u-123');
    });

    test('getCurrentUserId falls back to decoding token', () async {
      // simulate old install where only token was saved
      final header = base64Url.encode(
        utf8.encode(json.encode({'alg': 'none'})),
      );
      final payload = base64Url.encode(
        utf8.encode(json.encode({'sub': 'foo'})),
      );
      await local.saveToken('$header.$payload.');
      final id = await repo.getCurrentUserId();
      expect(id, 'foo');
      // should also have been persisted
      expect(await local.getUserId(), 'foo');
    });
  });
}
