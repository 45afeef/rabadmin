import '../entities/agency_staff.dart';
import '../repositories/agency_repository.dart';

/// Use case for updating a staff member's role or information.
///
/// Handles modifications to staff member details.
class UpdateAgencyStaffUseCase {
  final AgencyRepository repository;

  UpdateAgencyStaffUseCase(this.repository);

  /// Execute the update agency staff operation
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  /// * [staffId] - The unique identifier of the staff member
  /// * [role] - The updated role of the staff member
  ///
  /// Returns the updated [AgencyStaff] object.
  /// Throws an exception if the operation fails.
  Future<AgencyStaff> call({
    required String agencyId,
    required String staffId,
    required String role,
  }) => repository.updateAgencyStaff(
    agencyId: agencyId,
    staffId: staffId,
    role: role,
  );
}
