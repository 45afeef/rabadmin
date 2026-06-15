
---

# Flutter Clean Architecture Feature Creation Blueprint

## Purpose

This blueprint defines the standard process for creating new features in the project.

Goals:

* Consistent architecture across all features
* Predictable folder structure
* Clear separation of concerns
* Easier onboarding for new developers
* Faster development and code reviews
* Better testability
* Reduced technical debt

---

# Feature Structure

```shell
feature_name/
│
├── data/
│   ├── models/
│   ├── data_sources/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── use_cases/
│
└── presentation/
    ├── pages/
    ├── widgets/
    │   └── controllers/
    ├── notifiers/
    └── states/
```

---

# Layer Responsibilities

## Domain Layer

### Purpose

Contains pure business logic.

### Rules

✅ No Flutter imports

✅ No API imports

✅ No database imports

✅ No external package dependencies unless approved

✅ Must be platform independent

### Contains

#### Entities

Business objects.

Example:

```dart
class User {
  final String id;
  final String name;
}
```

#### Repository Contracts

Interfaces only.

Example:

```dart
abstract class UserRepository {
  Future<User> getUser(String id);
}
```

#### Use Cases

Single business action.

Example:

```dart
class GetUserUseCase {
  final UserRepository repository;

  Future<User> call(String id);
}
```

### Forbidden

❌ API calls

❌ Hive

❌ SharedPreferences

❌ Dio

❌ Firebase

❌ UI logic

---

## Data Layer

### Purpose

Responsible for obtaining and storing data.

### Contains

#### Models (DTOs)

Serializable objects.

Example:

```dart
class UserModel extends User {
  factory UserModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

#### Data Sources

Actual implementation.

Examples:

```dart
RemoteUserDataSource
LocalUserDataSource
```

#### Repository Implementations

Implementation of domain repositories.

Example:

```dart
class UserRepositoryImpl implements UserRepository
```

### Responsibilities

* API communication
* Local storage
* Data mapping
* Error conversion

### Forbidden

❌ Widget imports

❌ UI state management

❌ Navigation

---

## Presentation Layer

### Purpose

User interface and state management.

### Contains

#### Pages

Feature screens.

```dart
UserPage
SettingsPage
```

#### Widgets

Reusable feature widgets.

```dart
UserCard
ProfileAvatar
```

#### Controllers (Optional)

Complex widget-specific logic.

#### Notifiers

State management.

```dart
UserNotifier
```

#### States

UI state definitions.

```dart
UserState
```

### Forbidden

❌ Direct API calls

❌ Direct database calls

❌ Business logic implementation

---

# Naming Convention

## Feature

```text
auth
profile
dashboard
settings
```

---

## Entity

```text
User
Product
Order
```

---

## Model

```text
UserModel
ProductModel
```

---

## Repository

```text
UserRepository
UserRepositoryImpl
```

---

## Use Case

```text
GetUserUseCase
CreateUserUseCase
UpdateUserUseCase
DeleteUserUseCase
```

---

## State

```text
UserInitial
UserLoading
UserLoaded
UserError
```

---

## Notifier

```text
UserNotifier
```

---

# Feature Creation Checklist

## Step 1: Requirement Analysis

### Define

* Business goal
* User story
* Acceptance criteria
* API requirements
* Navigation flow
* State transitions
* Error scenarios

### Deliverable

```md
feature_requirements.md
```

---

## Step 2: Design Domain Layer

Create:

```shell
domain/
├── entities/
├── repositories/
└── use_cases/
```

Checklist:

* [ ] Entities defined
* [ ] Repository contracts defined
* [ ] Use cases created
* [ ] Business rules documented

---

## Step 3: Design Data Layer

Create:

```shell
data/
├── models/
├── data_sources/
└── repositories/
```

Checklist:

* [ ] DTO models
* [ ] Mapper methods
* [ ] Remote data source
* [ ] Local data source
* [ ] Repository implementation
* [ ] Error mapping

---

## Step 4: Design Presentation Layer

Create:

```shell
presentation/
├── pages/
├── widgets/
├── notifiers/
└── states/
```

Checklist:

* [ ] Screen created
* [ ] State created
* [ ] Notifier created
* [ ] Widget breakdown completed
* [ ] Loading UI
* [ ] Error UI
* [ ] Empty state UI

---

## Step 5: Dependency Injection

Register:

```dart
Repository
UseCases
Notifiers
DataSources
```

Checklist:

* [ ] Registered in DI container
* [ ] Lazy singleton where applicable
* [ ] Factory where applicable

---

## Step 6: Routing

Checklist:

* [ ] Route defined
* [ ] Deep link verified
* [ ] Navigation tested

---

## Step 7: Testing

### Domain

* [ ] Entity tests
* [ ] Use case tests

### Data

* [ ] Model tests
* [ ] Repository tests
* [ ] Data source tests

### Presentation

* [ ] Notifier tests
* [ ] Widget tests
* [ ] Screen tests

### Integration

* [ ] Happy path
* [ ] Failure path
* [ ] Retry path

---

# State Management Standard

Every feature must support:

```text
Initial
Loading
Success
Empty
Error
```

Example:

```dart
sealed class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {}

