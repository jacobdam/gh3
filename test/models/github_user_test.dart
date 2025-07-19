import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/models/github_user.dart';

void main() {
  group('GitHubUser', () {
    test('should create GitHubUser from complete JSON', () {
      final json = {
        'id': 123,
        'login': 'testuser',
        'name': 'Test User',
        'email': 'test@example.com',
        'bio': 'Test bio',
        'location': 'Test Location',
        'company': 'Test Company',
        'blog': 'https://test.com',
        'avatar_url': 'https://avatar.com/test.jpg',
        'html_url': 'https://github.com/testuser',
        'public_repos': 10,
        'public_gists': 5,
        'followers': 100,
        'following': 50,
        'created_at': '2020-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
      };

      final user = GitHubUser.fromJson(json);

      expect(user.id, 123);
      expect(user.login, 'testuser');
      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.bio, 'Test bio');
      expect(user.location, 'Test Location');
      expect(user.company, 'Test Company');
      expect(user.blog, 'https://test.com');
      expect(user.avatarUrl, 'https://avatar.com/test.jpg');
      expect(user.htmlUrl, 'https://github.com/testuser');
      expect(user.publicRepos, 10);
      expect(user.publicGists, 5);
      expect(user.followers, 100);
      expect(user.following, 50);
      expect(user.createdAt, DateTime.parse('2020-01-01T00:00:00Z'));
      expect(user.updatedAt, DateTime.parse('2023-01-01T00:00:00Z'));
    });

    test('should handle null values gracefully (following list response)', () {
      // This simulates the response from /user/following endpoint
      // which only includes basic user info
      final json = {
        'id': 456,
        'login': 'followeduser',
        'avatar_url': 'https://avatar.com/followed.jpg',
        'html_url': 'https://github.com/followeduser',
        // These fields are null or missing in following list responses
        'name': null,
        'email': null,
        'bio': null,
        'location': null,
        'company': null,
        'blog': null,
        'public_repos': null,
        'public_gists': null,
        'followers': null,
        'following': null,
        'created_at': null,
        'updated_at': null,
      };

      final user = GitHubUser.fromJson(json);

      expect(user.id, 456);
      expect(user.login, 'followeduser');
      expect(user.name, null);
      expect(user.email, null);
      expect(user.bio, null);
      expect(user.location, null);
      expect(user.company, null);
      expect(user.blog, null);
      expect(user.avatarUrl, 'https://avatar.com/followed.jpg');
      expect(user.htmlUrl, 'https://github.com/followeduser');
      expect(user.publicRepos, 0); // Default value
      expect(user.publicGists, 0); // Default value
      expect(user.followers, 0); // Default value
      expect(user.following, 0); // Default value
      // createdAt and updatedAt should be set to current time when null
      expect(user.createdAt, isA<DateTime>());
      expect(user.updatedAt, isA<DateTime>());
    });

    test('should handle missing fields (minimal response)', () {
      // This simulates a minimal response with only required fields
      final json = {'id': 789, 'login': 'minimaluser'};

      final user = GitHubUser.fromJson(json);

      expect(user.id, 789);
      expect(user.login, 'minimaluser');
      expect(user.name, null);
      expect(user.avatarUrl, ''); // Default empty string
      expect(user.htmlUrl, ''); // Default empty string
      expect(user.publicRepos, 0);
      expect(user.publicGists, 0);
      expect(user.followers, 0);
      expect(user.following, 0);
      expect(user.createdAt, isA<DateTime>());
      expect(user.updatedAt, isA<DateTime>());
    });

    test('should convert to JSON correctly', () {
      final user = GitHubUser(
        id: 123,
        login: 'testuser',
        name: 'Test User',
        email: 'test@example.com',
        bio: 'Test bio',
        location: 'Test Location',
        company: 'Test Company',
        blog: 'https://test.com',
        avatarUrl: 'https://avatar.com/test.jpg',
        htmlUrl: 'https://github.com/testuser',
        publicRepos: 10,
        publicGists: 5,
        followers: 100,
        following: 50,
        createdAt: DateTime.parse('2020-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      final json = user.toJson();

      expect(json['id'], 123);
      expect(json['login'], 'testuser');
      expect(json['name'], 'Test User');
      expect(json['email'], 'test@example.com');
      expect(json['bio'], 'Test bio');
      expect(json['location'], 'Test Location');
      expect(json['company'], 'Test Company');
      expect(json['blog'], 'https://test.com');
      expect(json['avatar_url'], 'https://avatar.com/test.jpg');
      expect(json['html_url'], 'https://github.com/testuser');
      expect(json['public_repos'], 10);
      expect(json['public_gists'], 5);
      expect(json['followers'], 100);
      expect(json['following'], 50);
      expect(json['created_at'], '2020-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-01T00:00:00.000Z');
    });

    test('should implement equality correctly', () {
      final user1 = GitHubUser(
        id: 123,
        login: 'testuser',
        avatarUrl: 'https://avatar.com/test.jpg',
        htmlUrl: 'https://github.com/testuser',
        publicRepos: 10,
        publicGists: 5,
        followers: 100,
        following: 50,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final user2 = GitHubUser(
        id: 123,
        login: 'differentuser',
        avatarUrl: 'https://avatar.com/different.jpg',
        htmlUrl: 'https://github.com/differentuser',
        publicRepos: 20,
        publicGists: 10,
        followers: 200,
        following: 100,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final user3 = GitHubUser(
        id: 456,
        login: 'testuser',
        avatarUrl: 'https://avatar.com/test.jpg',
        htmlUrl: 'https://github.com/testuser',
        publicRepos: 10,
        publicGists: 5,
        followers: 100,
        following: 50,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(user1, equals(user2)); // Same ID
      expect(user1, isNot(equals(user3))); // Different ID
      expect(user1.hashCode, equals(user2.hashCode)); // Same ID
      expect(user1.hashCode, isNot(equals(user3.hashCode))); // Different ID
    });
  });
}
