/// Quick Reference Guide for Agency Feature
/// 
/// This file provides a quick reference for the most common operations
/// and patterns used in the Agency feature.

// =============================================================================
// DEPENDENCY INJECTION - Using Providers
// =============================================================================

/// Get the agency repository:
///   final repository = ref.read(agencyRepositoryProvider);
///
/// Get a use case:
///   final useCase = ref.read(createAgencyUseCaseProvider);
///   final useCase = ref.read(updateAgencyUseCaseProvider);
///   final useCase = ref.read(deleteAgencyUseCaseProvider);
///   final useCase = ref.read(addAgencyStaffUseCaseProvider);
///   final useCase = ref.read(updateAgencyStaffUseCaseProvider);
///   final useCase = ref.read(removeAgencyStaffUseCaseProvider);

// =============================================================================
// STATE MANAGEMENT - Riverpod Patterns
// =============================================================================

/// WATCHING STATE (Reactive - rebuilds on change):
///   final state = ref.watch(agenciesListProvider);
///   final state = ref.watch(agencyDetailProvider('agency-id'));
///   final state = ref.watch(agencyStaffListProvider('agency-id'));

/// ACCESSING NOTIFIER (To trigger actions):
///   ref.read(agenciesListProvider.notifier)
///   ref.read(agencyDetailProvider('agency-id').notifier)
///   ref.read(agencyStaffListProvider('agency-id').notifier)

/// AVAILABLE METHODS on Notifiers:
///   .loadAgencies()      // Load list of agencies
///   .loadAgency()        // Load single agency details
///   .loadStaffs()        // Load agency staff
///   .clearError()        // Clear error state
///   .clear()             // Clear all state

// =============================================================================
// COMMON OPERATIONS
// =============================================================================

/// List all agencies:
///   final listNotifier = ref.read(agenciesListProvider.notifier);
///   await listNotifier.loadAgencies();
///   final agencies = ref.read(agenciesListProvider).agencies;

/// Get single agency with staff:
///   final detailNotifier = ref.read(agencyDetailProvider('id').notifier);
///   await detailNotifier.loadAgency();
///   final agency = ref.read(agencyDetailProvider('id')).agency;

/// Create new agency:
///   final useCase = ref.read(createAgencyUseCaseProvider);
///   final agency = await useCase.call(
///     name: 'Agency Name',
///     description: 'Description'
///   );

/// Update agency:
///   final useCase = ref.read(updateAgencyUseCaseProvider);
///   final updated = await useCase.call(
///     agencyId: 'id',
///     name: 'New Name',
///     description: 'New Description'
///   );

/// Delete agency:
///   final useCase = ref.read(deleteAgencyUseCaseProvider);
///   await useCase.call(agencyId: 'id');

/// List agency staff:
///   final staffNotifier = ref.read(agencyStaffListProvider('id').notifier);
///   await staffNotifier.loadStaffs();
///   final staffs = ref.read(agencyStaffListProvider('id')).staffs;

/// Add staff to agency:
///   final useCase = ref.read(addAgencyStaffUseCaseProvider);
///   final staff = await useCase.call(
///     agencyId: 'id',
///     userId: 'user-id',
///     role: 'manager'
///   );

/// Update staff role:
///   final useCase = ref.read(updateAgencyStaffUseCaseProvider);
///   final updated = await useCase.call(
///     agencyId: 'id',
///     staffId: 'staff-id',
///     role: 'new-role'
///   );

/// Remove staff from agency:
///   final useCase = ref.read(removeAgencyStaffUseCaseProvider);
///   await useCase.call(agencyId: 'id', staffId: 'staff-id');

// =============================================================================
// STATE STRUCTURE
// =============================================================================

/// AgencyListState:
///   agencies: List<Agency>        - List of agencies
///   isLoading: bool               - Is data being loaded
///   error: String?                - Error message if any

/// AgencyDetailState:
///   agency: AgencyDetail?         - Single agency with staff
///   isLoading: bool               - Is data being loaded
///   error: String?                - Error message if any

/// AgencyStaffListState:
///   staffs: List<AgencyStaff>     - List of staff members
///   isLoading: bool               - Is data being loaded
///   error: String?                - Error message if any

// =============================================================================
// ENTITIES
// =============================================================================

/// Agency:
///   id: String
///   name: String
///   description: String?
///   logo: String?
///   isActive: bool
///   createdAt: DateTime
///   updatedAt: DateTime

/// AgencyDetail (extends Agency):
///   + staffs: List<AgencyStaff>   - Associated staff members

/// AgencyStaff:
///   id: String
///   userId: String
///   agencyId: String
///   role: String
///   fullName: String?
///   email: String?
///   createdAt: DateTime
///   updatedAt: DateTime

// =============================================================================
// ERROR HANDLING
// =============================================================================

/// Catching errors in operations:
///   try {
///     final agency = await useCase.call(...);
///   } on DioException catch (e) {
///     // Handle API errors (network, status codes, etc)
///     print('API Error: ${e.response?.statusCode}');
///   } catch (e) {
///     // Handle other errors
///     print('Error: $e');
///   }

