import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/providers.dart';
import '../../domain/usecases/list_agencies_use_case.dart';
import 'agency_state.dart';

/// Riverpod provider for managing the agencies list state.
///
/// Handles loading, displaying, and error states for the list of agencies.
/// Use this provider to access the current list of agencies throughout the app.
final agenciesListProvider =
    StateNotifierProvider.autoDispose<AgenciesListNotifier, AgencyListState>((
      ref,
    ) {
      final repository = ref.watch(agencyRepositoryProvider);
      final useCase = ListAgenciesUseCase(repository);
      return AgenciesListNotifier(useCase);
    });

/// Notifier for managing agencies list state.
///
/// Handles all state transitions and side effects related to agency listing.
class AgenciesListNotifier extends StateNotifier<AgencyListState> {
  final ListAgenciesUseCase useCase;

  AgenciesListNotifier(this.useCase) : super(const AgencyListState());

  /// Load all agencies from the repository.
  ///
  /// Sets loading state, fetches agencies, and updates the state accordingly.
  /// Captures any errors and stores them in the error field.
  Future<void> loadAgencies() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final agencies = await useCase.call();
      state = state.copyWith(agencies: agencies, isLoading: false);
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
    state = const AgencyListState();
  }
}
