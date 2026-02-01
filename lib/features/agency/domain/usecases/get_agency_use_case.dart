import '../entities/agency_detail.dart';
import '../repositories/agency_repository.dart';

/// Use case for retrieving detailed information about a specific agency.
///
/// Handles fetching complete agency details including staff members.
class GetAgencyUseCase {
  final AgencyRepository repository;

  GetAgencyUseCase(this.repository);

  /// Execute the get agency operation
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency to retrieve
  ///
  /// Returns the [AgencyDetail] object with full agency information.
  /// Throws an exception if the agency is not found or access is denied.
  Future<AgencyDetail> call({required String agencyId}) =>
      repository.getAgency(agencyId: agencyId);
}
