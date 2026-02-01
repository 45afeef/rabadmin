import '../entities/agency_staff.dart';
import '../repositories/agency_repository.dart';

/// Use case for listing staff members of an agency.
///
/// Retrieves all staff members associated with a specific agency.
class ListAgencyStaffsUseCase {
  final AgencyRepository repository;

  ListAgencyStaffsUseCase(this.repository);

  /// Execute the list agency staffs operation
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency
  ///
  /// Returns a list of [AgencyStaff] members.
  /// Throws an exception if the operation fails or access is denied.
  Future<List<AgencyStaff>> call({required String agencyId}) =>
      repository.listAgencyStaffs(agencyId: agencyId);
}
