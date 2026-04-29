import '../entity/public_stay_provider_entity.dart';
import '../entity/public_stay_unit_entity.dart';
import '../entity/cab_entity.dart';
import '../entity/driver_entity.dart';

abstract class QueryRepository {
  Future<List<PublicStayUnitEntity>> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  });

  Future<List<PublicStayProviderEntity>> queryStayProviders({
    required String locationName,
    num? radiusKm,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  });

  Future<List<CabEntity>> queryCabs({
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

  Future<List<DriverEntity>> queryDrivers({
    String? providerId,
    double? radiusKm,
    int? minCapacity,
  });
}
