import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/usecases/query_stay_units_use_case.dart';
import '../state/stay_query_state.dart';

class StayQueryNotifier extends Notifier<StayQueryState> {
  late final QueryStayUnitsUseCase _useCase;

  @override
  StayQueryState build() {
    _useCase = ref.read(queryStayUnitsUseCaseProvider);
    return StayQueryInitial();
  }

  Future<void> queryStayUnits({
    String? location,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
  }) async {
    state = StayQueryLoading();
    try {
      final units = await _useCase.call(
        location: location,
        checkIn: checkIn,
        checkOut: checkOut,
        pax: pax,
        maxRate: maxRate,
        amenities: amenities,
      );
      state = StayQueryLoaded(units);
    } catch (e) {
      state = StayQueryError(e.toString());
    }
  }
}
