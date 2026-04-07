import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/usecases/query_cabs_use_case.dart';
import '../state/cab_query_state.dart';

class CabQueryNotifier extends Notifier<CabQueryState> {
  late final QueryCabsUseCase _cabsUseCase;

  @override
  CabQueryState build() {
    _cabsUseCase = ref.read(queryCabsUseCaseProvider);
    return CabQueryInitial();
  }

  Future<void> queryCabs({
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
    state = CabQueryLoading();
    try {
      final cabs = await _cabsUseCase.call(
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
      state = CabQueryLoaded(cabs);
    } catch (e) {
      state = CabQueryError(e.toString());
    }
  }
}
