import 'package:dio/dio.dart';
import 'package:rab_dio/rab_dio.dart'
    show
        AgenciesApi,
        AgencyCreate,
        AgencyUpdate,
        AgencyStaffCreate,
        AgencyStaffUpdate;

import 'package:rabadmin/features/agency/data/models/agency_detail_model.dart';

import '../models/agency_model.dart';
import '../models/agency_staff_model.dart';

/// Abstract contract for agency remote data source operations.
///
/// Defines the interface for all remote API operations related to agencies.
abstract class AgencyRemoteDataSource {
  /// Fetch a list of all agencies from the remote API.
  ///
  /// Returns a list of [AgencyModel] objects.
  /// Throws a [DioException] if the API call fails.
  Future<List<AgencyModel>> listAgencies();

  /// Fetch detailed information about a specific agency from the remote API.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  ///
  /// Returns an [AgencyDetailModel] with agency details and staff.
  /// Throws a [DioException] if the API call fails.
  Future<AgencyDetailModel> getAgency({required String agencyId});

  /// Create a new agency via the remote API.
  ///
  /// Parameters:
  /// * [name] - The name of the new agency
  /// * [description] - Optional description of the agency
  ///
  /// Returns the created [AgencyModel].
  /// Throws a [DioException] if the API call fails.
  Future<AgencyModel> createAgency({required String name, String? description});

  /// Update an existing agency via the remote API.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency to update
  /// * [name] - Updated agency name
  /// * [description] - Updated agency description
  ///
  /// Returns the updated [AgencyModel].
  /// Throws a [DioException] if the API call fails.
  Future<AgencyModel> updateAgency({
    required String agencyId,
    required String name,
    String? description,
  });

  /// Delete an agency via the remote API.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency to delete
  ///
  /// Throws a [DioException] if the API call fails.
  Future<void> deleteAgency({required String agencyId});

  /// Fetch a list of staff members for a specific agency.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  ///
  /// Returns a list of [AgencyStaffModel] objects.
  /// Throws a [DioException] if the API call fails.
  Future<List<AgencyStaffModel>> listAgencyStaffs({required String agencyId});

  /// Add a staff member to an agency via the remote API.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  /// * [userId] - The unique identifier of the user to add as staff
  /// * [role] - The role of the staff member
  ///
  /// Returns the created [AgencyStaffModel].
  /// Throws a [DioException] if the API call fails.
  Future<AgencyStaffModel> addAgencyStaff({
    required String agencyId,
    required String userId,
    required String role,
  });

  /// Update a staff member's role via the remote API.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  /// * [staffId] - The unique identifier of the staff member
  /// * [role] - The updated role
  ///
  /// Returns the updated [AgencyStaffModel].
  /// Throws a [DioException] if the API call fails.
  Future<AgencyStaffModel> updateAgencyStaff({
    required String agencyId,
    required String staffId,
    required String role,
  });

  /// Remove a staff member from an agency via the remote API.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  /// * [staffId] - The unique identifier of the staff member to remove
  ///
  /// Throws a [DioException] if the API call fails.
  Future<void> removeAgencyStaff({
    required String agencyId,
    required String staffId,
  });
}

/// Implementation of [AgencyRemoteDataSource] using the AgenciesApi from rab_dio.
///
/// Provides concrete implementations of all remote agency operations
/// by delegating to the AgenciesApi client.
class AgenciesRemoteDataSource implements AgencyRemoteDataSource {
  final AgenciesApi api;

  AgenciesRemoteDataSource(this.api);

  @override
  Future<List<AgencyModel>> listAgencies() async {
    try {
      final response = await api.agenciesListAgencies();

      return response.data
              ?.map(
                (agency) =>
                    AgencyModel.fromJson(agency as Map<String, dynamic>),
              )
              .toList() ??
          [];
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to list agencies: ${e.toString()}');
    }
  }

  @override
  Future<AgencyDetailModel> getAgency({required String agencyId}) async {
    try {
      final response = await api.agenciesGetAgency(agencyId: agencyId);

      if (response.data == null) {
        throw Exception('Agency not found');
      }

      return AgencyDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to get agency: ${e.toString()}');
    }
  }

  @override
  Future<AgencyModel> createAgency({
    required String name,
    String? description,
  }) async {
    try {
      // Use the rab_dio generated model for the API request
      // Note: AgencyCreate uses built_value builders, so we use the builder pattern
      // TODO: Verify field names match the actual rab_dio AgencyCreate model
      // The fields might be different (e.g., camelCase vs snake_case)
      final response = await api.agenciesCreateAgency(
        agencyCreate: AgencyCreate(
          (b) => b
            ..name = name
            ..description = description,
        ),
      );

      if (response.data == null) {
        throw Exception('Failed to create agency');
      }

      return AgencyModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to create agency: ${e.toString()}');
    }
  }

  @override
  Future<AgencyModel> updateAgency({
    required String agencyId,
    required String name,
    String? description,
  }) async {
    try {
      final response = await api.agenciesUpdateAgency(
        agencyId: agencyId,
        agencyUpdate: AgencyUpdate(
          (b) => b
            ..name = name
            ..description = description,
        ),
      );

      if (response.data == null) {
        throw Exception('Failed to update agency');
      }

      return AgencyModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to update agency: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAgency({required String agencyId}) async {
    try {
      await api.agenciesDeleteAgency(agencyId: agencyId);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to delete agency: ${e.toString()}');
    }
  }

  @override
  Future<List<AgencyStaffModel>> listAgencyStaffs({
    required String agencyId,
  }) async {
    try {
      final response = await api.agenciesListAgencyStaffs(agencyId: agencyId);

      return response.data
              ?.map(
                (staff) =>
                    AgencyStaffModel.fromJson(staff as Map<String, dynamic>),
              )
              .toList() ??
          [];
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to list agency staffs: ${e.toString()}');
    }
  }

  @override
  Future<AgencyStaffModel> addAgencyStaff({
    required String agencyId,
    required String userId,
    required String role,
  }) async {
    try {
      final response = await api.agenciesCreateAgencyStaff(
        agencyId: agencyId,
        agencyStaffCreate: AgencyStaffCreate(
          (b) => b
            ..user_id = userId
            ..role = role,
        ),
      );

      if (response.data == null) {
        throw Exception('Failed to add staff');
      }

      return AgencyStaffModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to add agency staff: ${e.toString()}');
    }
  }

  @override
  Future<AgencyStaffModel> updateAgencyStaff({
    required String agencyId,
    required String staffId,
    required String role,
  }) async {
    try {
      final response = await api.agenciesUpdateAgencyStaff(
        agencyId: agencyId,
        staffId: staffId,
        agencyStaffUpdate: AgencyStaffUpdate((b) => b..role = role),
      );

      if (response.data == null) {
        throw Exception('Failed to update staff');
      }

      return AgencyStaffModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to update agency staff: ${e.toString()}');
    }
  }

  @override
  Future<void> removeAgencyStaff({
    required String agencyId,
    required String staffId,
  }) async {
    try {
      await api.agenciesDeleteAgencyStaff(agencyId: agencyId, staffId: staffId);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to remove agency staff: ${e.toString()}');
    }
  }
}
