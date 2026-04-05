import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart' show Response, DioException;
import 'package:rab_dio/rab_dio.dart'
    show
        QueryApi,
        StayProviderPublic,
        StayUnitPublic,
        UnitsList,
        standardSerializers;

import '../models/public_stay_provider_model.dart';
import '../models/public_stay_unit_model.dart';
import 'query_data_source.dart';

class QueryRemoteDataSource implements QueryDataSource {
  final QueryApi _queryApi;

  QueryRemoteDataSource(this._queryApi);

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
        paxCount: pax,
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

  @override
  Future<List<PublicStayProviderModel>> queryStayProviders({
    String? locationId,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  }) async {
    try {
      final response = await _queryApi.queryListStayProviders(
        locationId: locationId,
        maxPrice: maxRate,
        limit: 10,
        paxCount: pax! > 0 ? pax : null,
        amenities: amenities?.toBuiltList(),
      );

      print('API Response: ${response.data}');

      return response.data!.data.map((provider) {
        final providerJson = standardSerializers.serializeWith(
          StayProviderPublic.serializer,
          provider,
        );
        return PublicStayProviderModel.fromJson(
          providerJson as Map<String, dynamic>,
        );
      }).toList();
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching stay providers: $e');
    }
  }
}
