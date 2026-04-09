import '../../domain/entity/public_stay_provider_entity.dart';
import '../../domain/entity/public_stay_unit_entity.dart';
import '../../domain/entity/cab_entity.dart';
import '../../domain/entity/driver_entity.dart';
import '../../domain/repository/query_repository.dart';
import '../datasource/query_data_source.dart';

class QueryRepositoryImpl implements QueryRepository {
  final QueryDataSource _dataSource;

  QueryRepositoryImpl(this._dataSource);

  @override
  Future<List<PublicStayUnitEntity>> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  }) {
    return _dataSource.queryStayUnits(
      location: location,
      checkIn: checkIn,
      checkOut: checkOut,
      pax: pax,
      maxRate: maxRate,
      amenities: amenities,
      roomCount: roomCount,
    );
  }

  @override
  Future<List<PublicStayProviderEntity>> queryStayProviders({
    String? locationId,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  }) {
    return _dataSource.queryStayProviders(
      locationId: locationId,
      checkIn: checkIn,
      checkOut: checkOut,
      pax: pax,
      maxRate: maxRate,
      amenities: amenities,
      roomCount: roomCount,
    );
  }

  @override
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
  }) {
    return _dataSource.queryCabs(
      providerId: providerId,
      vehicleType: vehicleType,
      radiusKm: radiusKm,
      minCapacity: minCapacity,
      maxCapacity: maxCapacity,
      minMinimumRate: minMinimumRate,
      maxMinimumRate: maxMinimumRate,
      minPerKmRate: minPerKmRate,
      maxPerKmRate: maxPerKmRate,
      minKmForMinimumRate: minKmForMinimumRate,
      maxKmForMinimumRate: maxKmForMinimumRate,
    );
  }

  @override
  Future<List<DriverEntity>> queryDrivers({
    String? providerId,
    double? radiusKm,
    int? minCapacity,
  }) {
    return _dataSource.queryDrivers(
      providerId: providerId,
      radiusKm: radiusKm,
      minCapacity: minCapacity,
    );
  }
}
