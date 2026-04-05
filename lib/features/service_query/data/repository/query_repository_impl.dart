import '../../domain/entity/public_stay_provider_entity.dart';
import '../../domain/entity/public_stay_unit_entity.dart';
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
  }) {
    return _dataSource.queryStayUnits(
      location: location,
      checkIn: checkIn,
      checkOut: checkOut,
      pax: pax,
      maxRate: maxRate,
      amenities: amenities,
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
  }) {
    return _dataSource.queryStayProviders(
      locationId: locationId,
      checkIn: checkIn,
      checkOut: checkOut,
      pax: pax,
      maxRate: maxRate,
      amenities: amenities,
    );
  }
}
