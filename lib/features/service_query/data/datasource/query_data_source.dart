import '../models/public_stay_provider_model.dart';
import '../models/public_stay_unit_model.dart';

abstract class QueryDataSource {
  Future<List<PublicStayUnitModel>> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  });

  Future<List<PublicStayProviderModel>> queryStayProviders({
    String? locationId,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  });
}
