import 'package:dio/dio.dart' show DioException;
import 'package:one_of/any_of.dart';
import 'package:rab_dio/rab_dio.dart';
import '../models/cab_model.dart';
import '../models/cab_provider_model.dart';
import '../models/driver_model.dart';
import 'service_provider_remote_data_source.dart';

class ServiceProviderRemoteDataSourceImpl
    extends ServiceProviderRemoteDataSource {
  final ProvidersApi providersApi;
  final ProvidersCabApi cabApi;

  ServiceProviderRemoteDataSourceImpl(this.providersApi, this.cabApi);

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
}
