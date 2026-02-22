import '../entities/cab_provider_entity.dart';

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
}
