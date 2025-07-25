import 'package:ferry/ferry.dart';
import '../base_viewmodel.dart';
import '__generated__/home_viewmodel.req.gql.dart';
import '../../widgets/user_card/__generated__/user_card.data.gql.dart';

class HomeViewModel extends DisposableViewModel {
  final Client _ferryClient;

  HomeViewModel(this._ferryClient);

  // Current user data state
  GUserCardFragment? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters for current user data
  GUserCardFragment? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load current user data via GraphQL
  Future<void> loadCurrentUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = GGetCurrentUserReq();
      final response = await _ferryClient.request(request).first;

      if (response.hasErrors) {
        _error = response.graphqlErrors?.first.message ?? 'Failed to load user';
      } else {
        _currentUser = response.data?.viewer;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void onDispose() {
    // Clean up resources if needed
  }
}
