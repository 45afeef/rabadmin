import '../entity/public_stay_provider_entity.dart';
import '../entity/public_stay_unit_entity.dart';

abstract class QueryRepository {
  Future<List<PublicStayUnitEntity>> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  });

  Future<List<PublicStayProviderEntity>> queryStayProviders({
    String? locationId,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  });
}
