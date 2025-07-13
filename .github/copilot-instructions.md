# GitHub Copilot Instructions for gh3

This is a Flutter GitHub client app using dependency injection, OAuth device flow, and GoRouter.

## Architecture Overview

**Core Pattern**: Clean architecture with ViewModels + Services + Dependency Injection

- **Services**: Business logic (`AuthService`, `GithubAuthClient`, `TokenStorage`, `ScopeService`)
- **ViewModels**: UI state management (`AuthViewModel`, `LoginViewModel`) extending `ChangeNotifier`
- **Screens**: Flutter widgets consuming ViewModels via `GetIt.instance<T>()`
- **DI**: `injectable` + `get_it` with code generation via `build_runner`

**Key Files**:

- `lib/src/init.dart` + `lib/src/init.config.dart`: DI setup and generated bindings
- `lib/src/env/env.dart` + `env.g.dart`: Environment variables via `envied`
- `main.dart`: GoRouter setup with auth state-driven redirects

## Authentication Flow

Uses **GitHub OAuth Device Flow** (not web flow):

1. `LoginViewModel.login()` calls `GithubAuthClient.createDeviceCode()`
2. User gets code to enter at github.com/login/device
3. App polls `createAccessTokenFromDeviceCode()` with exponential backoff
4. `AuthService` validates token scopes and stores via `ITokenStorage`
5. `AuthViewModel` notifies GoRouter for route redirects

**Critical**: Auth requires `['repo', 'read:user']` scopes. Token validation checks scopes via GitHub API.

## Dependency Injection Patterns

**Registration**: Use `@injectable`, `@lazySingleton` annotations
**Modules**: Environment vars in `EnvModule`, HTTP client in `GithubAuthHttpClientModule`
**Testing**: Always call `GetIt.I.reset()` in `setUp()`, manually register fakes

```dart
// Service registration
@lazySingleton
class AuthService { ... }

// Testing pattern
setUp(() => GetIt.I.reset());
GetIt.I.registerSingleton<AuthService>(FakeAuthService(true));
```

## Testing Conventions

**Unit Tests**: Mock external dependencies (`FakeAuthClient`, `FakeScopeService`)
**Widget Tests**:

- Use `FakeAuthService` with predefined login state
- Call `authViewModel.init()` before widget tests
- Use `tester.pump()` twice for GoRouter redirects to complete

**Key Pattern**: Tests extend real classes (e.g., `FakeAuthService extends AuthService`) rather than using mocktail.

## Development Workflow

**Code Generation** (run after DI/env changes):

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Testing**:

```bash
flutter test                    # All tests
flutter test test/services/     # Specific directory
flutter test --coverage        # With coverage
```

**Environment Setup**: Requires `.env` file with `GITHUB_CLIENT_ID=<your_client_id>`

## GoRouter Integration

Router refreshes on `AuthViewModel` state changes. Three-screen flow:

- `/loading` → auth state unknown
- `/login` → not authenticated
- `/` → authenticated (HomeScreen)

**Redirect Logic**: Check `authVM.loading` first, then `authVM.loggedIn` for routing decisions.

## Common Patterns

**ViewModel Structure**: Always call `notifyListeners()` after state changes
**Error Handling**: Use custom exception hierarchy (`GithubAuthException` with recoverable/non-recoverable types)
**State Management**: ViewModels expose read-only getters, mutations via methods
**Testing**: Create focused fakes that extend real classes rather than full mocks
