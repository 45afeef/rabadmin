import '../entities/cab_entity.dart';
import '../entities/cab_provider_entity.dart';
import '../entities/driver_entity.dart';
import '../entities/stay_amenity_entity.dart';
import '../entities/stay_provider_entity.dart';
import '../entities/stay_unit_entity.dart';

abstract class ServiceProviderRepository {
  // CAB PROVIDERS
  Future<List<CabProviderEntity>> listCabProviders();
  Future<CabProviderEntity> getCabProvider(String providerId);
  Future<CabProviderEntity> createCabProvider({required String providerName});
  Future<CabProviderEntity> updateCabProvider(
    String providerId, {
    String? providerName,
    String? locationId,
  });
  Future<void> deleteCabProvider(String providerId);

  // STAY PROVIDERS
  Future<List<StayProviderEntity>> listStayProviders();
  Future<StayProviderEntity> getStayProvider(String providerId);
  Future<StayProviderEntity> createStayProvider({
    required String providerName,
    required double latitude,
    required double longitude,
    String? propertyType,
    int? roomCount,
  });
  Future<StayProviderEntity> updateStayProvider(
    String providerId, {
    String? providerName,
    String? locationId,
    String? propertyType,
    int? roomCount,
  });
  Future<void> deleteStayProvider(String providerId);

  // CABS
  Future<List<CabEntity>> listCabs(String providerId);
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
  });

  // DRIVERS
  Future<List<DriverEntity>> listDrivers(String providerId);
  Future<DriverEntity> createDriver({
    required String providerId,
    required String profileId,
  });

  Future<DriverEntity> createDriverWithProfile({
    required String providerId,
    required String name,
    required String phoneNumber,
  });

  // STAY UNITS
  Future<List<StayUnitEntity>> listStayUnits(
    String providerId, {
    int? minPrice,
    int? maxPrice,
    List<String>? amenities,
    int? limit,
    int? offset,
  });
  Future<StayUnitEntity> createStayUnit(
    String providerId, {
    required String name,
    String? description,
    int? roomRate,
    int? perHeadRate,
    int? maxOccupancy,
  });

  // STAY AMENITIES
  Future<StayAmenityEntity> addAmenity(
    String providerId,
    String unitId, {
    required String amenity,
    required String amenityScope,
  });
}
