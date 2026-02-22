import '../../domain/entities/cab_provider_entity.dart';
import '../../domain/repositories/service_provider_repository.dart';
import '../datasources/service_provider_remote_data_source.dart';
import '../models/cab_provider_model.dart';

import '../../../auth/domain/repositories/auth_repository.dart';

class ServiceProviderRepositoryImpl extends ServiceProviderRepository {
  final ServiceProviderRemoteDataSource remoteDataSource;
  // TODO : ideally the repository should not have to know about auth at all and should just throw an UnauthenticatedException if the user is not authenticated; the use case or controller can then catch this and handle it appropriately (e.g. by showing a login prompt). For now we have to pull the user ID in the repository to satisfy the API requirements, but this is a bit of a leaky abstraction and something we may want to refactor in the future.
  final AuthRepository authRepository;

  ServiceProviderRepositoryImpl(this.remoteDataSource, this.authRepository);

  // ===== CAB PROVIDERS =====
  @override
  Future<List<CabProviderEntity>> listCabProviders() async {
    final models = await remoteDataSource.listCabProviders();
    return models.map((model) => _mapCabProviderModelToEntity(model)).toList();
  }

  @override
  Future<CabProviderEntity> getCabProvider(String providerId) async {
    final model = await remoteDataSource.getCabProvider(providerId);
    return _mapCabProviderModelToEntity(model);
  }

  @override
  Future<CabProviderEntity> createCabProvider({
    required String providerName,
  }) async {
    // pull the current user id from auth; repository will return `null` if the
    // caller is not authenticated (which should not happen in production).
    // TODO : this is a bit of a leaky abstraction, since we're relying on the repository to enforce authentication requirements. In a more robust implementation, we might want to enforce this at the use case level instead, or throw a more specific exception here if the user is not authenticated.
    // TODO : ideally the API would handle setting the createdBy field based on the authenticated user, rather than requiring the client to pass it in; this is a potential source of bugs if the client and server get out of sync on how this field is set. For now we have to pass it in because the generated types require it, but this is something to consider improving in the future.
    final createdBy = await authRepository.getCurrentUserId();
    if (createdBy == null) {
      throw Exception('User must be authenticated to create a provider');
    }

    final model = await remoteDataSource.createCabProvider(
      providerName: providerName,
      createdBy: createdBy,
    );
    return _mapCabProviderModelToEntity(model);
  }

  @override
  Future<CabProviderEntity> updateCabProvider(
    String providerId, {
    String? providerName,
    String? locationId,
  }) async {
    final model = await remoteDataSource.updateCabProvider(
      providerId,
      providerName: providerName,
      locationId: locationId,
    );
    return _mapCabProviderModelToEntity(model);
  }

  @override
  Future<void> deleteCabProvider(String providerId) =>
      remoteDataSource.deleteCabProvider(providerId);

  // ===== MAPPERS =====
  CabProviderEntity _mapCabProviderModelToEntity(CabProviderModel model) {
    return CabProviderEntity(
      id: model.id,
      name: model.name,
      createdBy: model.createdBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      ownerId: model.ownerId,
    );
  }
}
