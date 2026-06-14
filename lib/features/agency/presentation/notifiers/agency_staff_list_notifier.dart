// Removed unused import: flutter_riverpod.dart
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/providers.dart';
import '../../domain/usecases/list_agency_staffs_use_case.dart';
import 'agency_state.dart';

/// Riverpod provider for managing agency staff list state.
///
/// Handles loading, displaying, and error states for staff members of an agency.
/// Takes an agencyId as a parameter to fetch staffs for that specific agency.
final agencyStaffListProvider = StateNotifierProvider.family
    .autoDispose<AgencyStaffListNotifier, AgencyStaffListState, String>((
      ref,
      agencyId,
    ) {
      final repository = ref.watch(agencyRepositoryProvider);
      final useCase = ListAgencyStaffsUseCase(repository);
      return AgencyStaffListNotifier(useCase, agencyId);
    });

/// Notifier for managing agency staff list state.
///
/// Handles all state transitions and side effects related to staff listings.
class AgencyStaffListNotifier extends StateNotifier<AgencyStaffListState> {
  final ListAgencyStaffsUseCase useCase;
  final String agencyId;

  AgencyStaffListNotifier(this.useCase, this.agencyId)
    : super(const AgencyStaffListState());

  /// Load staff members for the agency from the repository.
  ///
  /// Sets loading state, fetches staff list, and updates state accordingly.
  /// Captures any errors and stores them in the error field.
  Future<void> loadStaffs() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final staffs = await useCase.call(agencyId: agencyId);
      state = state.copyWith(staffs: staffs, isLoading: false);
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
    state = const AgencyStaffListState();
  }
}
