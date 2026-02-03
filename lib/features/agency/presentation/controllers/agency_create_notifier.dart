import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/agency.dart';
import '../../domain/usecases/create_agency_use_case.dart';
import 'agency_state.dart';
import 'agency_usecases_provider.dart';

/// Riverpod provider for managing agency creation state.
final agencyCreateProvider =
    StateNotifierProvider.autoDispose<AgencyCreateNotifier, AgencyCreateState>((
      ref,
    ) {
      final useCase = ref.watch(createAgencyUseCaseProvider);
      return AgencyCreateNotifier(useCase);
    });

/// Notifier for managing agency creation state.
///
/// Handles loading, success, and error states during agency creation.
class AgencyCreateNotifier extends StateNotifier<AgencyCreateState> {
  final CreateAgencyUseCase useCase;

  AgencyCreateNotifier(this.useCase) : super(const AgencyCreateState());

  /// Create a new agency.
  ///
  /// Sets loading state, calls the use case, and updates the state
  /// with either the created agency or an error.
  Future<void> createAgency(Agency agency) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final createdAgency = await useCase.call(
        name: agency.agencyName,
        description: agency.contactEmail,
      );
      state = state.copyWith(isLoading: false, agency: createdAgency);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Clear the error message from the state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset the state completely.
  void clear() {
    state = const AgencyCreateState();
  }
}
