import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rab_dio/rab_dio.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/validate_token_use_case.dart';

RabDio rab = RabDio(
  dio: Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? '')),
);

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) => HiveAuthLocalDataSource(),
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => GcpFastApiDataSource(rab.getLoginApi()),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider),
    ref.read(authLocalDataSourceProvider),
  ),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

final validateTokenUseCaseProvider = Provider<ValidateTokenUseCase>(
  (ref) => ValidateTokenUseCase(ref.read(authRepositoryProvider)),
);
