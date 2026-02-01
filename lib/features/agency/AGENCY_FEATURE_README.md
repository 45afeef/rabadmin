# Agency Feature Documentation

## Overview

The Agency feature provides comprehensive functionality for managing travel agencies within the RabAdmin application. It implements clean architecture principles with clear separation of concerns between domain, data, and presentation layers.

## Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  Pages / Widgets / Controllers (Riverpod StateNotifiers)     │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                             │
│  Entities / Repositories (Abstract) / Use Cases             │
│  (Independent of any framework)                              │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                              │
│  Models / Data Sources (Remote) / Repository Implementations│
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                   EXTERNAL SOURCES                           │
│  Remote API (rab_dio / AgenciesApi)                          │
└─────────────────────────────────────────────────────────────┘
```

### Directory Structure

```
lib/features/agency/
├── domain/
│   ├── entities/
│   │   ├── agency.dart              # Core agency entity
│   │   ├── agency_detail.dart       # Agency with staff
│   │   └── agency_staff.dart        # Staff member entity
│   ├── repositories/
│   │   └── agency_repository.dart   # Abstract repository contract
│   └── usecases/
│       ├── list_agencies_use_case.dart
│       ├── get_agency_use_case.dart
│       ├── create_agency_use_case.dart
│       ├── update_agency_use_case.dart
│       ├── delete_agency_use_case.dart
│       ├── list_agency_staffs_use_case.dart
│       ├── add_agency_staff_use_case.dart
│       ├── update_agency_staff_use_case.dart
│       └── remove_agency_staff_use_case.dart
├── data/
│   ├── datasources/
│   │   └── agency_remote_data_source.dart  # API communication
│   ├── models/
│   │   ├── agency_model.dart
│   │   ├── agency_detail_model.dart
│   │   └── agency_staff_model.dart
│   └── repositories/
│       └── agency_repository_impl.dart     # Concrete implementation
└── presentation/
    ├── controllers/
    │   ├── agency_state.dart
    │   ├── agencies_list_notifier.dart
    │   ├── agency_detail_notifier.dart
    │   ├── agency_staff_list_notifier.dart
    │   └── agency_usecases_provider.dart
    ├── pages/                              # (To be created)
    └── widgets/                            # (To be created)
```

## Core Concepts

### Entities
Entities represent pure business logic models independent of any framework or external source.

- **Agency**: Represents a travel agency with basic information
- **AgencyDetail**: Extended agency entity including staff members
- **AgencyStaff**: Represents a staff member in an agency

### Use Cases
Each use case represents a single business operation. They orchestrate the interaction between the presentation layer and repositories.

Examples:
- `ListAgenciesUseCase` - Retrieve all agencies
- `GetAgencyUseCase` - Retrieve a specific agency
- `CreateAgencyUseCase` - Create a new agency
- `AddAgencyStaffUseCase` - Add staff to an agency

### Repositories
Repositories serve as the source of truth layer, determining which data source to use (remote, local cache, etc.).

**AgencyRepository** (Abstract)
- Defines the contract for all agency operations
- Implementation-agnostic

**AgencyRepositoryImpl** (Concrete)
- Implements the abstract repository
- Orchestrates calls to data sources
- Converts data models to domain entities

### Data Sources
Data sources handle communication with external services.

**AgencyRemoteDataSource**
- Communicates with the AgenciesApi (from rab_dio)
- Handles API-specific serialization/deserialization
- Manages error handling for HTTP requests

### Models
Models represent data as it comes from external sources (API responses).

- **AgencyModel**: Extends Agency entity with JSON conversion methods
- **AgencyStaffModel**: Extends AgencyStaff entity
- **AgencyDetailModel**: Extends AgencyDetail with nested staff models

## Dependency Injection

The agency feature uses Riverpod for dependency injection and state management.

### Core Providers (lib/core/providers/providers.dart)

```dart
// API client provider
final agenciesApiProvider = Provider<AgenciesApi>(
  (ref) => rab.getAgenciesApi(),
);

// Data source provider
final agencyRemoteDataSourceProvider = Provider<AgencyRemoteDataSource>(
  (ref) => AgenciesRemoteDataSource(ref.read(agenciesApiProvider)),
);

