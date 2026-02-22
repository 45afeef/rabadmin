import 'package:hive_flutter/hive_flutter.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  /// Stores the current user ID in persistent storage.
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> deleteUserId();
}

class HiveAuthLocalDataSource implements AuthLocalDataSource {
  static const String _boxName = 'auth_box';
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'user_id';

  late Box<String> _box;

  // in-memory cache for fast access
  String? _cachedUserId;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  @override
  Future<void> saveToken(String token) async {
    await _box.put(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _box.get(_tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _box.delete(_tokenKey);
  }

  @override
  Future<void> saveUserId(String userId) async {
    _cachedUserId = userId;
    await _box.put(_userIdKey, userId);
  }

  @override
  Future<String?> getUserId() async {
    if (_cachedUserId != null) return _cachedUserId;
    final id = _box.get(_userIdKey);
    _cachedUserId = id;
    return id;
  }

  @override
  Future<void> deleteUserId() async {
    _cachedUserId = null;
    await _box.delete(_userIdKey);
  }
}
