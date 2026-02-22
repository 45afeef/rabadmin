import '../models/cab_model.dart';
import '../models/cab_provider_model.dart';
import '../models/driver_model.dart';

abstract class ServiceProviderRemoteDataSource {
  // CAB PROVIDERS
  Future<List<CabProviderModel>> listCabProviders();
  Future<CabProviderModel> getCabProvider(String providerId);
  Future<CabProviderModel> createCabProvider({
    required String providerName,
    required String createdBy,
  });
  Future<CabProviderModel> updateCabProvider(
    String providerId, {
    String? providerName,
    String? locationId,
  });
  Future<void> deleteCabProvider(String providerId);

  // CABS
  Future<List<CabModel>> listCabs(String providerId);
  Future<CabModel> createCab(
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
  Future<List<DriverModel>> listDrivers(String providerId);
  Future<DriverModel> createDriver({
    required String providerId,
    required String profileId,
  });
}
