# Architecture Decision Record: ViewModel Dependency Injection

## Status

Implemented

## Context

Previously, ViewModels were using `getIt` directly to resolve their dependencies, which created several issues:

1. **Hidden Dependencies**: When ViewModels used `GetIt.instance<T>()`, their dependencies weren't explicit
2. **Testing Complexity**: Setting up tests required complex mocking of the entire DI container
3. **Tight Coupling**: UI components were tightly coupled to the dependency injection framework

## Decision

We will use a **hybrid dependency injection approach**:

- **Services**: Registered with dependency injection (`get_it` + `injectable`)
- **ViewModels**: Created manually and passed through GoRouter builders
- **Screens**: Receive ViewModels through constructor parameters

## Implementation Details

### Before (Problems)

```dart
// ❌ Hidden dependencies in ViewModels
@injectable
class LoginViewModel {
  LoginViewModel() {
    // Dependencies resolved internally - not visible
  }
}

// ❌ UI components using DI directly
class LoginScreen extends StatefulWidget {
  @override
  void initState() {
    _viewModel = GetIt.instance<LoginViewModel>(); // Hidden dependency
  }
}
```

### After (Solution)

```dart
// ✅ Explicit dependencies
class LoginViewModel {
  final GithubAuthClient _authClient;
  final AuthService _authService;
  final AuthViewModel _authViewModel;

  LoginViewModel(this._authClient, this._authService, this._authViewModel);
}

// ✅ Dependencies passed through constructor
class LoginScreen extends StatefulWidget {
  final LoginViewModel viewModel;
  const LoginScreen({required this.viewModel});
}

// ✅ Router creates ViewModels with explicit dependencies
GoRoute(
  path: '/login',
  builder: (context, state) => LoginScreen(
    viewModel: LoginViewModel(
      getIt<GithubAuthClient>(),  // Service from DI
      getIt<AuthService>(),       // Service from DI
      authViewModel,              // ViewModel passed down
    ),
  ),
)
```

## Benefits

1. **Explicit Dependencies**: All dependencies are visible in the router configuration
2. **Easy Testing**: ViewModels can be created with mock dependencies without DI setup
3. **Better Separation**: UI components don't know about the DI container
4. **Maintainability**: Dependency changes are visible and explicit

## Testing Impact

Tests are now cleaner and more focused:

```dart
// ✅ Easy to test with explicit dependencies
test('login functionality', () {
  final mockAuthClient = MockGithubAuthClient();
  final mockAuthService = MockAuthService();
  final mockAuthViewModel = MockAuthViewModel();

  final loginViewModel = LoginViewModel(
    mockAuthClient,
    mockAuthService,
    mockAuthViewModel,
  );

  // Test the ViewModel directly
});
```

## Files Changed

- `/lib/src/viewmodels/auth_viewmodel.dart` - Removed `@lazySingleton`
- `/lib/src/viewmodels/login_viewmodel.dart` - Removed `@injectable`
- `/lib/src/screens/login_screen.dart` - Accept ViewModel via constructor
- `/lib/src/screens/home_screen.dart` - Accept AuthViewModel for logout
- `/lib/main.dart` - Create ViewModels in router configuration
- `/test/app_start_test.dart` - Updated to use new API
- `/README.md` - Updated with architecture documentation

## Consequences

- **Positive**: Clearer dependency flow, easier testing, better separation of concerns
- **Negative**: Slightly more verbose router configuration (but this improves clarity)
- **Mitigation**: Router configuration clearly shows all dependencies, making the app easier to understand
