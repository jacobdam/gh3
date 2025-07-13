# gh3

A Flutter project implementing GitHub authentication with a clean architecture.

## Architecture

### Dependency Injection Strategy

This project follows a **service-only dependency injection** pattern with **manual ViewModel instantiation** for better testability and clearer dependency flow.

#### Key Principles:

1. **Services are registered with dependency injection** (`get_it` + `injectable`)

   - `AuthService`, `GithubAuthClient`, `TokenStorage`, etc.
   - These are reusable business logic components that don't depend on UI state

2. **ViewModels are created manually** and passed through GoRouter

   - ViewModels receive their dependencies through constructors
   - GoRoute builders instantiate ViewModels with required services
   - This makes the dependency flow explicit and easier to test

3. **Screens receive ViewModels through constructors**
   - No `GetIt.instance<T>()` calls in UI components
   - Dependencies are clear and explicit
   - Easy to mock in tests

#### Benefits:

- **Testability**: Easy to create ViewModels with mock dependencies in tests
- **Clarity**: Dependency flow is explicit and visible in the routing configuration
- **Maintainability**: Changes to ViewModel dependencies are visible in the router
- **Separation of Concerns**: UI components don't know about the DI container

#### Example:

```dart
// ❌ Old way - implicit dependency
class LoginScreen extends StatefulWidget {
  @override
  void initState() {
    _viewModel = GetIt.instance<LoginViewModel>(); // Hidden dependency
  }
}

// ✅ New way - explicit dependency
class LoginScreen extends StatefulWidget {
  final LoginViewModel viewModel;
  const LoginScreen({required this.viewModel});
}

// Router configuration makes dependencies explicit
GoRoute(
  path: '/login',
  builder: (context, state) => LoginScreen(
    viewModel: LoginViewModel(
      githubAuthClient,  // Clear dependency
      authService,       // Clear dependency
      authViewModel,     // Clear dependency
    ),
  ),
)
```

## Project Structure

- `lib/src/services/` - Business logic services (registered with DI)
- `lib/src/viewmodels/` - UI state management (manually instantiated)
- `lib/src/screens/` - UI components (receive dependencies via constructor)
- `lib/main.dart` - App entry point and routing configuration

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Testing

All tests pass and follow the same architectural principles:

```bash
flutter test
```

## Code Quality

This project maintains high code quality standards:

```bash
flutter analyze
```