class UserEmpty extends UserState {}

class UserError extends UserState {}
```

---

# Error Handling Standard

## Domain

Use Failure abstraction.

```dart
abstract class Failure {}
```

Examples:

```dart
NetworkFailure
ServerFailure
CacheFailure
ValidationFailure
UnauthorizedFailure
```

---

## Data Layer

Convert external exceptions into failures.

```dart
try {
} on DioException {
}
```

---

## Presentation

Convert failures into user-friendly messages.

```dart
Something went wrong
Please try again
No internet connection
Session expired
```

Never expose:

```dart
StackTrace
Raw Exception
API Error Body
```

---

# Logging Standard

Allowed:

```dart
logger.d(...)
logger.i(...)
logger.w(...)
logger.e(...)
```

Requirements:

* No print()
* No debugPrint() in production
* Sensitive data must never be logged

---

# Documentation Standard

Each feature must contain:

```shell
feature_name/
│
├── README.md
├── CHANGELOG.md
└── architecture.md
```

---

## README.md

Must contain:

* Feature purpose
* Navigation entry points
* State flow
* Dependencies
* Known limitations

---

## architecture.md

Must contain:

```text
Feature Overview
Entities
Use Cases
Repository Flow
API Endpoints
State Diagram
```

---

# Code Review Checklist

## Architecture

* [ ] Correct layer separation
* [ ] No dependency rule violations
* [ ] Use cases properly used

## Quality

* [ ] No duplicated code
* [ ] Proper naming
* [ ] Null safety respected
* [ ] Lint clean

## UI

* [ ] Responsive
* [ ] Loading state
* [ ] Error state
* [ ] Empty state

## Testing

* [ ] Tests added
* [ ] Coverage maintained

---

# Definition of Done (DoD)

A feature is considered complete only when:

* [ ] Requirements documented
* [ ] Architecture follows blueprint
* [ ] Domain layer completed
* [ ] Data layer completed
* [ ] Presentation layer completed
* [ ] Dependency injection registered
* [ ] Routing added
* [ ] Error handling implemented
* [ ] Logging implemented
* [ ] Tests passing
* [ ] Documentation updated
* [ ] Code review approved
* [ ] QA verified
* [ ] Acceptance criteria satisfied

---

# Architecture Rules (Non-Negotiable)

```text
Presentation -> Domain
Presentation -> Notifier

Notifier -> UseCase

UseCase -> Repository Contract

Repository Implementation -> Data Sources

Data Sources -> External Services
```

Never:

```text
Presentation -> Data Source
Presentation -> Repository Implementation
Widget -> API
Page -> Dio
Page -> Firebase
```

Always:

```text
UI
 ↓
Notifier
 ↓
UseCase
 ↓
Repository Contract
 ↓
Repository Implementation
 ↓
Data Source
 ↓
API / Local Storage
```

This blueprint should be treated as the project's feature development standard and referenced for every new feature, PR review, onboarding process, and architecture audit.
