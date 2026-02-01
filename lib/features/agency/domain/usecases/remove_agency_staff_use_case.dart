import '../repositories/agency_repository.dart';

/// Use case for removing a staff member from an agency.
///
/// Handles the removal of staff members from agencies.
class RemoveAgencyStaffUseCase {
  final AgencyRepository repository;

  RemoveAgencyStaffUseCase(this.repository);

  /// Execute the remove agency staff operation
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  /// * [staffId] - The unique identifier of the staff member to remove
  ///
  /// Throws an exception if the operation fails.
  Future<void> call({required String agencyId, required String staffId}) =>
      repository.removeAgencyStaff(agencyId: agencyId, staffId: staffId);
}
