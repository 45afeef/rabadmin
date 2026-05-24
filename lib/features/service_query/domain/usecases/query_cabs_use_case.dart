import '../../../service_providers/domain/entities/cab_entity.dart';
import '../repository/query_repository.dart';

class QueryCabsUseCase {
  final QueryRepository repository;

  QueryCabsUseCase(this.repository);

  Future<List<CabEntity>> call({
    String? providerId,
    String? vehicleType,
    double? radiusKm,
    int? minCapacity,
    int? maxCapacity,
    int? minMinimumRate,
    int? maxMinimumRate,
    int? minPerKmRate,
    int? maxPerKmRate,
    int? minKmForMinimumRate,
    int? maxKmForMinimumRate,
  }) {
    return repository.queryCabs(
      providerId: providerId,
      vehicleType: vehicleType,
      radiusKm: radiusKm,
      minCapacity: minCapacity,
      maxCapacity: maxCapacity,
      minMinimumRate: minMinimumRate,
      maxMinimumRate: maxMinimumRate,
      minPerKmRate: minPerKmRate,
      maxPerKmRate: maxPerKmRate,
      minKmForMinimumRate: minKmForMinimumRate,
      maxKmForMinimumRate: maxKmForMinimumRate,
    );
  }
}
