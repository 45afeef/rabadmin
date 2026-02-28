import 'package:flutter_test/flutter_test.dart';
import 'package:rabadmin/features/auth/domain/repositories/auth_repository.dart';
import 'package:rabadmin/features/profile/domain/entities/profile.dart';
import 'package:rabadmin/features/profile/domain/repository/profile_repository.dart';
import 'package:rabadmin/features/service_providers/data/datasources/service_provider_remote_data_source.dart';
import 'package:rabadmin/features/service_providers/data/models/cab_model.dart';
import 'package:rabadmin/features/service_providers/data/models/driver_model.dart';
import 'package:rabadmin/features/service_providers/data/repositories/service_provider_repository_impl.dart';
import 'package:rabadmin/features/service_providers/data/models/cab_provider_model.dart';

class _FakeRemote implements ServiceProviderRemoteDataSource {
  String? lastCreatedBy;
  String? lastName;

  @override
  Future<void> deleteCabProvider(String providerId) async {
    throw UnimplementedError();
  }

  @override
  Future<CabProviderModel> getCabProvider(String providerId) {
    throw UnimplementedError();
  }

  @override
  Future<List<CabProviderModel>> listCabProviders() {
    throw UnimplementedError();
  }

  @override
  Future<CabProviderModel> createCabProvider({
    required String providerName,
    required String createdBy,
  }) async {
    lastName = providerName;
    lastCreatedBy = createdBy;
    return CabProviderModel(
      id: 'id1',
      name: providerName,
      createdBy: createdBy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      ownerId: createdBy,
    );
  }

  @override
  Future<CabProviderModel> updateCabProvider(
    String providerId, {
    String? providerName,
    String? locationId,
  }) {
    throw UnimplementedError();
  }

  @override
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
  }) {
    // TODO: implement createCab
    throw UnimplementedError();
  }

  @override
  Future<DriverModel> createDriver({
    required String providerId,
    required String profileId,
  }) {
    
    // TODO: implement createDriver
    throw UnimplementedError();
  }

  @override
  Future<List<CabModel>> listCabs(String providerId) {
    // TODO: implement listCabs
    throw UnimplementedError();
  }

  @override
  Future<List<DriverModel>> listDrivers(String providerId) {
    // TODO: implement listDrivers
    throw UnimplementedError();
  }
}

class _FakeAuth implements AuthRepository {
  final String id;
  _FakeAuth(this.id);
  @override
  Future<void> login({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> validateToken() {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getCurrentUserId() async => id;
}

class _FakeProfile implements ProfileRepository {
  @override
  Future<ProfileEntity> createProfile({
    
    required String name,
    required String createdByUserId,
    required String phoneNumber,
  }) {
    return Future.value(
      ProfileEntity(
        id: 'profile1',
        userId: null,
        name: name,
        createdByUserId: createdByUserId,
        primaryPhoneNumber: phoneNumber,
        secondaryPhoneNumber: null,
        primaryEmail: null,
        secondaryEmail: null,
        dateOfBirth: null,
        bio: null,
        address: null,
        city: null,
        state: null,
        zipCode: null,
        country: null,
        lastName: null,
        middleName: null,
        profilePicture: null,
      ),
    );
  }
}

void main() {
  test('createCabProvider passes current user id as createdBy', () async {
    final remote = _FakeRemote();
    final auth = _FakeAuth('user42');
    final profile = _FakeProfile();

    final repo = ServiceProviderRepositoryImpl(
      remoteDataSource: remote,
      authRepository: auth,
      profileRepository: profile,
    );
    final entity = await repo.createCabProvider(providerName: 'taxi');
    expect(remote.lastCreatedBy, 'user42');
    expect(entity.createdBy, 'user42');
  });
}
