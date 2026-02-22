import 'package:flutter_test/flutter_test.dart';
import 'package:rabadmin/features/auth/domain/repositories/auth_repository.dart';
import 'package:rabadmin/features/service_providers/data/datasources/service_provider_remote_data_source.dart';
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

void main() {
  test('createCabProvider passes current user id as createdBy', () async {
    final remote = _FakeRemote();
    final auth = _FakeAuth('user42');
    final repo = ServiceProviderRepositoryImpl(remote, auth);
    final entity = await repo.createCabProvider(providerName: 'taxi');
    expect(remote.lastCreatedBy, 'user42');
    expect(entity.createdBy, 'user42');
  });
}
