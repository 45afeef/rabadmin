// Removed unused Riverpod import
import '../../domain/entities/agency.dart';
import '../../domain/entities/agency_detail.dart';
import '../../domain/entities/agency_staff.dart';

/// State class for agency listing operations.
///
/// Manages the state of loading, data, and errors for agency lists.
class AgencyListState {
  final List<Agency> agencies;
  final bool isLoading;
  final String? error;

  const AgencyListState({
    this.agencies = const [],
    this.isLoading = false,
    this.error,
  });

  /// Create a copy of this state with modified fields
  AgencyListState copyWith({
    List<Agency>? agencies,
    bool? isLoading,
    String? error,
  }) {
    return AgencyListState(
      agencies: agencies ?? this.agencies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// State class for agency detail operations.
///
/// Manages the state of loading, data, and errors for a single agency detail.
class AgencyDetailState {
  final AgencyDetail? agency;
  final bool isLoading;
  final String? error;

  const AgencyDetailState({this.agency, this.isLoading = false, this.error});

  /// Create a copy of this state with modified fields
  AgencyDetailState copyWith({
    AgencyDetail? agency,
    bool? isLoading,
    String? error,
  }) {
    return AgencyDetailState(
      agency: agency ?? this.agency,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// State class for agency staff operations.
///
/// Manages the state of loading, data, and errors for agency staff lists.
class AgencyStaffListState {
  final List<AgencyStaff> staffs;
  final bool isLoading;
  final String? error;

  const AgencyStaffListState({
    this.staffs = const [],
    this.isLoading = false,
    this.error,
  });

  /// Create a copy of this state with modified fields
  AgencyStaffListState copyWith({
    List<AgencyStaff>? staffs,
    bool? isLoading,
    String? error,
  }) {
    return AgencyStaffListState(
      staffs: staffs ?? this.staffs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
