import 'package:hive_flutter/hive_flutter.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

class HiveAuthLocalDataSource implements AuthLocalDataSource {
  static const String _boxName = 'auth_box';
  static const String _tokenKey = 'token';

  late Box<String> _box;

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
}
