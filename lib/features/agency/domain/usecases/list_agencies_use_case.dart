import '../entities/agency.dart';
import '../repositories/agency_repository.dart';

/// Use case for listing all agencies.
///
/// Orchestrates the retrieval of all agencies from the repository.
/// Follows the single responsibility principle with a focused purpose.
class ListAgenciesUseCase {
  final AgencyRepository repository;

  ListAgenciesUseCase(this.repository);

  /// Execute the list agencies operation
  ///
  /// Returns a list of all [Agency] objects.
  /// Throws an exception if the operation fails.
  Future<List<Agency>> call() => repository.listAgencies();
}
