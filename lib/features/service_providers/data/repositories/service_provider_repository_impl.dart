import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../profile/domain/repository/profile_repository.dart';
import '../../domain/entities/cab_entity.dart';
import '../../domain/entities/cab_provider_entity.dart';
import '../../domain/entities/driver_entity.dart';
import '../../domain/entities/stay_amenity_entity.dart';
import '../../domain/entities/stay_provider_entity.dart';
import '../../domain/entities/stay_unit_entity.dart';
import '../../domain/repositories/service_provider_repository.dart';
import '../datasources/service_provider_remote_data_source.dart';
import '../models/cab_model.dart';
import '../models/cab_provider_model.dart';
import '../models/driver_model.dart';
import '../models/stay_amenity_model.dart';
import '../models/stay_provider_model.dart';
import '../models/stay_unit_model.dart';

class ServiceProviderRepositoryImpl extends ServiceProviderRepository {
  final ServiceProviderRemoteDataSource remoteDataSource;
  final ProfileRepository profileRepository;
  // TODO : ideally the repository should not have to know about auth at all and should just throw an UnauthenticatedException if the user is not authenticated; the use case or controller can then catch this and handle it appropriately (e.g. by showing a login prompt). For now we have to pull the user ID in the repository to satisfy the API requirements, but this is a bit of a leaky abstraction and something we may want to refactor in the future.
  final AuthRepository authRepository;

  ServiceProviderRepositoryImpl({
    required this.remoteDataSource,
    required this.authRepository,
    required this.profileRepository,
  });

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
    required double latitude,
    required double longitude,
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
      latitude: latitude,
      longitude: longitude,
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

  // ===== STAY PROVIDERS =====
  @override
  Future<List<StayProviderEntity>> listStayProviders() async {
    final models = await remoteDataSource.listStayProviders();
    return models.map((model) => _mapStayProviderModelToEntity(model)).toList();
  }

  @override
  Future<StayProviderEntity> getStayProvider(String providerId) async {
    final model = await remoteDataSource.getStayProvider(providerId);
    return _mapStayProviderModelToEntity(model);
  }

  @override
  Future<StayProviderEntity> createStayProvider({
    required String providerName,
    required double latitude,
    required double longitude,
    String? propertyType,
    int? roomCount,
  }) async {
    final createdBy = await authRepository.getCurrentUserId();
    if (createdBy == null) {
      throw Exception('User must be authenticated to create a provider');
    }

    final model = await remoteDataSource.createStayProvider(
      providerName: providerName,
      createdBy: createdBy,
      propertyType: propertyType,
      roomCount: roomCount,
      latitude: latitude,
      longitude: longitude,
    );
    return _mapStayProviderModelToEntity(model);
  }

  @override
  Future<StayProviderEntity> updateStayProvider(
    String providerId, {
    String? providerName,
    String? locationId,
    String? propertyType,
    int? roomCount,
  }) async {
    final model = await remoteDataSource.updateStayProvider(
      providerId,
      providerName: providerName,
      locationId: locationId,
      propertyType: propertyType,
      roomCount: roomCount,
    );
    return _mapStayProviderModelToEntity(model);
  }

  @override
  Future<void> deleteStayProvider(String providerId) =>
      remoteDataSource.deleteStayProvider(providerId);

  // ===== CABS =====
  @override
  Future<List<CabEntity>> listCabs(String providerId) async {
    final models = await remoteDataSource.listCabs(providerId);
    return models.map((model) => _mapCabModelToEntity(model)).toList();
  }

  @override
  Future<CabEntity> createCab(
    String providerId, {
    required String vehicleType,
    required String vehicleNumber,
    required double minimumRate,
    required double kmForMinimumRate,
    required double perKmRate,
    required int capacity,
    required String name,
    required String companyModel,
    required String color,
  }) async {
    final model = await remoteDataSource.createCab(
      providerId,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      minimumRate: minimumRate,
      kmForMinimumRate: kmForMinimumRate,
      perKmRate: perKmRate,
      capacity: capacity,
      name: name,
      companyModel: companyModel,
      color: color,
    );
    return _mapCabModelToEntity(model);
  }

