import '../../../service_providers/domain/entities/stay_unit_entity.dart';
import '../repository/query_repository.dart';

class QueryStayUnitsUseCase {
  final QueryRepository repository;

  QueryStayUnitsUseCase(this.repository);

  Future<List<StayUnitEntity>> call({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  }) {
    return repository.queryStayUnits(
      location: location,
      checkIn: checkIn,
      checkOut: checkOut,
      pax: pax,
      maxRate: maxRate,
      amenities: amenities,
      roomCount: roomCount,
    );
  }
}
