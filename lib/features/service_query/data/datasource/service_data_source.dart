import '../models/public_stay_unit_model.dart';

abstract class ServiceDataSource {
  Future<List<PublicStayUnitModel>> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  });
}
