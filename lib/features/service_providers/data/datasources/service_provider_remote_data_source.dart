import '../models/cab_model.dart';
import '../models/cab_provider_model.dart';
import '../models/driver_model.dart';
import '../models/stay_amenity_model.dart';
import '../models/stay_provider_model.dart';
import '../models/stay_unit_model.dart';

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

  // STAY PROVIDERS
  Future<List<StayProviderModel>> listStayProviders();
  Future<StayProviderModel> getStayProvider(String providerId);
  Future<StayProviderModel> createStayProvider({
    required String providerName,
    required String createdBy,
    String? locationId,
    String? propertyType,
    int? roomCount,
  });
  Future<StayProviderModel> updateStayProvider(
    String providerId, {
    String? providerName,
    String? locationId,
    String? propertyType,
    int? roomCount,
  });
  Future<void> deleteStayProvider(String providerId);

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

  // STAY UNITS
  Future<List<StayUnitModel>> listStayUnits(
    String providerId, {
    int? minPrice,
    int? maxPrice,
    String? amenity,
    int? limit,
    int? offset,
  });
  Future<StayUnitModel> createStayUnit(
    String providerId, {
    required String name,
    String? description,
    int? roomRate,
    int? perHeadRate,
    int? maxOccupancy,
  });

  // STAY AMENITIES
  Future<StayAmenityModel> addAmenity(
    String providerId,
    String unitId, {
    required String amenity,
    required String amenityScope,
  });
}