/// Accessing errors from state:
///   final state = ref.watch(agenciesListProvider);
///   if (state.error != null) {
///     print('Error: ${state.error}');
///   }

// =============================================================================
// BEST PRACTICES
// =============================================================================

/// 1. Use ConsumerWidget/ConsumerStatefulWidget for UI components
///    Makes WidgetRef available in build method
///
/// 2. Always handle three states in UI:
///    - isLoading: Show loading indicator
///    - error: Show error message with retry option
///    - data: Display actual content
///
/// 3. Refresh data after mutations:
///    await deleteUseCase.call(...);
///    ref.read(agenciesListProvider.notifier).loadAgencies();
///
/// 4. Use .copyWith() to create immutable copies with changes:
///    agency.copyWith(name: 'New Name')
///
/// 5. Handle AsyncValue for reactive operations:
///    final asyncValue = ref.watch(someAsyncProvider);
///    asyncValue.when(
///      data: (data) => Text(data),
///      loading: () => CircularProgressIndicator(),
///      error: (err, stack) => Text('Error: $err'),
///    );

// =============================================================================
// COMMON PATTERNS
// =============================================================================

/// Pattern: Load data on widget initialization
///   @override
///   void initState() {
///     super.initState();
///     Future.microtask(() {
///       ref.read(agenciesListProvider.notifier).loadAgencies();
///     });
///   }

/// Pattern: Load data when provider is first accessed
///   Use FutureProvider or StreamProvider for automatic loading
///   Not currently implemented, but can be added as optimization

/// Pattern: Watch multiple providers
///   final listState = ref.watch(agenciesListProvider);
///   final detailState = ref.watch(agencyDetailProvider('id'));

/// Pattern: Conditional logic based on state
///   final state = ref.watch(agenciesListProvider);
///   if (state.isLoading) return LoadingWidget();
///   if (state.error != null) return ErrorWidget();
///   if (state.agencies.isEmpty) return EmptyWidget();
///   return ListWidget(state.agencies);

// =============================================================================
// TROUBLESHOOTING
// =============================================================================

/// Issue: Widget not rebuilding when state changes
/// Solution: Make sure you're using ref.watch(), not ref.read()
///
/// Issue: "agencyRepositoryProvider must be overridden"
/// Solution: Ensure core providers are properly set up in lib/core/providers/providers.dart
///
/// Issue: API response parsing errors
/// Solution: Check that response JSON structure matches model expectations
///           Add logging to AgencyRemoteDataSource to debug
///
/// Issue: State not clearing between navigation
/// Solution: Explicitly call .clear() on notifiers when leaving screens
///           Or use .autoDispose modifier to auto-clear when unwatched
///
/// Issue: Null pointer when accessing agency in detail
/// Solution: Always check if agency != null before accessing its properties
///           Add null coalescing (??) for optional fields

// =============================================================================
// FILE STRUCTURE REMINDER
// =============================================================================

/// Domain Layer (Business Logic):
///   domain/entities/
///     - agency.dart
///     - agency_detail.dart
///     - agency_staff.dart
///   domain/repositories/
///     - agency_repository.dart (abstract)
///   domain/usecases/
///     - list_agencies_use_case.dart
///     - get_agency_use_case.dart
///     - create_agency_use_case.dart
///     - update_agency_use_case.dart
///     - delete_agency_use_case.dart
///     - list_agency_staffs_use_case.dart
///     - add_agency_staff_use_case.dart
///     - update_agency_staff_use_case.dart
///     - remove_agency_staff_use_case.dart

/// Data Layer (Implementation):
///   data/datasources/
///     - agency_remote_data_source.dart (API communication)
///   data/models/
///     - agency_model.dart
///     - agency_detail_model.dart
///     - agency_staff_model.dart
///   data/repositories/
///     - agency_repository_impl.dart

/// Presentation Layer (UI):
///   presentation/controllers/
///     - agency_state.dart
///     - agencies_list_notifier.dart
///     - agency_detail_notifier.dart
///     - agency_staff_list_notifier.dart
///     - agency_usecases_provider.dart
///   presentation/pages/
///     - (To be implemented)
///   presentation/widgets/
///     - (To be implemented)

/// Core Setup:
///   lib/core/providers/providers.dart
///     - Contains all dependency injection setup

// =============================================================================
// API ENDPOINTS REFERENCE
// =============================================================================

/// Base: /api/v1

/// Agencies:
///   GET    /travel-agency                    - List all agencies
///   POST   /travel-agency                    - Create agency
///   GET    /travel-agency/{agency_id}        - Get agency details
///   PUT    /travel-agency/{agency_id}        - Update agency
///   DELETE /travel-agency/{agency_id}        - Delete agency

/// Agency Staff:
///   GET    /travel-agency/{agency_id}/staffs                     - List staff
///   POST   /travel-agency/{agency_id}/staffs                     - Add staff
///   PATCH  /travel-agency/{agency_id}/staffs/{staff_id}          - Update staff
///   DELETE /travel-agency/{agency_id}/staffs/{staff_id}          - Remove staff
