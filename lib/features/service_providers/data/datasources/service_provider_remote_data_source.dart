import '../models/cab_provider_model.dart';

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
}
