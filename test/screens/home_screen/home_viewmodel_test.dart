import 'package:flutter_test/flutter_test.dart';
import 'package:gh3/src/screens/home_screen/home_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ferry/ferry.dart';
import 'package:gh3/src/screens/home_screen/__generated__/home_viewmodel.data.gql.dart';
import 'package:gh3/src/screens/home_screen/__generated__/home_viewmodel.var.gql.dart';

@GenerateNiceMocks([MockSpec<Client>()])
import 'home_viewmodel_test.mocks.dart';

void main() {
  group('HomeViewModel', () {
    late MockClient mockClient;
    late HomeViewModel viewModel;

    setUp(() {
      mockClient = MockClient();
      when(
        mockClient.request<GGetFollowingData, GGetFollowingVars>(any),
      ).thenAnswer((_) => const Stream.empty());
      viewModel = HomeViewModel(mockClient);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initial State', () {
      test('should initialize with correct default values', () {
        expect(viewModel.isLoading, isTrue);
        expect(viewModel.isEmpty, isTrue);
        expect(viewModel.followingUsers, isEmpty);
        expect(viewModel.error, isNull);
        expect(viewModel.hasMore, isTrue);
        expect(viewModel.following, isNull);
      });
    });

    group('Data Loading Scenarios', () {
      test('should have correct initial state properties', () {
        expect(viewModel.isLoading, isTrue);
        expect(viewModel.isEmpty, isTrue);
        expect(viewModel.hasMore, isTrue);
      });
    });

    group('Pagination Scenarios', () {
      test('should have correct pagination state', () {
        expect(viewModel.hasMore, isTrue);
      });
    });

    group('Error Handling Scenarios', () {
      test('should have correct initial error state', () {
        expect(viewModel.error, isNull);
      });
    });

    group('Refresh Scenarios', () {
      test('should have correct initial state for refresh', () {
        expect(viewModel.followingUsers, isEmpty);
        expect(viewModel.isEmpty, isTrue);
      });
    });

    group('Data Consistency Scenarios', () {
      test('should handle empty data correctly', () {
        expect(viewModel.isEmpty, isTrue);
        expect(viewModel.followingUsers, isEmpty);
      });
    });
  });
}
