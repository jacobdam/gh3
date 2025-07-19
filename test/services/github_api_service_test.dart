import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:gh3/src/services/github_api_service.dart';
import 'package:gh3/src/services/token_storage.dart';

import 'github_api_service_test.mocks.dart';

@GenerateMocks([http.Client, ITokenStorage])
void main() {
  group('GitHubApiService', () {
    late GitHubApiService service;
    late MockClient mockHttpClient;
    late MockITokenStorage mockTokenStorage;

    const testToken = 'test_token_123';
    const baseUrl = 'https://api.github.com';

    setUp(() {
      mockHttpClient = MockClient();
      mockTokenStorage = MockITokenStorage();
      service = GitHubApiService(mockHttpClient, mockTokenStorage);

      // Default token setup
      when(mockTokenStorage.getToken()).thenAnswer((_) async => testToken);
    });

    group('getAuthenticatedUser', () {
      test('should return authenticated user successfully', () async {
        final userJson = {
          'id': 1,
          'login': 'testuser',
          'name': 'Test User',
          'email': 'test@example.com',
          'bio': 'Test bio',
          'location': 'Test City',
          'company': 'Test Company',
          'blog': 'https://test.com',
          'avatar_url': 'https://github.com/images/error/testuser_happy.gif',
          'html_url': 'https://github.com/testuser',
          'public_repos': 10,
          'public_gists': 5,
          'followers': 100,
          'following': 50,
          'created_at': '2020-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
        };

        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/user'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            jsonEncode(userJson),
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        final result = await service.getAuthenticatedUser();

        expect(result.id, equals(1));
        expect(result.login, equals('testuser'));
        expect(result.name, equals('Test User'));
        expect(result.email, equals('test@example.com'));

        verify(
          mockHttpClient.get(
            Uri.parse('$baseUrl/user'),
            headers: argThat(
              containsPair('Authorization', 'Bearer $testToken'),
              named: 'headers',
            ),
          ),
        ).called(1);
      });

      test('should throw exception when no token available', () async {
        when(mockTokenStorage.getToken()).thenAnswer((_) async => null);

        expect(
          () => service.getAuthenticatedUser(),
          throwsA(
            isA<GitHubApiException>().having(
              (e) => e.message,
              'message',
              'No authentication token available',
            ),
          ),
        );
      });

      test('should handle 401 authentication error', () async {
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(jsonEncode({'message': 'Bad credentials'}), 401),
        );

        expect(
          () => service.getAuthenticatedUser(),
          throwsA(
            isA<GitHubApiException>().having(
              (e) => e.statusCode,
              'statusCode',
              401,
            ),
          ),
        );
      });
    });

    group('getUser', () {
      test('should return user by username successfully', () async {
        const username = 'testuser';
        final userJson = {
          'id': 1,
          'login': username,
          'name': 'Test User',
          'email': null,
          'bio': null,
          'location': null,
          'company': null,
          'blog': null,
          'avatar_url': 'https://github.com/images/error/testuser_happy.gif',
          'html_url': 'https://github.com/testuser',
          'public_repos': 10,
          'public_gists': 5,
          'followers': 100,
          'following': 50,
          'created_at': '2020-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
        };

        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/users/$username'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(userJson), 200));

        final result = await service.getUser(username);

        expect(result.login, equals(username));
        expect(result.id, equals(1));
      });

      test('should throw ArgumentError for empty username', () async {
        expect(() => service.getUser(''), throwsA(isA<ArgumentError>()));
      });

      test('should handle 404 not found error', () async {
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'message': 'Not Found'}), 404),
        );

        expect(
          () => service.getUser('nonexistent'),
          throwsA(
            isA<GitHubApiException>().having(
              (e) => e.statusCode,
              'statusCode',
              404,
            ),
          ),
        );
      });
    });

    group('getFollowing', () {
      test('should return following users successfully', () async {
        final followingJson = [
          {
            'id': 1,
            'login': 'user1',
            'name': 'User One',
            'email': null,
            'bio': null,
            'location': null,
            'company': null,
            'blog': null,
            'avatar_url': 'https://github.com/images/error/user1_happy.gif',
            'html_url': 'https://github.com/user1',
            'public_repos': 5,
            'public_gists': 2,
            'followers': 50,
            'following': 25,
            'created_at': '2020-01-01T00:00:00Z',
            'updated_at': '2023-01-01T00:00:00Z',
          },
          {
            'id': 2,
            'login': 'user2',
            'name': 'User Two',
            'email': null,
            'bio': null,
            'location': null,
            'company': null,
            'blog': null,
            'avatar_url': 'https://github.com/images/error/user2_happy.gif',
            'html_url': 'https://github.com/user2',
            'public_repos': 8,
            'public_gists': 3,
            'followers': 75,
            'following': 30,
            'created_at': '2020-01-01T00:00:00Z',
            'updated_at': '2023-01-01T00:00:00Z',
          },
        ];

        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/user/following?page=1&per_page=30'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(followingJson), 200),
        );

        final result = await service.getFollowing();

        expect(result, hasLength(2));
        expect(result[0].login, equals('user1'));
        expect(result[1].login, equals('user2'));
      });

      test('should handle pagination parameters', () async {
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/user/following?page=2&per_page=10'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode([]), 200));

        await service.getFollowing(page: 2, perPage: 10);

        verify(
          mockHttpClient.get(
            Uri.parse('$baseUrl/user/following?page=2&per_page=10'),
            headers: anyNamed('headers'),
          ),
        ).called(1);
      });

      test('should validate pagination parameters', () async {
        expect(
          () => service.getFollowing(page: 0),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.getFollowing(perPage: 0),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.getFollowing(perPage: 101),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('getUserRepositories', () {
      test('should return user repositories successfully', () async {
        final reposJson = [
          {
            'id': 1,
            'name': 'repo1',
            'full_name': 'testuser/repo1',
            'description': 'Test repository 1',
            'private': false,
            'html_url': 'https://github.com/testuser/repo1',
            'clone_url': 'https://github.com/testuser/repo1.git',
            'language': 'Dart',
            'stargazers_count': 10,
            'watchers_count': 10,
            'forks_count': 2,
            'open_issues_count': 1,
            'size': 1024,
            'default_branch': 'main',
            'has_issues': true,
            'has_projects': true,
            'has_wiki': true,
            'has_pages': false,
            'has_downloads': true,
            'archived': false,
            'disabled': false,
            'created_at': '2020-01-01T00:00:00Z',
            'updated_at': '2023-01-01T00:00:00Z',
            'pushed_at': '2023-01-01T00:00:00Z',
            'owner': {
              'id': 1,
              'login': 'testuser',
              'name': 'Test User',
              'email': null,
              'bio': null,
              'location': null,
              'company': null,
              'blog': null,
              'avatar_url':
                  'https://github.com/images/error/testuser_happy.gif',
              'html_url': 'https://github.com/testuser',
              'public_repos': 10,
              'public_gists': 5,
              'followers': 100,
              'following': 50,
              'created_at': '2020-01-01T00:00:00Z',
              'updated_at': '2023-01-01T00:00:00Z',
            },
          },
        ];

        when(
          mockHttpClient.get(
            Uri.parse(
              '$baseUrl/users/testuser/repos?page=1&per_page=30&sort=updated&direction=desc',
            ),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(reposJson), 200));

        final result = await service.getUserRepositories('testuser');

        expect(result, hasLength(1));
        expect(result[0].name, equals('repo1'));
        expect(result[0].language, equals('Dart'));
        expect(result[0].owner.login, equals('testuser'));
      });

      test('should validate parameters', () async {
        expect(
          () => service.getUserRepositories(''),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.getUserRepositories('user', sort: 'invalid'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.getUserRepositories('user', direction: 'invalid'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('getRepository', () {
      test('should return repository successfully', () async {
        final repoJson = {
          'id': 1,
          'name': 'repo1',
          'full_name': 'testuser/repo1',
          'description': 'Test repository',
          'private': false,
          'html_url': 'https://github.com/testuser/repo1',
          'clone_url': 'https://github.com/testuser/repo1.git',
          'language': 'Dart',
          'stargazers_count': 10,
          'watchers_count': 10,
          'forks_count': 2,
          'open_issues_count': 1,
          'size': 1024,
          'default_branch': 'main',
          'has_issues': true,
          'has_projects': true,
          'has_wiki': true,
          'has_pages': false,
          'has_downloads': true,
          'archived': false,
          'disabled': false,
          'created_at': '2020-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
          'pushed_at': '2023-01-01T00:00:00Z',
          'owner': {
            'id': 1,
            'login': 'testuser',
            'name': 'Test User',
            'email': null,
            'bio': null,
            'location': null,
            'company': null,
            'blog': null,
            'avatar_url': 'https://github.com/images/error/testuser_happy.gif',
            'html_url': 'https://github.com/testuser',
            'public_repos': 10,
            'public_gists': 5,
            'followers': 100,
            'following': 50,
            'created_at': '2020-01-01T00:00:00Z',
            'updated_at': '2023-01-01T00:00:00Z',
          },
        };

        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/repos/testuser/repo1'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(repoJson), 200));

        final result = await service.getRepository('testuser', 'repo1');

        expect(result.fullName, equals('testuser/repo1'));
        expect(result.language, equals('Dart'));
      });

      test('should validate parameters', () async {
        expect(
          () => service.getRepository('', 'repo'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.getRepository('owner', ''),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('getRepositoryReadme', () {
      test('should return decoded README content', () async {
        const readmeContent = '# Test Repository\n\nThis is a test README.';
        final encodedContent = base64Encode(utf8.encode(readmeContent));

        final readmeJson = {
          'name': 'README.md',
          'content': encodedContent,
          'encoding': 'base64',
        };

        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/repos/testuser/repo1/readme'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(readmeJson), 200));

        final result = await service.getRepositoryReadme('testuser', 'repo1');

        expect(result, equals(readmeContent));
      });

      test('should handle README not found', () async {
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/repos/testuser/repo1/readme'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode({'message': 'Not Found'}), 404),
        );

        expect(
          () => service.getRepositoryReadme('testuser', 'repo1'),
          throwsA(
            isA<GitHubApiException>().having(
              (e) => e.message,
              'message',
              contains('README not found'),
            ),
          ),
        );
      });

      test('should validate parameters', () async {
        expect(
          () => service.getRepositoryReadme('', 'repo'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.getRepositoryReadme('owner', ''),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('error handling', () {
      test('should handle rate limiting', () async {
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
            jsonEncode({'message': 'API rate limit exceeded'}),
            403,
            headers: {
              'x-ratelimit-remaining': '0',
              'x-ratelimit-reset': '1640995200',
            },
          ),
        );

        expect(
          () => service.getAuthenticatedUser(),
          throwsA(
            isA<GitHubApiException>().having(
              (e) => e.errorType,
              'errorType',
              'rate_limit',
            ),
          ),
        );
      });

      test('should handle network timeout', () async {
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenThrow(TimeoutException('Request timeout', Duration(seconds: 30)));

        expect(
          () => service.getAuthenticatedUser(),
          throwsA(
            isA<GitHubApiException>().having(
              (e) => e.message,
              'message',
              contains('timed out'),
            ),
          ),
        );
      });

      test('should handle server errors', () async {
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Internal Server Error', 500));

        expect(
          () => service.getAuthenticatedUser(),
          throwsA(
            isA<GitHubApiException>().having(
              (e) => e.statusCode,
              'statusCode',
              500,
            ),
          ),
        );
      });
    });
  });
}
