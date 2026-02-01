import 'package:flutter_riverpod/legacy.dart';
// Removed unused import: flutter_riverpod.dart

import '../../domain/usecases/get_agency_use_case.dart';
import 'agencies_list_notifier.dart';
import 'agency_state.dart';

/// Riverpod provider for managing a single agency's detail state.
///
/// Handles loading, displaying, and error states for agency details.
/// Takes an agencyId as a parameter to fetch specific agency information.
final agencyDetailProvider = StateNotifierProvider.family
    .autoDispose<AgencyDetailNotifier, AgencyDetailState, String>((
      ref,
      agencyId,
    ) {
      final repository = ref.watch(agencyRepositoryProvider);
      final useCase = GetAgencyUseCase(repository);
      return AgencyDetailNotifier(useCase, agencyId);
    });

/// Notifier for managing a single agency's detail state.
///
/// Handles all state transitions and side effects related to agency details.
class AgencyDetailNotifier extends StateNotifier<AgencyDetailState> {
  final GetAgencyUseCase useCase;
  final String agencyId;

  AgencyDetailNotifier(this.useCase, this.agencyId)
    : super(const AgencyDetailState());

  /// Load agency details from the repository.
  ///
  /// Sets loading state, fetches the agency details, and updates state.
  /// Captures any errors and stores them in the error field.
  Future<void> loadAgency() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final agency = await useCase.call(agencyId: agencyId);
      state = state.copyWith(agency: agency, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Clear the error message from the state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear all data from the state.
  void clear() {
    state = const AgencyDetailState();
  }
}
