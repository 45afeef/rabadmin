import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/providers.dart';
import '../../domain/usecases/add_agency_staff_use_case.dart';
import 'agency_usecases_provider.dart';
import '../../domain/usecases/create_user_use_case.dart';
import '../../domain/usecases/get_available_users_use_case.dart';
import 'agency_state.dart';

/// Riverpod provider for managing the add staff to agency state.
///
/// Handles creating new users, assigning existing users as staff,
/// and managing available users list.
final addStaffProvider = StateNotifierProvider.family
    .autoDispose<AddStaffNotifier, AddStaffState, String>((ref, agencyId) {
      final addStaffUseCase = ref.watch(addAgencyStaffUseCaseProvider);
      final getUsersUseCase = ref.watch(getAvailableUsersUseCaseProvider);
      final createUserUseCase = ref.watch(createUserUseCaseProvider);
      return AddStaffNotifier(
        addStaffUseCase,
        getUsersUseCase,
        createUserUseCase,
        agencyId,
      );
    });

/// Notifier for managing add staff to agency state.
///
/// Handles all state transitions and side effects related to adding staff.
class AddStaffNotifier extends StateNotifier<AddStaffState> {
  final AddAgencyStaffUseCase addStaffUseCase;
  final GetAvailableUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final String agencyId;

  AddStaffNotifier(
    this.addStaffUseCase,
    this.getUsersUseCase,
    this.createUserUseCase,
    this.agencyId,
  ) : super(const AddStaffState());

  /// Load available users that can be assigned as staff
  Future<void> loadAvailableUsers() async {
    state = state.copyWith(isLoadingUsers: true, error: null);
    try {
      final users = await getUsersUseCase.call();
      final availableUsers = users
          .map(
            (u) => {
              'id': u.id,
              'full_name': u.fullName,
              'email': u.email,
              'phone_number': u.phone,
            },
          )
          .toList();

      state = state.copyWith(
        availableUsers: availableUsers,
        isLoadingUsers: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingUsers: false,
        error: 'Failed to load users: ${e.toString()}',
      );
    }
  }

  /// Create a new user and add them as staff
  Future<void> createUserAndAddAsStaff({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final fullName = '$firstName $lastName';
      final created = await createUserUseCase.call(
        fullName: fullName,
        password: password,
        phone: phone,
      );
      final userId = created.id;
      await addUserAsStaff(userId: userId, role: role);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create user and add as staff: ${e.toString()}',
      );
    }
  }

  /// Add an existing user as staff
  Future<void> addUserAsStaff({
    required String userId,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final staff = await addStaffUseCase.call(
        agencyId: agencyId,
        userId: userId,
        role: role,
      );
      state = state.copyWith(staff: staff, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add staff: ${e.toString()}',
      );
    }
  }

  /// Clear the success message
  void clearSuccess() {
    state = state.copyWith(staff: null);
  }

  /// Clear the error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear all data from the state
  void clear() {
    state = const AddStaffState();
  }
}
