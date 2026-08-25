# flutter-users-clean-architecture

Flutter application showcasing Clean Architecture, BLoC state management, REST API integration, dependency injection, and unit testing.

The app fetches a paginated list of users from the [reqres.in](https://reqres.in) demo API and renders it as a list of avatars, names and emails, with loading/error states handled through a BLoC.

## Architecture

The project is organized by feature, with each feature split into `data`, `domain` and `presentation` layers:

```
lib/
  core/
    error/          # Failure / Exception types shared across features
    network/         # Dio-based ApiClient
    injection/        # get_it service locator setup
  features/
    users/
      data/           # Remote data source, models, repository implementation
      domain/         # Entities, repository contract, use cases
      presentation/   # BLoC, pages, widgets
  app.dart
  main.dart
```

- **State management**: `flutter_bloc`
- **HTTP client**: `dio`
- **Dependency injection**: `get_it`
- **Value equality**: `equatable`
- **Testing**: `bloc_test`, `mocktail`

## Getting started

```
flutter pub get
flutter run
```

## Running tests

```
flutter test
```