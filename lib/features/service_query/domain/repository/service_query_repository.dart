import '../entity/public_stay_unit_entity.dart';

abstract class ServiceQueryRepository {
  Future<List<PublicStayUnitEntity>> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  });
}
