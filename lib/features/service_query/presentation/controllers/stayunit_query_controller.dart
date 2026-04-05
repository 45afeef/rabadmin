import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/usecases/query_stay_units_use_case.dart';
import '../state/stayunit_query_state.dart';

class StayUnitQueryNotifier extends Notifier<UnitQueryState> {
  late final QueryStayUnitsUseCase _unitUseCase;

  @override
  UnitQueryState build() {
    _unitUseCase = ref.read(queryStayUnitsUseCaseProvider);
    return StayUnitQueryInitial();
  }

  Future<void> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  }) async {
    state = StayUnitQueryLoading();
    try {
      final units = await _unitUseCase.call(
        location: location,
        checkIn: checkIn,
        checkOut: checkOut,
        pax: pax,
        maxRate: maxRate,
        amenities: amenities,
      );
      state = StayUnitQueryLoaded(units);
    } catch (e) {
      state = StayUnitQueryError(e.toString());
    }
  }
}
