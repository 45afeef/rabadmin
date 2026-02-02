import 'package:dio/dio.dart';
import 'package:rab_dio/rab_dio.dart' show LoginApi;

abstract class AuthRemoteDataSource {
  Future<String> login({required String username, required String password});
  Future<void> validateToken();
}

class GcpFastApiDataSource extends AuthRemoteDataSource {
  final LoginApi api;

  GcpFastApiDataSource(this.api);

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await api.loginLoginAccessToken(
        password: password,
        username: username,
        grantType: 'password',
      );

      return response.data!.accessToken;
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString());
    }
  }

  @override
  Future<void> validateToken() async {
    try {
      final response = await api.loginTestToken();

      if (response.statusCode != 200) {
        throw Exception('Token validation failed');
      }
    } on DioException catch (e) {
      throw Exception(
        'Token validation failed: ${e.response?.data.toString()}',
      );
    }
  }
}
