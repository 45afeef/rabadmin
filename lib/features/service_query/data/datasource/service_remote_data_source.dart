import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart' show Response, DioException;
import 'package:rab_dio/rab_dio.dart'
    show QueryApi, StayUnitPublic, UnitsList, standardSerializers;

import '../models/public_stay_unit_model.dart';
import 'service_data_source.dart';

class ServiceRemoteDataSource implements ServiceDataSource {
  final QueryApi _queryApi;

  ServiceRemoteDataSource(this._queryApi);

  @override
  Future<List<PublicStayUnitModel>> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    String? stayServiceProviderId,
    int? pax,
    int? minRate,
    int? maxRate,
    List<String>? amenities,
  }) async {
    try {
      Response<UnitsList> response = await _queryApi.queryListStayUnits(
        providerId: stayServiceProviderId,
        minPrice: minRate,
        maxPrice: maxRate,
        amenities: amenities?.toBuiltList(),
      );

      return response.data!.data.map((unit) {
        final unitJson = standardSerializers.serializeWith(
          StayUnitPublic.serializer,
          unit,
        );
        return PublicStayUnitModel.fromJson(unitJson as Map<String, dynamic>);
      }).toList();
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching stay units: $e');
    }
  }
}
