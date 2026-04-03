import '../../domain/entity/public_stay_unit_entity.dart';
import '../../domain/repository/service_query_repository.dart';
import '../datasource/service_data_source.dart';

class ServiceQueryRepositoryImpl implements ServiceQueryRepository {
  final ServiceDataSource _dataSource;

  ServiceQueryRepositoryImpl(this._dataSource);

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
}
