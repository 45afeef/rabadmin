import '../entities/agency.dart';
import '../entities/agency_detail.dart';
import '../entities/agency_staff.dart';

/// Abstract repository contract for agency-related operations.
///
/// Defines the interface for all agency business logic operations.
/// Implementation details are handled by concrete repositories in the data layer.
abstract class AgencyRepository {
  /// Retrieve a list of all agencies.
  ///
  /// Only accessible to superusers.
  ///
  /// Throws an exception if the operation fails.
  Future<List<Agency>> listAgencies();

  /// Retrieve detailed information about a specific agency.
  ///
  /// Accessible by superuser, agency owner, or agency staff.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  ///
  /// Throws an exception if the agency is not found or access is denied.
  Future<AgencyDetail> getAgency({required String agencyId});

  /// Create a new agency.
  ///
  /// Only superusers can create agencies.
  ///
  /// Parameters:
  /// * [name] - The name of the new agency
  /// * [description] - Optional description of the agency
  ///
  /// Returns the created [Agency] object.
  /// Throws an exception if creation fails.
  Future<Agency> createAgency({required String name, String? description});

  /// Update an existing agency.
  ///
  /// Superusers can update any agency; owners can update their own agency.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency to update
  /// * [name] - Updated agency name
  /// * [description] - Updated agency description
  ///
  /// Returns the updated [Agency] object.
  /// Throws an exception if the update fails or access is denied.
  Future<Agency> updateAgency({
    required String agencyId,
    required String name,
    String? description,
  });

  /// Delete an agency.
  ///
  /// Only superusers can delete agencies.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency to delete
  ///
  /// Throws an exception if deletion fails or access is denied.
  Future<void> deleteAgency({required String agencyId});

  /// Retrieve a list of staff members for a specific agency.
  ///
  /// Accessible by superuser, agency owner, or agency staff.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  ///
  /// Returns a list of [AgencyStaff] members.
  /// Throws an exception if the operation fails or access is denied.
  Future<List<AgencyStaff>> listAgencyStaffs({required String agencyId});

  /// Add a staff member to an agency.
  ///
  /// Only agency owner or superuser can add staff.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  /// * [userId] - The unique identifier of the user to add as staff
  /// * [role] - The role of the staff member (e.g., 'manager', 'staff')
  ///
  /// Returns the created [AgencyStaff] object.
  /// Throws an exception if the operation fails or access is denied.
  Future<AgencyStaff> addAgencyStaff({
    required String agencyId,
    required String userId,
    required String role,
  });

  /// Update a staff member's role or information.
  ///
  /// Only agency owner or superuser can update staff.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  /// * [staffId] - The unique identifier of the staff member
  /// * [role] - The updated role of the staff member
  ///
  /// Returns the updated [AgencyStaff] object.
  /// Throws an exception if the operation fails or access is denied.
  Future<AgencyStaff> updateAgencyStaff({
    required String agencyId,
    required String staffId,
    required String role,
  });

  /// Remove a staff member from an agency.
  ///
  /// Only agency owner or superuser can remove staff.
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  /// * [staffId] - The unique identifier of the staff member to remove
  ///
  /// Throws an exception if the operation fails or access is denied.
  Future<void> removeAgencyStaff({
    required String agencyId,
    required String staffId,
  });
}
