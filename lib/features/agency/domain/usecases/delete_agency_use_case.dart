import '../repositories/agency_repository.dart';

/// Use case for deleting an agency.
///
/// Handles the removal of agencies from the system.
/// Only superusers can delete agencies.
class DeleteAgencyUseCase {
  final AgencyRepository repository;

  DeleteAgencyUseCase(this.repository);

  /// Execute the delete agency operation
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency to delete
  ///
  /// Throws an exception if deletion fails or access is denied.
  Future<void> call({required String agencyId}) =>
      repository.deleteAgency(agencyId: agencyId);
}
