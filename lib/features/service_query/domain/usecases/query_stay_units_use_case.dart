import '../repository/query_repository.dart';
import '../entity/public_stay_unit_entity.dart';

class QueryStayUnitsUseCase {
  final QueryRepository repository;

  QueryStayUnitsUseCase(this.repository);

  Future<List<PublicStayUnitEntity>> call({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  }) {
    return repository.queryStayUnits(
      location: location,
      checkIn: checkIn,
      checkOut: checkOut,
      pax: pax,
      maxRate: maxRate,
      amenities: amenities,
    );
  }
}
