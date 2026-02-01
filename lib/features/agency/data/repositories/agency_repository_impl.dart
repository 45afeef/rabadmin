import '../../domain/entities/agency.dart';
import '../../domain/entities/agency_detail.dart';
import '../../domain/entities/agency_staff.dart';
import '../../domain/repositories/agency_repository.dart';
import '../datasources/agency_remote_data_source.dart';

/// Implementation of [AgencyRepository].
///
/// Provides concrete implementations of all agency-related business operations.
/// This class acts as a bridge between the domain layer and data layer,
/// handling the logic of which data source to use for each operation.
class AgencyRepositoryImpl implements AgencyRepository {
  final AgencyRemoteDataSource remoteDataSource;

  AgencyRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Agency>> listAgencies() async {
    try {
      final models = await remoteDataSource.listAgencies();
      return models.map((model) => model.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AgencyDetail> getAgency({required String agencyId}) async {
    try {
      final model = await remoteDataSource.getAgency(agencyId: agencyId);
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Agency> createAgency({
    required String name,
    String? description,
  }) async {
    try {
      final model = await remoteDataSource.createAgency(
        name: name,
        description: description,
      );
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Agency> updateAgency({
    required String agencyId,
    required String name,
    String? description,
  }) async {
    try {
      final model = await remoteDataSource.updateAgency(
        agencyId: agencyId,
        name: name,
        description: description,
      );
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAgency({required String agencyId}) async {
    try {
      await remoteDataSource.deleteAgency(agencyId: agencyId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AgencyStaff>> listAgencyStaffs({required String agencyId}) async {
    try {
      final models = await remoteDataSource.listAgencyStaffs(
        agencyId: agencyId,
      );
      return models.map((model) => model.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AgencyStaff> addAgencyStaff({
    required String agencyId,
    required String userId,
    required String role,
  }) async {
    try {
      final model = await remoteDataSource.addAgencyStaff(
        agencyId: agencyId,
        userId: userId,
        role: role,
      );
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AgencyStaff> updateAgencyStaff({
    required String agencyId,
    required String staffId,
    required String role,
  }) async {
    try {
      final model = await remoteDataSource.updateAgencyStaff(
        agencyId: agencyId,
        staffId: staffId,
        role: role,
      );
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeAgencyStaff({
    required String agencyId,
    required String staffId,
  }) async {
    try {
      await remoteDataSource.removeAgencyStaff(
        agencyId: agencyId,
        staffId: staffId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
