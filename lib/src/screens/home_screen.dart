import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  final AuthViewModel authViewModel;

  const HomeScreen({super.key, required this.authViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
            },
          ),
        ],
      ),
      body: const Center(child: Text('Hello World')),
    );
  }
}
