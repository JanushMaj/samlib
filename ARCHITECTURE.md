# SAMLIB Architecture

## Overview
This project consists only of the Flutter `lib/` directory. The code is organised into several layers:

- `domain` – pure Dart models and service interfaces. No Firebase or UI code here.
- `data` – DTO classes, Firebase services and repositories.
- `feature` – application features with Cubits and UI widgets.
- `shared` – reusable widgets and utilities.

The entry point is `main.dart` which sets up dependency injection via `GetIt` and wires the Cubits with the UI.

## Dependency Injection
Dependencies are registered in `injection.dart` using `GetIt`. Firebase services, repositories and Cubits are declared here. Example excerpt:
```dart
getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
getIt.registerLazySingleton<IAppUserService>(
    () => AppUserFirebaseService(getIt<FirebaseFirestore>()));
...
```
This shows how Firebase instances, services, repositories and Cubits are wired together.

## Data Flow
1. **Firebase Services** in `data/services` access Firestore or Firebase Auth.
2. These services convert raw data through **DTO** classes located in `data/dto`.
3. **Repositories** in `data/repositories` expose domain models and hide the Firebase layer.
4. Feature **Cubits** (e.g. `AuthCubit`, `DateCubit`, `GrafikCubit`, `GrafikElementFormCubit`) use repositories to obtain or persist domain objects and manage UI state.
5. Widgets in `feature/...` subscribe to Cubits and build the UI.

The registration snippet in `injection.dart` wires each layer so that Cubits only depend on repositories and pure domain models.

## Main Cubits
- **AuthCubit** – handles Firebase authentication and user stream from `AppUserRepository`.
- **DateCubit** – resolves the initial day with `GrafikResolver` and updates the selected day.
- **GrafikCubit** – combines data from `GrafikElementRepository`, `VehicleWatcher` and `EmployeeRepository` based on the current day/week.
- **GrafikElementFormCubit** – drives the add/edit form using strategy objects per element type.

## Strategy Pattern
The form uses the Strategy pattern. `GrafikElementRegistry` maps element types to `GrafikElementFormStrategy` implementations:
```dart
static final Map<String, GrafikElementFormStrategy> _strategies = {
  'TimeIssueElement': TimeIssueElementStrategy(),
  'DeliveryPlanningElement': DeliveryPlanningElementStrategy(),
  'TaskElement': TaskElementStrategy(),
  'TaskPlanningElement': TaskPlanningElementStrategy(),
};
```
Each strategy creates default objects, updates fields and saves via `GrafikElementRepository`.

## Manual Serialization
DTO classes implement manual `fromJson`/`toJson` conversions without `json_serializable`. Example from `AppUserDto`:
```dart
factory AppUserDto.fromJson(Map<String, dynamic> json) {
  return AppUserDto(
    id: json['id'] as String? ?? '',
    email: json['email'] as String? ?? '',
    fullName: json['fullName'] as String? ?? '',
    employeeId: json['employeeId'] as String? ?? '',
    role: _stringToUserRole(json['role'] as String?),
    permissionsOverride: (json['permissionsOverride'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), value as bool)) ?? {},
  );
}
```
The DTO converts back to domain objects with a `toDomain()` method.

## Refactoring Notes
- Domain models are now free of Firebase and UI imports.
- `DateCubit` resolves the next working day using `GrafikResolver` instead of relying on UI logic.
- Serialization is explicit through DTOs.

## Unused Components
The repository registers a service that is not referenced elsewhere:
- `TaskIssueMappingService`
This could be removed or integrated in the future.

## Missing Tests
There are currently no unit or widget tests. Adding tests for Cubits and repository logic is a TODO.

