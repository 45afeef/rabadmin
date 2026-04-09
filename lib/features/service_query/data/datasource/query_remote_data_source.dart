import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart' show Response, DioException;
import 'package:rab_dio/rab_dio.dart'
    show
        QueryApi,
        StayProviderPublic,
        StayUnitPublic,
        UnitsList,
        standardSerializers,
        CabPublic,
        DriverPublic,
        VehicleType;

import '../models/public_stay_provider_model.dart';
import '../models/public_stay_unit_model.dart';
import '../models/cab_model.dart';
import '../models/driver_model.dart';
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
    int? roomCount,
  }) async {
    try {
      Response<UnitsList> response = await _queryApi.queryListStayUnits(
        providerId: stayServiceProviderId,
        minPrice: minRate,
        maxPrice: maxRate,
        amenities: amenities?.toBuiltList(),
        paxCount: pax,
        roomCount: roomCount,
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
    int? roomCount,
  }) async {
    try {
      final response = await _queryApi.queryListStayProviders(
        locationId: locationId,
        maxPrice: maxRate,
        limit: 10,
        paxCount: pax! > 0 ? pax : null,
        amenities: amenities?.toBuiltList(),
        roomCount: roomCount,
      );

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

  @override
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
  }) async {
    try {
      final response = await _queryApi.queryQueryCabs(
        providerId: providerId,
        vehicleType: vehicleType != null
            ? VehicleType.valueOf(vehicleType)
            : null,
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

      return response.data!.data.map((cab) {
        final cabJson = standardSerializers.serializeWith(
          CabPublic.serializer,
          cab,
        );
        return CabModel.fromJson(cabJson as Map<String, dynamic>);
      }).toList();
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching cabs: $e');
    }
  }

  @override
  Future<List<DriverModel>> queryDrivers({
    String? providerId,
    double? radiusKm,
    int? minCapacity,
  }) async {
    try {
      final response = await _queryApi.queryQueryDrivers(
        providerId: providerId,
        radiusKm: radiusKm,
        minCapacity: minCapacity,
      );

      return response.data!.data.map((driver) {
        final driverJson = standardSerializers.serializeWith(
          DriverPublic.serializer,
          driver,
        );
        return DriverModel.fromJson(driverJson as Map<String, dynamic>);
      }).toList();
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching drivers: $e');
    }
  }
}
