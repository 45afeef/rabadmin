import '../entities/agency.dart';
import '../repositories/agency_repository.dart';

/// Use case for creating a new agency.
///
/// Handles the creation of agencies with provided details.
/// Only superusers can execute this operation.
class CreateAgencyUseCase {
  final AgencyRepository repository;

  CreateAgencyUseCase(this.repository);

  /// Execute the create agency operation
  ///
  /// Parameters:
  /// * [name] - The name of the new agency
  /// * [description] - Optional description of the agency
  ///
  /// Returns the created [Agency] object.
  /// Throws an exception if creation fails.
  Future<Agency> call({required String name, String? description}) =>
      repository.createAgency(name: name, description: description);
}
