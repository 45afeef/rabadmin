import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/usecases/query_stay_provider_use_case.dart';
import '../state/stayprovider_query_state.dart';

class StayProviderQueryNotifier extends Notifier<StayProviderQueryState> {
  late final QueryStayProvidersUseCase _providerUseCase;

  @override
  StayProviderQueryState build() {
    _providerUseCase = ref.read(queryStayProvidersUseCaseProvider);
    return StayProviderQueryInitial();
  }

  Future<void> queryStayProviders({
    required String locationName,
    num? radiusKm,
    DateTime? checkIn,
    DateTime? checkOut,
    int? pax,
    int? maxRate,
    List<String>? amenities,
    int? roomCount,
  }) async {
    state = StayProviderQueryLoading();
    try {
      final providers = await _providerUseCase.call(
        locationName: locationName,
        radiusKm: radiusKm,
        checkIn: checkIn,
        checkOut: checkOut,
        pax: pax,
        maxRate: maxRate,
        amenities: amenities,
        roomCount: roomCount,
      );
      state = StayProviderQueryLoaded(providers);
    } catch (e) {
      state = StayProviderQueryError(e.toString());
    }
  }
}