  // ===== DRIVERS =====
  @override
  Future<List<DriverEntity>> listDrivers(String providerId) async {
    final models = await remoteDataSource.listDrivers(providerId);
    return models.map((model) => _mapDriverModelToEntity(model)).toList();
  }

  @override
  Future<DriverEntity> createDriver({
    required String providerId,
    required String profileId,
  }) async {
    final model = await remoteDataSource.createDriver(
      providerId: providerId,
      profileId: profileId,
    );
    return _mapDriverModelToEntity(model);
  }

  // helper method to create a driver and his profile in one step; this is not part of the repository interface since it's a bit of a higher level operation that involves both the service provider and profile repositories, but it can be useful for simplifying the flow in the UI when we need to create a new driver along with their profile.
  @override
  Future<DriverEntity> createDriverWithProfile({
    required String providerId,
    required String name,
    required String phoneNumber,
  }) async {
    final createdBy = await authRepository.getCurrentUserId();
    if (createdBy == null) {
      throw Exception('User must be authenticated to create a driver');
    }

    // first create the profile
    final profile = await profileRepository.createProfile(
      name: name,
      createdByUserId: createdBy,
      phoneNumber: phoneNumber,
    );

    // then create the driver using the new profile ID
    return await createDriver(providerId: providerId, profileId: profile.id!);
  }

  // ===== STAY UNITS =====
  @override
  Future<List<StayUnitEntity>> listStayUnits(
    String providerId, {
    int? minPrice,
    int? maxPrice,
    List<String>? amenities,
    int? limit,
    int? offset,
  }) async {
    final models = await remoteDataSource.listStayUnits(
      providerId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      amenities: amenities,
      limit: limit,
      offset: offset,
    );
    return models.map((model) => _mapStayUnitModelToEntity(model)).toList();
  }

  @override
  Future<StayUnitEntity> createStayUnit(
    String providerId, {
    required String name,
    String? description,
    int? roomRate,
    int? perHeadRate,
    int? maxOccupancy,
  }) async {
    final model = await remoteDataSource.createStayUnit(
      providerId,
      name: name,
      description: description,
      roomRate: roomRate,
      perHeadRate: perHeadRate,
      maxOccupancy: maxOccupancy,
    );
    return _mapStayUnitModelToEntity(model);
  }

  // ===== STAY AMENITIES =====
  @override
  Future<StayAmenityEntity> addAmenity(
    String providerId,
    String unitId, {
    required String amenity,
    required String amenityScope,
  }) async {
    final model = await remoteDataSource.addAmenity(
      providerId,
      unitId,
      amenity: amenity,
      amenityScope: amenityScope,
    );
    return _mapStayAmenityModelToEntity(model);
  }

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

  StayProviderEntity _mapStayProviderModelToEntity(StayProviderModel model) {
    return StayProviderEntity(
      id: model.id,
      name: model.name,
      createdBy: model.createdBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      ownerId: model.ownerId,
      roomCount: model.roomCount,
    );
  }

  CabEntity _mapCabModelToEntity(CabModel model) {
    return CabEntity(
      id: model.id,
      providerId: model.providerId,
      vehicleType: model.vehicleType,
      vehicleNumber: model.vehicleNumber,
      minimumRate: model.minimumRate,
      kmForMinimumRate: model.kmForMinimumRate,
      perKmRate: model.perKmRate,
      capacity: model.capacity,
      name: model.name,
      companyModel: model.companyModel,
      color: model.color,
    );
  }

  DriverEntity _mapDriverModelToEntity(DriverModel model) {
    return DriverEntity(
      id: model.id,
      userId: model.userId,
      providerId: model.providerId,
      profileId: model.profileId,
    );
  }

  StayUnitEntity _mapStayUnitModelToEntity(StayUnitModel model) {
    return StayUnitEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      roomRate: model.roomRate,
      perHeadRate: model.perHeadRate,
      maxOccupancy: model.maxOccupancy,
      providerId: model.providerId,
    );
  }

  StayAmenityEntity _mapStayAmenityModelToEntity(StayAmenityModel model) {
    return StayAmenityEntity(
      id: model.id,
      stayServiceProviderId: model.stayServiceProviderId,
      stayUnitId: model.stayUnitId,
      amenityScope: model.amenityScope,
      amenity: model.amenity,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
