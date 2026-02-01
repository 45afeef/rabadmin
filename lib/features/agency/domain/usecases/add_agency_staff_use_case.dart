import '../entities/agency_staff.dart';
import '../repositories/agency_repository.dart';

/// Use case for adding a staff member to an agency.
///
/// Handles the assignment of staff members to agencies.
class AddAgencyStaffUseCase {
  final AgencyRepository repository;

  AddAgencyStaffUseCase(this.repository);

  /// Execute the add agency staff operation
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  /// * [userId] - The unique identifier of the user to add as staff
  /// * [role] - The role of the staff member
  ///
  /// Returns the created [AgencyStaff] object.
  /// Throws an exception if the operation fails.
  Future<AgencyStaff> call({
    required String agencyId,
    required String userId,
    required String role,
  }) =>
      repository.addAgencyStaff(agencyId: agencyId, userId: userId, role: role);
}
