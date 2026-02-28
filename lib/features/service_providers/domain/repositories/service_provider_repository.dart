import '../entities/cab_entity.dart';
import '../entities/cab_provider_entity.dart';
import '../entities/driver_entity.dart';

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
}
