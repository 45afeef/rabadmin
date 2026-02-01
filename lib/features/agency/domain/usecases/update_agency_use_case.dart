import '../entities/agency.dart';
import '../repositories/agency_repository.dart';

/// Use case for updating an existing agency.
///
/// Handles updates to agency information.
/// Superusers can update any agency; owners can update their own.
class UpdateAgencyUseCase {
  final AgencyRepository repository;

  UpdateAgencyUseCase(this.repository);

  /// Execute the update agency operation
  ///
  /// Parameters:
  /// * [agencyId] - The unique identifier of the agency to update
  /// * [name] - Updated agency name
  /// * [description] - Updated agency description
  ///
  /// Returns the updated [Agency] object.
  /// Throws an exception if the update fails or access is denied.
  Future<Agency> call({
    required String agencyId,
    required String name,
    String? description,
  }) => repository.updateAgency(
    agencyId: agencyId,
    name: name,
    description: description,
  );
}
