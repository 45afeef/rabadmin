import '../entity/public_stay_provider_entity.dart';
import '../repository/query_repository.dart';

class QueryStayProvidersUseCase {
  final QueryRepository repository;

  QueryStayProvidersUseCase(this.repository);

  Future<List<PublicStayProviderEntity>> call({
    required String locationName,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  }) {
    return repository.queryStayProviders(
      locationName: locationName,
      checkIn: checkIn,
      checkOut: checkOut,
      pax: pax,
      maxRate: maxRate,
      amenities: amenities,
      roomCount: roomCount,
    );
  }
}
