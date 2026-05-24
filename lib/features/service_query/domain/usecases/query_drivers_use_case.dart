import '../../../service_providers/domain/entities/driver_entity.dart';
import '../repository/query_repository.dart';

class QueryDriversUseCase {
  final QueryRepository repository;

  QueryDriversUseCase(this.repository);

  Future<List<DriverEntity>> call({
    String? providerId,
    double? radiusKm,
    int? minCapacity,
  }) {
    return repository.queryDrivers(
      providerId: providerId,
      radiusKm: radiusKm,
      minCapacity: minCapacity,
    );
  }
}
