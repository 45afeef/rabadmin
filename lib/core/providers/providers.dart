import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rab_dio/rab_dio.dart';

// Service Provider feature imports
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource_impl.dart';
import '../../features/profile/data/repository/profile_repository_impl.dart';
import '../../features/profile/domain/repository/profile_repository.dart';
import '../../features/service_providers/data/datasources/service_provider_remote_data_source_impl.dart';
import '../../features/service_providers/data/repositories/service_provider_repository_impl.dart';
import '../../features/service_providers/domain/entities/cab_entity.dart';
import '../../features/service_providers/domain/entities/cab_provider_entity.dart';
import '../../features/service_providers/domain/entities/driver_entity.dart';
import '../../features/service_providers/domain/entities/stay_unit_entity.dart';
import '../../features/service_providers/domain/repositories/service_provider_repository.dart';

// Agency feature imports
import '../../features/agency/data/datasources/agency_remote_data_source.dart';
import '../../features/agency/data/repositories/agency_repository_impl.dart';
import '../../features/agency/domain/repositories/agency_repository.dart';
// Users wrappers for agency feature
import '../../features/agency/data/datasources/users_remote_data_source.dart';
import '../../features/agency/data/repositories/users_repository_impl.dart';
import '../../features/agency/domain/repositories/users_repository.dart';
import '../../features/agency/domain/usecases/get_available_users_use_case.dart';
import '../../features/agency/domain/usecases/create_user_use_case.dart';
// Auth feature imports
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/validate_token_use_case.dart';
import '../network/auth_interceptor.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) => HiveAuthLocalDataSource(),
);

final rabDioProvider = Provider<RabDio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  dio.interceptors.add(AuthInterceptor(localDataSource));

  return RabDio(dio: dio);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => GcpFastApiDataSource(ref.read(rabDioProvider).getLoginApi()),
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

// =============================================================================
// USERS FEATURE PROVIDERS
// =============================================================================

/// Provider for the UsersApi client from rab_dio.
///
/// Creates and manages the UsersApi instance for making HTTP requests
/// to the users API endpoints.
final usersApiProvider = Provider<UsersApi>(
  (ref) => ref.watch(rabDioProvider).getUsersApi(),
);

/// Provider for the Users remote data source (wraps `UsersApi`).
final usersRemoteDataSourceProvider = Provider<UsersRemoteDataSource>(
  (ref) => UsersRemoteDataSourceImpl(ref.read(usersApiProvider)),
);

/// Provider for the UsersRepository used by agency feature.
final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) => UsersRepositoryImpl(ref.read(usersRemoteDataSourceProvider)),
);

/// Use cases for users operations (created for agency feature)
final getAvailableUsersUseCaseProvider = Provider<GetAvailableUsersUseCase>(
  (ref) => GetAvailableUsersUseCase(ref.read(usersRepositoryProvider)),
);
final createUserUseCaseProvider = Provider<CreateUserUseCase>(
  (ref) => CreateUserUseCase(ref.read(usersRepositoryProvider)),
);

// =============================================================================
// PROFILE FEATURE PROVIDERS
// =============================================================================

/// Provider for the ProfileApi client from rab_dio.
///
/// Creates and manages the ProfileApi instance for making HTTP requests
/// to the profile API endpoints.
final profileApiProvider = Provider<ProfileApi>(
  (ref) => ref.watch(rabDioProvider).getProfileApi(),
);

/// Provider for the Profile remote data source (wraps `ProfileApi`).
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSourceImpl(ref.read(profileApiProvider)),
);

/// Provider for the ProfileRepository used by profile feature.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.read(profileRemoteDataSourceProvider)),
);

// =============================================================================
// AGENCY FEATURE PROVIDERS
// =============================================================================

/// Provider for the AgenciesApi client from rab_dio.
///
/// Creates and manages the AgenciesApi instance for making HTTP requests
/// to the agencies API endpoints.
final agenciesApiProvider = Provider<AgenciesApi>(
  (ref) => ref.watch(rabDioProvider).getAgenciesApi(),
);

/// Provider for the agency remote data source.
///
/// Creates the data source that handles all remote API communication
/// for agency-related operations.
final agencyRemoteDataSourceProvider = Provider<AgencyRemoteDataSource>(
  (ref) => AgenciesRemoteDataSource(ref.read(agenciesApiProvider)),
);

/// Provider for the agency repository.
///
/// Creates the main repository that serves as the bridge between
/// the presentation layer and data layer for agency operations.
///
/// This provider is used throughout the agency feature to access
/// all agency-related business logic.
final agencyRepositoryProvider = Provider<AgencyRepository>(
  (ref) => AgencyRepositoryImpl(ref.read(agencyRemoteDataSourceProvider)),
);
// =============================================================================
// SERVICE PROVIDER FEATURE PROVIDERS
// =============================================================================

/// Provider for the Service Provider remote data source.
final serviceProviderRemoteDataSourceProvider =
    Provider<ServiceProviderRemoteDataSourceImpl>((ref) {
      return ServiceProviderRemoteDataSourceImpl(
        ref.watch(rabDioProvider).getProvidersApi(),
        ref.watch(rabDioProvider).getProvidersCabApi(),
        ref.watch(rabDioProvider).getProvidersStayApi(),
      );
    });

/// Provider for the Service Provider repository.
final serviceProviderRepositoryProvider = Provider<ServiceProviderRepository>((
  ref,
) {
  final dataSource = ref.watch(serviceProviderRemoteDataSourceProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  final profileRepo = ref.watch(profileRepositoryProvider);

  return ServiceProviderRepositoryImpl(
    remoteDataSource: dataSource,
    authRepository: authRepo,
    profileRepository: profileRepo,
  );
});

/// Provider for listing all Cab Service Providers.
final cabProvidersListProvider = FutureProvider<List<CabProviderEntity>>((
  ref,
) async {
  final repository = ref.watch(serviceProviderRepositoryProvider);
  return repository.listCabProviders();
});

/// Provider for listing all Stay Service Providers.
final stayProvidersListProvider = FutureProvider<List<dynamic>>((ref) async {
  final repository = ref.watch(serviceProviderRepositoryProvider);
  return repository.listStayProviders();
});

/// Provider for listing Cabs for a specific provider.
///
/// Takes the provider ID as parameter.
final cabsListProvider = FutureProvider.family<List<CabEntity>, String>((
  ref,
  providerId,
) async {
  final repository = ref.watch(serviceProviderRepositoryProvider);
  return repository.listCabs(providerId);
});

/// Provider for listing Drivers for a specific provider.
///
/// Takes the provider ID as parameter.
final driversListProvider = FutureProvider.family<List<DriverEntity>, String>((
  ref,
  providerId,
) async {
  final repository = ref.watch(serviceProviderRepositoryProvider);
  return repository.listDrivers(providerId);
});

/// Provider for listing Stay Units for a specific provider.
///
/// Takes the provider ID as parameter.
final stayUnitsListProvider =
    FutureProvider.family<List<StayUnitEntity>, String>((
      ref,
      providerId,
    ) async {
      final repository = ref.watch(serviceProviderRepositoryProvider);
      return repository.listStayUnits(providerId);
    });
