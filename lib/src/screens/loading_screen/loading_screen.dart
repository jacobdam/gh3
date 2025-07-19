import 'package:flutter/material.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';

/// Loading screen shown during initialization, listens to AuthViewModel.
class LoadingScreen extends StatefulWidget {
  final AuthViewModel authViewModel;

  const LoadingScreen({super.key, required this.authViewModel});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late final AuthViewModel _authViewModel;

  void _onViewModelChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    _authViewModel = widget.authViewModel;
    _authViewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _authViewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _authViewModel.loading;
    // Optionally, you can add a message property to AuthViewModel if needed
    // final message = _authViewModel.message;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) const CircularProgressIndicator(),
            // if (message != null) ...[
            //   const SizedBox(height: 16),
            //   Text(
            //     message,
            //     style: Theme.of(context).textTheme.bodyLarge,
            //     textAlign: TextAlign.center,
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
