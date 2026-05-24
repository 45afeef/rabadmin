import '../../../service_providers/domain/entities/cab_entity.dart';
import '../../../service_providers/domain/entities/driver_entity.dart';
import '../../../service_providers/domain/entities/stay_provider_entity.dart';
import '../../../service_providers/domain/entities/stay_unit_entity.dart';

abstract class QueryRepository {
  Future<List<StayUnitEntity>> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  });

  Future<List<StayProviderEntity>> queryStayProviders({
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
