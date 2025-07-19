import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ferry/ferry.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:gh3/src/screens/home_screen/__generated__/home_viewmodel.data.gql.dart';
import 'package:gh3/src/screens/home_screen/__generated__/home_viewmodel.var.gql.dart';

import 'package:gh3/main.dart';
import 'package:gh3/src/services/auth_service.dart';
import 'package:gh3/src/screens/home_screen/home_screen.dart';
import 'package:gh3/src/screens/login_screen.dart';
import 'package:gh3/src/services/github_auth_client.dart';
import 'package:gh3/src/services/token_storage.dart';
import 'package:gh3/src/services/scope_service.dart';
import 'package:gh3/src/services/github_api_service.dart';
import 'package:gh3/src/models/github_user.dart';
import 'package:gh3/src/models/github_repository.dart';
import 'package:gh3/src/viewmodels/login_viewmodel.dart';
import 'package:gh3/src/viewmodels/auth_viewmodel.dart';

@GenerateNiceMocks([MockSpec<Client>()])
import 'app_start_test.mocks.dart';

/// Dummy implementations to satisfy AuthService constructor, not used directly.
class DummyAuthClient implements GithubAuthClient {
  @override
  Future<GithubDeviceCodeResult> createDeviceCode(List<String> scopes) {
    throw UnimplementedError();
  }

  @override
  Future<String> createAccessTokenFromDeviceCode(String deviceCode) {
    throw UnimplementedError();
  }
}

class DummyTokenStorage implements ITokenStorage {
  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> saveToken(String token) async {}

  @override
  Future<void> deleteToken() async {}
}

class DummyScopeService implements IScopeService {
  @override
  Future<List<String>> getScopesFromAccessToken(String accessToken) async => [];
}

class DummyGitHubApiService implements GitHubApiService {
  @override
  Future<GitHubUser> getAuthenticatedUser() async => throw UnimplementedError();

  @override
  Future<GitHubUser> getUser(String username) async =>
      throw UnimplementedError();

  @override
  Future<List<GitHubUser>> getFollowing({
    int page = 1,
    int perPage = 30,
  }) async => [];

  @override
  Future<List<GitHubUser>> getUserFollowers(
    String username, {
    int page = 1,
    int perPage = 30,
  }) async => [];

  @override
  Future<List<GitHubRepository>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 30,
    String sort = 'updated',
    String direction = 'desc',
  }) async => [];

  @override
  Future<GitHubRepository> getRepository(String owner, String repo) async =>
      throw UnimplementedError();

  @override
  Future<String> getRepositoryReadme(String owner, String repo) async =>
      throw UnimplementedError();
}

/// Fake AuthService that simulates init and login state.
class FakeAuthService extends AuthService {
  final bool _loggedIn;
  FakeAuthService(this._loggedIn)
    : super(DummyAuthClient(), DummyTokenStorage(), DummyScopeService());

  @override
  Future<void> init() async {
    // No delay for testing
  }

  @override
  bool get isLoggedIn => _loggedIn;
}

T anyRequest<T>() => any as T;

void main() {
  setUp(() {
    // Reset DI before each test
    GetIt.I.reset();
  });

  testWidgets('eventually shows HomeScreen when already logged in', (
    WidgetTester tester,
  ) async {
    // Register required dependencies
    final fakeAuthService = FakeAuthService(true);
    final dummyAuthClient = DummyAuthClient();
    final mockFerryClient = MockClient();
    when(
      mockFerryClient.request<GGetFollowingData, GGetFollowingVars>(any),
    ).thenAnswer((_) => const Stream.empty());

    GetIt.I.registerSingleton<AuthService>(fakeAuthService);
    GetIt.I.registerSingleton<GithubAuthClient>(dummyAuthClient);
    GetIt.I.registerSingleton<Client>(mockFerryClient);

    // Create and initialize AuthViewModel
    final authViewModel = AuthViewModel(fakeAuthService);
    await authViewModel.init();
    GetIt.I.registerSingleton(authViewModel);

    GetIt.I.registerLazySingleton<LoginViewModel>(
      () => LoginViewModel(dummyAuthClient, fakeAuthService, authViewModel),
    );

    await tester.pumpWidget(
      MyApp(
        authViewModel: authViewModel,
        authService: fakeAuthService,
        githubAuthClient: dummyAuthClient,
        githubApiService: DummyGitHubApiService(),
        homeViewModel: HomeViewModel(mockFerryClient),
      ),
    );

    // Wait for router redirects to complete
    await tester.pump();
    await tester.pump();

    // Should show home screen
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('eventually shows LoginScreen when not logged in', (
    WidgetTester tester,
  ) async {
    // Register required dependencies
    final fakeAuthService = FakeAuthService(false);
    final dummyAuthClient = DummyAuthClient();
    final mockFerryClient = MockClient();
    // ignore: argument_type_not_assignable, avoid_redundant_argument_values
    when(
      mockFerryClient.request<GGetFollowingData, GGetFollowingVars>(captureAny),
    ).thenAnswer((_) => const Stream.empty());

    GetIt.I.registerSingleton<AuthService>(fakeAuthService);
    GetIt.I.registerSingleton<GithubAuthClient>(dummyAuthClient);
    GetIt.I.registerSingleton<Client>(mockFerryClient);

    // Create and initialize AuthViewModel
    final authViewModel = AuthViewModel(fakeAuthService);
    await authViewModel.init();
    GetIt.I.registerSingleton(authViewModel);

    GetIt.I.registerLazySingleton<LoginViewModel>(
      () => LoginViewModel(dummyAuthClient, fakeAuthService, authViewModel),
    );

    await tester.pumpWidget(
      MyApp(
        authViewModel: authViewModel,
        authService: fakeAuthService,
        githubAuthClient: dummyAuthClient,
        githubApiService: DummyGitHubApiService(),
        homeViewModel: HomeViewModel(mockFerryClient),
      ),
    );

    // Wait for router redirects to complete
    await tester.pump();
    await tester.pump();

    // Should show login screen
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
