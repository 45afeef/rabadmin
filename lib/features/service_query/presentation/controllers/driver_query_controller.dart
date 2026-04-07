import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/usecases/query_drivers_use_case.dart';
import '../state/driver_query_state.dart';

class DriverQueryNotifier extends Notifier<DriverQueryState> {
  late final QueryDriversUseCase _driversUseCase;

  @override
  DriverQueryState build() {
    _driversUseCase = ref.read(queryDriversUseCaseProvider);
    return DriverQueryInitial();
  }

  Future<void> queryDrivers({
    String? providerId,
    double? radiusKm,
    int? minCapacity,
  }) async {
    state = DriverQueryLoading();
    try {
      final drivers = await _driversUseCase.call(
        providerId: providerId,
        radiusKm: radiusKm,
        minCapacity: minCapacity,
      );
      state = DriverQueryLoaded(drivers);
    } catch (e) {
      state = DriverQueryError(e.toString());
    }
  }
}