// Repository provider (used throughout the app)
final agencyRepositoryProvider = Provider<AgencyRepository>(
  (ref) => AgencyRepositoryImpl(ref.read(agencyRemoteDataSourceProvider)),
);
```

### Feature-Level Providers

State Management Providers:
- `agenciesListProvider` - State for agencies list
- `agencyDetailProvider` - State for single agency detail
- `agencyStaffListProvider` - State for agency staff

Use Case Providers:
- `createAgencyUseCaseProvider`
- `updateAgencyUseCaseProvider`
- `deleteAgencyUseCaseProvider`
- `addAgencyStaffUseCaseProvider`
- `updateAgencyStaffUseCaseProvider`
- `removeAgencyStaffUseCaseProvider`

## Usage Example

### Loading Agencies List

```dart
final agenciesList = await ref.read(agenciesListProvider.notifier).loadAgencies();
```

### Displaying Agencies

```dart
class AgenciesListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agenciesListProvider);

    if (state.isLoading) {
      return const CircularProgressIndicator();
    }

    if (state.error != null) {
      return Text('Error: ${state.error}');
    }

    return ListView.builder(
      itemCount: state.agencies.length,
      itemBuilder: (context, index) {
        final agency = state.agencies[index];
        return ListTile(
          title: Text(agency.name),
          subtitle: Text(agency.description ?? ''),
        );
      },
    );
  }
}
```

### Creating an Agency

```dart
final repository = ref.read(agencyRepositoryProvider);
final useCase = ref.read(createAgencyUseCaseProvider);

try {
  final newAgency = await useCase.call(
    name: 'New Agency',
    description: 'Agency Description',
  );
  // Handle success
} catch (e) {
  // Handle error
}
```

### Managing Agency Staff

```dart
// List staff for an agency
final staffList = await ref.read(agencyStaffListProvider('agency-id').notifier).loadStaffs();

// Add staff to agency
final useCase = ref.read(addAgencyStaffUseCaseProvider);
final staff = await useCase.call(
  agencyId: 'agency-id',
  userId: 'user-id',
  role: 'manager',
);
```

## API Integration

The agency feature integrates with the `AgenciesApi` from the rab_dio package. The following API endpoints are used:

### Agencies
- `GET /api/v1/travel-agency` - List all agencies
- `GET /api/v1/travel-agency/{agency_id}` - Get agency details
- `POST /api/v1/travel-agency` - Create new agency
- `PUT /api/v1/travel-agency/{agency_id}` - Update agency
- `DELETE /api/v1/travel-agency/{agency_id}` - Delete agency

### Agency Staff
- `GET /api/v1/travel-agency/{agency_id}/staffs` - List staff
- `POST /api/v1/travel-agency/{agency_id}/staffs` - Add staff
- `PATCH /api/v1/travel-agency/{agency_id}/staffs/{staff_id}` - Update staff
- `DELETE /api/v1/travel-agency/{agency_id}/staffs/{staff_id}` - Remove staff

## Error Handling

The feature implements comprehensive error handling:

1. **API Errors**: Wrapped in `DioException` with status codes
2. **Serialization Errors**: Caught during model conversion
3. **State Management**: Errors stored in state and accessible via `state.error`

Example:
```dart
try {
  final agencies = await useCase.call();
} on DioException catch (e) {
  print('API Error: ${e.response?.statusCode}');
} catch (e) {
  print('General Error: $e');
}
```

## State Management

The feature uses Riverpod `StateNotifier` for state management:

```dart
class AgencyListState {
  final List<Agency> agencies;      // The data
  final bool isLoading;             // Loading indicator
  final String? error;              // Error message

  const AgencyListState({
    this.agencies = const [],
    this.isLoading = false,
    this.error,
  });
}
```

Benefits:
- Reactive state updates
- Automatic UI rebuilds on state changes
- Clean separation of state logic
- Easy to test

## Best Practices

1. **Always use repositories**, never call data sources directly from UI
2. **Use use cases** to encapsulate business logic
3. **Keep entities immutable** with `copyWith` methods
4. **Handle errors gracefully** at the presentation layer
5. **Document complex operations** with clear comments
6. **Test each layer independently** - unit test use cases, repository, and data sources

## Extending the Feature

To add new functionality:

1. Create new entities in `domain/entities/`
2. Define abstract methods in `domain/repositories/agency_repository.dart`
3. Add use cases in `domain/usecases/`
4. Implement data source methods in `data/datasources/`
5. Implement repository methods in `data/repositories/`
6. Create presentation providers and UI components
7. Update dependency injection in core providers

## Comments and Documentation

All code includes:
- Class-level documentation explaining purpose
- Method documentation with parameter descriptions
- Usage examples where applicable
- Clear variable naming
- Inline comments for complex logic

## Future Enhancements

- Local caching with Hive for offline support
- Pagination for large agency lists
- Search and filtering capabilities
- Real-time updates with WebSocket
- Batch operations for multiple agencies
