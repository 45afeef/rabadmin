import '../models/public_stay_provider_model.dart';
import '../models/public_stay_unit_model.dart';
import '../models/cab_model.dart';
import '../models/driver_model.dart';

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
