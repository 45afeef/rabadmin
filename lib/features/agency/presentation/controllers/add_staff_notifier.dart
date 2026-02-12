import 'package:flutter_riverpod/legacy.dart';
import 'package:rab_dio/rab_dio.dart' show UserCreate, UsersApi;

import '../../../../core/providers/providers.dart';
import '../../domain/usecases/add_agency_staff_use_case.dart';
import 'agency_state.dart';

/// Riverpod provider for managing the add staff to agency state.
///
/// Handles creating new users, assigning existing users as staff,
/// and managing available users list.
final addStaffProvider = StateNotifierProvider.family
    .autoDispose<AddStaffNotifier, AddStaffState, String>((ref, agencyId) {
      final repository = ref.watch(agencyRepositoryProvider);
      final usersApi = ref.watch(usersApiProvider);
      final useCase = AddAgencyStaffUseCase(repository);
      return AddStaffNotifier(useCase, usersApi, agencyId);
    });

/// Notifier for managing add staff to agency state.
///
/// Handles all state transitions and side effects related to adding staff.
class AddStaffNotifier extends StateNotifier<AddStaffState> {
  final AddAgencyStaffUseCase useCase;
  final UsersApi usersApi;
  final String agencyId;

  AddStaffNotifier(this.useCase, this.usersApi, this.agencyId)
    : super(const AddStaffState());

  /// Load available users that can be assigned as staff
  Future<void> loadAvailableUsers() async {
    state = state.copyWith(isLoadingUsers: true, error: null);
    try {
      final response = await usersApi.usersReadUsers();

      if (response.data != null) {
        final usersData = response.data as List<dynamic>;
        final availableUsers =
            usersData
                    .map((user) => user is Map<String, dynamic> ? user : {})
                    .toList()
                as List<Map<String, dynamic>>;
        state = state.copyWith(
          availableUsers: availableUsers,
          isLoadingUsers: false,
        );
      } else {
        state = state.copyWith(isLoadingUsers: false);
      }
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
      // Create the user
      final userCreate = UserCreate(
        (b) => b
          ..fullName = '$firstName $lastName'
          ..password = password
          ..phoneNumber = phone ?? '',
      );

      final userResponse = await usersApi.usersCreateUser(
        userCreate: userCreate,
      );

      if (userResponse.data != null) {
        final userData = userResponse.data as Map<String, dynamic>;
        final userId = userData['id'] as String;

        // Add the created user as staff
        await addUserAsStaff(userId: userId, role: role);
      } else {
        throw Exception('Failed to create user');
      }
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
      final staff = await useCase.call(
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
