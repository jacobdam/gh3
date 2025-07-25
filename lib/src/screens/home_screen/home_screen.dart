import 'package:flutter/material.dart';
import 'home_viewmodel.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';
import 'widgets/section_header.dart';
import 'widgets/work_item_list_tile.dart';
import '../../widgets/user_card/user_card.dart';

class HomeScreen extends StatefulWidget {
  final AuthViewModel authViewModel;
  final HomeViewModel homeViewModel;

  const HomeScreen({
    super.key,
    required this.authViewModel,
    required this.homeViewModel,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();
    _homeViewModel = widget.homeViewModel;
    _homeViewModel.addListener(_onHomeViewModelChanged);
    _homeViewModel.loadCurrentUser();
  }

  @override
  void dispose() {
    _homeViewModel.removeListener(_onHomeViewModelChanged);
    _homeViewModel.dispose();
    super.dispose();
  }

  void _onHomeViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildCurrentUserCard() {
    if (_homeViewModel.isLoading) {
      return const Card(
        child: ListTile(
          leading: CircleAvatar(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          title: Text('Loading...'),
          subtitle: Text('Fetching user data'),
        ),
      );
    }

    if (_homeViewModel.error != null) {
      return Card(
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.error),
          ),
          title: const Text('Error loading user'),
          subtitle: Text(_homeViewModel.error!),
        ),
      );
    }

    if (_homeViewModel.currentUser != null) {
      return UserCard.fromFragment(_homeViewModel.currentUser!);
    }

    return const Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text('No user data'),
        subtitle: Text('Unable to load user information'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            title: const Text('Home'),
            floating: true,
            snap: true,
            pinned: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await widget.authViewModel.logout();
                },
              ),
            ],
          ),

          // Page Content
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // My Profile Section
                const SectionHeader(title: 'My profile'),
                const SizedBox(height: 8),
                _buildCurrentUserCard(),
                const SizedBox(height: 24),

                // My Work Section
                const SectionHeader(title: 'My work'),
                const SizedBox(height: 8),

                // Work Items List (static UI definition)
                const WorkItemListTile(title: 'Issues', icon: Icons.bug_report),
                const WorkItemListTile(
                  title: 'Pull requests',
                  icon: Icons.call_merge,
                ),
                const WorkItemListTile(title: 'Discussions', icon: Icons.forum),
                const WorkItemListTile(
                  title: 'Projects',
                  icon: Icons.folder_open,
                ),
                const WorkItemListTile(
                  title: 'Repositories',
                  icon: Icons.source,
                ),
                const WorkItemListTile(
                  title: 'Organizations',
                  icon: Icons.business,
                ),
                const WorkItemListTile(title: 'Starred', icon: Icons.star),

                // Bottom padding for scrolling comfort
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
