import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/screens/user_details/user_details_route.dart';

void main() {
  group('UserDetailsRoute', () {
    test('should return correct path for various username formats', () {
      final testCases = [
        ('testuser', '/testuser'),
        ('anotheruser', '/anotheruser'),
        ('user-with-dash', '/user-with-dash'),
        ('user123', '/user123'),
        ('user_name', '/user_name'),
      ];

      for (final (username, expectedPath) in testCases) {
        final route = UserDetailsRoute(username);
        expect(
          route.path,
          equals(expectedPath),
          reason: 'Failed for username: $username',
        );
      }
    });
  });
}
