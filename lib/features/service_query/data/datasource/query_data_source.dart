import '../../../service_providers/data/models/cab_model.dart';
import '../../../service_providers/data/models/driver_model.dart';
import '../../../service_providers/data/models/stay_provider_model.dart';
import '../../../service_providers/data/models/stay_unit_model.dart';


abstract class QueryDataSource {
  Future<List<StayUnitModel>> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  });

  Future<List<StayProviderModel>> queryStayProviders({
    required String locationName,
    num? radiusKm,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  });

  Future<List<CabModel>> queryCabs({
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
  });

  Future<List<DriverModel>> queryDrivers({
    String? providerId,
    double? radiusKm,
    int? minCapacity,
  });
}
