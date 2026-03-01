import 'package:dio/dio.dart' show DioException;
import 'package:one_of/any_of.dart';
import 'package:rab_dio/rab_dio.dart';
import '../models/cab_model.dart';
import '../models/cab_provider_model.dart';
import '../models/driver_model.dart';
import '../models/stay_amenity_model.dart';
import '../models/stay_provider_model.dart';
import '../models/stay_unit_model.dart';
import 'service_provider_remote_data_source.dart';

class ServiceProviderRemoteDataSourceImpl
    extends ServiceProviderRemoteDataSource {
  final ProvidersApi providersApi;
  final ProvidersCabApi cabApi;
  final ProvidersStayApi stayApi;

  ServiceProviderRemoteDataSourceImpl(
    this.providersApi,
    this.cabApi,
    this.stayApi,
  );

  // ===== CAB PROVIDERS =====
  @override
  Future<List<CabProviderModel>> listCabProviders() async {
    try {
      final response = await providersApi.providersListProviders();

      final providers = response.data!
          .asList()
          // TODO : handle pagination when the API supports it; for now we just pull all providers and filter client-side
          // TOOD : this filtering should ideally be done server-side via a query param, but the API doesn't currently support that. For now we can filter client-side to avoid parsing unrelated providers into our CabProviderModel.
          // also note that the generated types don't handle the AnyOf in the response, so we have to do some manual parsing here.
          .where((p) => p.anyOf.valueTypes.contains(CabProviderPublic))
          .map((p) {
            final cabJson =
                standardSerializers.serializeWith(
                      CabProviderPublic.serializer,
                      p.anyOf.values[0] as CabProviderPublic,
                    )
                    as Map<String, dynamic>;
            final cabProviderModel = CabProviderModel.fromJson(cabJson);
            return cabProviderModel;
          })
          .toList();
      return providers;
    } on DioException catch (e) {
      throw Exception('Failed to list cab providers: ${e.message}');
    }
  }

  @override
  Future<CabProviderModel> getCabProvider(String providerId) async {
    // TODO: implement using providersApi
    throw UnimplementedError();
  }

  @override
  Future<CabProviderModel> createCabProvider({
    required String providerName,
    // TODO : ideally the API would handle setting the createdBy field based on the authenticated user, rather than requiring the client to pass it in; this is a potential source of bugs if the client and server get out of sync on how this field is set. For now we have to pass it in because the generated types require it, but this is something to consider improving in the future.
    required String createdBy,
  }) async {
    try {
      // build request payload using rab_dio generated models
      final request = ProviderIn((b) {
        b.anyOf = AnyOf1<CabProviderCreate>(
          value: CabProviderCreate((cb) {
            cb
              ..providerName = providerName
              // ownerId is required by the generated type; use createdBy as a placeholder
              ..ownerId = createdBy
              ..createdBy = createdBy
              ..providerType = CabProviderCreateProviderTypeEnum.CAB;
          }),
        );
      });

      final response = await providersApi.providersCreateProvider(
        providerIn: request,
      );

      // response.data contains a built_value object wrapping an AnyOf
      if (response.data == null) {
        throw Exception('Failed to create cab provider: empty response');
      }

      // extract the CabProviderPublic from the AnyOf
      final anyOf = response.data!.anyOf;
      final cabPublic = anyOf.values[0] as CabProviderPublic;

      // convert to a plain map using the standard serializers
      final cabJson =
          standardSerializers.serializeWith(
                CabProviderPublic.serializer,
                cabPublic,
              )
              as Map<String, dynamic>;

      return CabProviderModel.fromJson(cabJson);
    } on DioException catch (e) {
      throw Exception('Failed to create cab provider: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create cab provider: ${e.toString()}');
    }
  }

  @override
  Future<CabProviderModel> updateCabProvider(
    String providerId, {
    String? providerName,
    String? locationId,
  }) async {
    // TODO: implement using providersApi
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCabProvider(String providerId) async {
    // TODO: implement using providersApi
    throw UnimplementedError();
  }

  // // ===== STAY PROVIDERS =====
  @override
  Future<List<StayProviderModel>> listStayProviders() async {
    // fetch stay providers using providersApi, similar to listCabProviders but filtering for StayProviderPublic and mapping to StayProviderModel
    try {
      final response = await providersApi.providersListProviders();

      final providers = response.data!
          .asList()
          // TODO : handle pagination when the API supports it; for now we just pull all providers and filter client-side
          // TOOD : this filtering should ideally be done server-side via a query param, but the API doesn't currently support that. For now we can filter client-side to avoid parsing unrelated providers into our StayProviderModel.
          // also note that the generated types don't handle the AnyOf in the response, so we have to do some manual parsing here.
          .where((p) => p.anyOf.valueTypes.contains(StayProviderPublic))
          .map((p) {
            final stayJson =
                standardSerializers.serializeWith(
                      StayProviderPublic.serializer,
                      p.anyOf.values[1] as StayProviderPublic,
                    )
                    as Map<String, dynamic>;
            final stayProviderModel = StayProviderModel.fromJson(stayJson);
            return stayProviderModel;
          })
          .toList();
      return providers;
    } on DioException catch (e) {
      throw Exception('Failed to list stay providers: ${e.message}');
    } catch (e) {
      throw Exception('Failed to list stay providers: ${e.toString()}');
    }
  }

  @override
  Future<StayProviderModel> getStayProvider(String providerId) async {
    // TODO: implement using providersApi
    throw UnimplementedError();
  }

  @override
  Future<StayProviderModel> createStayProvider({
    required String providerName,
    required String createdBy,
    String? locationId,
    String? propertyType,
    int? roomCount,
  }) async {
    try {
      // build request payload using rab_dio generated models
      final request = ProviderIn((b) {
        b.anyOf = AnyOf1<StayProviderCreate>(
          value: StayProviderCreate((sb) {
            sb
              ..providerName = providerName
              ..createdBy = createdBy
              ..ownerId =
                  createdBy // ownerId is required by the generated type; use createdBy as a placeholder
              ..providerType = StayProviderCreateProviderTypeEnum.STAY
              ..locationId = locationId
              ..propertyType = propertyType
              ..roomCount = roomCount;
          }),
        );
      });

      final response = await providersApi.providersCreateProvider(
        providerIn: request,
      );

      if (response.data == null) {
        throw Exception('Failed to create stay provider: empty response');
      }

      // extract the StayProviderPublic from the AnyOf
      final anyOf = response.data!.anyOf;
      final stayPublic = anyOf.values[1] as StayProviderPublic;

      // convert to a plain map using the standard serializers
      final stayJson =
          standardSerializers.serializeWith(
                StayProviderPublic.serializer,
                stayPublic,
              )
              as Map<String, dynamic>;

      return StayProviderModel.fromJson(stayJson);
    } on DioException catch (e) {
      throw Exception('Failed to create stay provider: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create stay provider: ${e.toString()}');
    }
  }

  @override
  Future<StayProviderModel> updateStayProvider(
    String providerId, {
    String? providerName,
    String? locationId,
    String? propertyType,
    int? roomCount,
  }) async {
    // TODO: implement using providersApi
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStayProvider(String providerId) async {
    // TODO: implement using providersApi
    throw UnimplementedError();
  }

  // // ===== CABS =====
  @override
  Future<List<CabModel>> listCabs(String providerId) async {
    try {
      final response = await cabApi.providersCabListCabs(
        providerId: providerId,
      );

      final cabs = response.data?.map((c) {
        final cabJson = standardSerializers.serializeWith(
          CabPublic.serializer,
          c,
        );

        return CabModel.fromJson(cabJson as Map<String, dynamic>);
      }).toList();
      return cabs ?? [];
    } on DioException catch (e) {
      throw Exception('Failed to list cabs: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to list cabs: ${e.toString()}');
    }
  }

  @override
  Future<CabModel> createCab(
    String providerId, {
    required String vehicleType,
    required String vehicleNumber,
    required double minimumRate,
    required double kmForMinimumRate,
    required double perKmRate,
    required int capacity,
    required String name,
    required String companyModel,
    required String color,
  }) async {
    try {
      // Use the rab_dio generated model for the API request
      // Note: CabCreate uses built_value builders, so we use the builder pattern
      final response = await cabApi.providersCabCreateCab(
        providerId: providerId,
        cabCreate: CabCreate(
          (b) => b
            ..vehicleType = vehicleType
            ..vehicleNumber = vehicleNumber
            ..minimumRate = minimumRate
            ..kmForMinimumRate = kmForMinimumRate
            ..perKmRate = perKmRate
            ..capacity = capacity
            ..name = name
            ..companyModel = companyModel
            ..color = color,
        ),
      );

      if (response.data == null) {
        throw Exception('Failed to create cab');
      }

      final cabJson = standardSerializers.serializeWith(
        CabPublic.serializer,
        response.data,
      );

      return CabModel.fromJson(cabJson as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to create cab: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to create cab: ${e.toString()}');
    }
  }

  // // ===== DRIVERS =====
  @override
  Future<List<DriverModel>> listDrivers(String providerId) async {
    try {
      final response = await cabApi.providersCabListDrivers(
        providerId: providerId,
      );

      final drivers = response.data?.map((d) {
        final driverJson = standardSerializers.serializeWith(
          DriverPublic.serializer,
          d,
        );

        return DriverModel.fromJson(driverJson as Map<String, dynamic>);
      }).toList();
      return drivers ?? [];
    } on DioException catch (e) {
      throw Exception(
        'Failed to list drivers: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Failed to list drivers: ${e.toString()}');
    }
  }

  @override
  Future<DriverModel> createDriver({
    required String providerId,
    required String profileId,
  }) async {
    try {
      final response = await cabApi.providersCabCreateDriver(
        providerId: providerId,
        driverCreate: DriverCreate((b) => b..profileId = profileId),
      );

      if (response.data == null) {
        throw Exception('Failed to create cab');
      }

      final driverJson = standardSerializers.serializeWith(
        DriverPublic.serializer,
        response.data,
      );

      return DriverModel.fromJson(driverJson as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Failed to create driver: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Failed to create driver: ${e.toString()}');
    }
  }

  // // ===== STAY UNITS =====
  @override
  Future<List<StayUnitModel>> listStayUnits(
    String providerId, {
    int? minPrice,
    int? maxPrice,
    String? amenity,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await stayApi.providersStayListStayUnits(
        providerId: providerId,
        minPrice: minPrice ?? 0,
        maxPrice: maxPrice ?? 1000000,
        amenity: amenity,
        limit: limit,
        offset: offset,
      );

      final units = response.data?.data.map((u) {
        final unitJson = standardSerializers.serializeWith(
          StayUnitPublic.serializer,
          u,
        );

        return StayUnitModel.fromJson(unitJson as Map<String, dynamic>);
      }).toList();
      return units ?? [];
    } on DioException catch (e) {
      throw Exception(
        'Failed to list stay units: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Failed to list stay units: ${e.toString()}');
    }
  }

  @override
  Future<StayUnitModel> createStayUnit(
    String providerId, {
    required String name,
    String? description,
    int? roomRate,
    int? perHeadRate,
    int? maxOccupancy,
  }) async {
    try {
      final response = await stayApi.providersStayCreateStayUnit(
        providerId: providerId,
        stayUnitCreate: StayUnitCreate((b) {
          b
            ..name = name
            ..description = description
            ..roomRate = roomRate
            ..perHeadRate = perHeadRate
            ..maxOccupancy = maxOccupancy;
        }),
      );

      if (response.data == null) {
        throw Exception('Failed to create stay unit');
      }

      final unitJson = standardSerializers.serializeWith(
        StayUnitPublic.serializer,
        response.data,
      );

      return StayUnitModel.fromJson(unitJson as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Failed to create stay unit: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Failed to create stay unit: ${e.toString()}');
    }
  }

  // // ===== STAY AMENITIES =====

  @override
  Future<StayAmenityModel> addAmenity(
    String providerId,
    String unitId, {
    required String amenity,
    required String amenityScope,
  }) async {
    try {
      final response = await stayApi.providersStayAddAmenity(
        providerId: providerId,
        unitId: unitId,
        stayAmenityCreate: StayAmenityCreate((b) {
          b
            ..amenity = amenity
            ..amenityScope = AmenityScope.valueOf(amenityScope);
        }),
      );

      if (response.data == null) {
        throw Exception('Failed to add amenity');
      }

      final amenityJson = standardSerializers.serializeWith(
        StayAmenityPublic.serializer,
        response.data,
      );

      return StayAmenityModel.fromJson(amenityJson as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Failed to add amenity: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Failed to add amenity: ${e.toString()}');
    }
  }
}
