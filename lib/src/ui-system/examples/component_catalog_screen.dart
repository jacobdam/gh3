import 'package:flutter/material.dart';
import '../tokens/gh_tokens.dart';
import '../components/gh_card.dart';
import '../components/gh_button.dart';
import '../components/gh_chip.dart';
import '../components/gh_list_tile.dart';
import '../components/gh_search_bar.dart';
import '../widgets/gh_status_badge.dart';
import '../components/gh_text_field.dart';
import '../utils/color_utils.dart';

/// A showcase screen that displays all core UI components in different states.
///
/// This screen serves as an interactive component library where developers
/// can see all components in action with various configurations and states.
class ComponentCatalogScreen extends StatefulWidget {
  const ComponentCatalogScreen({super.key});

  @override
  State<ComponentCatalogScreen> createState() => _ComponentCatalogScreenState();
}

class _ComponentCatalogScreenState extends State<ComponentCatalogScreen> {
  bool _isButtonLoading = false;
  bool _chipSelected = false;
  String _searchText = '';
  String _textFieldValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Component Catalog')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(GHTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('GHCard Component'),
            _buildCardSection(),
            const SizedBox(height: GHTokens.spacing32),

            _buildSectionHeader('GHButton Component'),
            _buildButtonSection(),
            const SizedBox(height: GHTokens.spacing32),

            _buildSectionHeader('GHChip Component'),
            _buildChipSection(),
            const SizedBox(height: GHTokens.spacing32),

            _buildSectionHeader('GHListTile Component'),
            _buildListTileSection(),
            const SizedBox(height: GHTokens.spacing32),

            _buildSectionHeader('GHSearchBar Component'),
            _buildSearchBarSection(),
            const SizedBox(height: GHTokens.spacing32),

            _buildSectionHeader('GHStatusBadge Component'),
            _buildStatusBadgeSection(),
            const SizedBox(height: GHTokens.spacing32),

            _buildSectionHeader('GHTextField Component'),
            _buildTextFieldSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GHTokens.spacing16),
      child: Text(title, style: GHTokens.titleLarge),
    );
  }

  Widget _buildCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Basic Cards', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        // Basic card
        GHCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Basic Card', style: GHTokens.titleMedium),
              const SizedBox(height: GHTokens.spacing8),
              Text(
                'This is a basic card with default styling and padding.',
                style: GHTokens.bodyMedium,
              ),
            ],
          ),
        ),

        const SizedBox(height: GHTokens.spacing16),

        // Interactive card
        GHCard(
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Card tapped!')));
          },
          child: Row(
            children: [
              Icon(
                Icons.touch_app,
                color: Theme.of(context).colorScheme.primary,
                size: GHTokens.iconSize24,
              ),
              const SizedBox(width: GHTokens.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Interactive Card', style: GHTokens.titleMedium),
                    const SizedBox(height: GHTokens.spacing4),
                    Text(
                      'Tap this card to see the interaction feedback.',
                      style: GHTokens.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: GHTokens.iconSize18,
              ),
            ],
          ),
        ),

        const SizedBox(height: GHTokens.spacing16),

        // Custom elevation card
        GHCard(
          elevation: GHTokens.elevation3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Elevated Card', style: GHTokens.titleMedium),
              const SizedBox(height: GHTokens.spacing8),
              Text(
                'This card has higher elevation (3dp) for more prominence.',
                style: GHTokens.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Button States', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        // Primary buttons
        Wrap(
          spacing: GHTokens.spacing12,
          runSpacing: GHTokens.spacing12,
          children: [
            GHButton(
              label: 'Star',
              icon: Icons.star_border,
              onPressed: () => _showSnackBar('Star button pressed'),
            ),
            GHButton(
              label: 'Watch',
              icon: Icons.visibility,
              onPressed: () => _showSnackBar('Watch button pressed'),
            ),
            GHButton(
              label: 'Fork',
              icon: Icons.fork_right,
              onPressed: () => _showSnackBar('Fork button pressed'),
            ),
          ],
        ),

        const SizedBox(height: GHTokens.spacing16),

        // Secondary buttons
        Wrap(
          spacing: GHTokens.spacing12,
          runSpacing: GHTokens.spacing12,
          children: [
            GHButton(
              label: 'Follow',
              style: GHButtonStyle.secondary,
              icon: Icons.person_add,
              onPressed: () => _showSnackBar('Follow button pressed'),
            ),
            GHButton(
              label: 'Clone',
              style: GHButtonStyle.secondary,
              icon: Icons.download,
              onPressed: () => _showSnackBar('Clone button pressed'),
            ),
            GHButton(
              label: 'Subscribe',
              style: GHButtonStyle.secondary,
              icon: Icons.notifications,
              onPressed: () => _showSnackBar('Subscribe button pressed'),
            ),
          ],
        ),

        const SizedBox(height: GHTokens.spacing16),

        // Loading and disabled states
        Row(
          children: [
            GHButton(
              label: 'Loading',
              isLoading: _isButtonLoading,
              onPressed: () {
                setState(() {
                  _isButtonLoading = true;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      _isButtonLoading = false;
                    });
                  }
                });
              },
            ),
            const SizedBox(width: GHTokens.spacing12),
            const GHButton(label: 'Disabled', onPressed: null),
          ],
        ),
      ],
    );
  }

  Widget _buildChipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filter Chips', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        // Basic chips
        Wrap(
          spacing: GHTokens.spacing8,
          runSpacing: GHTokens.spacing8,
          children: [
            GHChip(
              label: 'Open',
              count: 23,
              isSelected: _chipSelected,
              onTap: () {
                setState(() {
                  _chipSelected = !_chipSelected;
                });
              },
            ),
            const GHChip(label: 'Closed', count: 145),
            const GHChip(label: 'bug', colorIndicator: Colors.red, count: 12),
            const GHChip(
              label: 'enhancement',
              colorIndicator: Colors.blue,
              count: 8,
            ),
            const GHChip(
              label: 'documentation',
              colorIndicator: Colors.green,
              count: 5,
            ),
          ],
        ),

        const SizedBox(height: GHTokens.spacing16),

        Text('Language Chips', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        // Language chips
        Wrap(
          spacing: GHTokens.spacing8,
          runSpacing: GHTokens.spacing8,
          children: ColorUtils.getPopularLanguages().take(8).map((langInfo) {
            return GHChip(
              label: langInfo['language'] as String,
              colorIndicator: langInfo['color'] as Color,
              isSelectable: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildListTileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('List Items', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(GHTokens.radius8),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              GHListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: const Text('John Doe'),
                subtitle: const Text('@johndoe • Joined 2 years ago'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showSnackBar('User tapped'),
              ),
              Divider(
                height: 1,
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
              GHListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorUtils.getLanguageColor('JavaScript'),
                    borderRadius: BorderRadius.circular(GHTokens.radius8),
                  ),
                  child: const Icon(Icons.code, color: Colors.white),
                ),
                title: const Text('awesome-project'),
                subtitle: const Text('A really awesome JavaScript project'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: GHTokens.iconSize16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: GHTokens.spacing4),
                    Text(
                      '1.2k',
                      style: GHTokens.labelMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                onTap: () => _showSnackBar('Repository tapped'),
              ),
              Divider(
                height: 1,
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
              GHListTile(
                leading: Icon(
                  Icons.bug_report,
                  color: GHTokens.error,
                  size: GHTokens.iconSize24,
                ),
                title: const Text('Fix critical bug in authentication'),
                subtitle: const Text(
                  'Issue #123 • opened 2 hours ago by @alice',
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GHTokens.spacing8,
                    vertical: GHTokens.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: GHTokens.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(GHTokens.radius12),
                  ),
                  child: Text(
                    'Open',
                    style: GHTokens.labelMedium.copyWith(color: GHTokens.error),
                  ),
                ),
                onTap: () => _showSnackBar('Issue tapped'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search Inputs', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        GHSearchBar(
          hintText: 'Search repositories, users, issues...',
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
          onSubmitted: (value) => _showSnackBar('Search submitted: $value'),
        ),

        const SizedBox(height: GHTokens.spacing16),

        GHSearchBar(
          hintText: 'Search with custom icon',
          prefixIcon: Icons.filter_list,
          suffixIcon: Icons.tune,
          onSuffixIconTap: () => _showSnackBar('Filter options tapped'),
          onChanged: (value) {},
        ),

        const SizedBox(height: GHTokens.spacing16),

        const GHSearchBar(hintText: 'Disabled search bar', enabled: false),

        if (_searchText.isNotEmpty) ...[
          const SizedBox(height: GHTokens.spacing12),
          Text(
            'Search text: "$_searchText"',
            style: GHTokens.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status Indicators', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        Wrap(
          spacing: GHTokens.spacing12,
          runSpacing: GHTokens.spacing12,
          children: const [
            GHStatusBadge(status: GHStatusType.open),
            GHStatusBadge(status: GHStatusType.closed),
            GHStatusBadge(status: GHStatusType.merged),
            GHStatusBadge(status: GHStatusType.draft),
          ],
        ),

        const SizedBox(height: GHTokens.spacing16),

        Text('Custom Status Labels', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        const Wrap(
          spacing: GHTokens.spacing12,
          runSpacing: GHTokens.spacing12,
          children: [
            GHStatusBadge(
              status: GHStatusType.open,
              customLabel: 'In Progress',
            ),
            GHStatusBadge(status: GHStatusType.merged, customLabel: 'Approved'),
            GHStatusBadge(
              status: GHStatusType.draft,
              customLabel: 'Pending Review',
            ),
            GHStatusBadge(status: GHStatusType.closed, customLabel: 'Rejected'),
          ],
        ),

        const SizedBox(height: GHTokens.spacing16),

        Text('Without Icons', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        const Wrap(
          spacing: GHTokens.spacing12,
          runSpacing: GHTokens.spacing12,
          children: [
            GHStatusBadge(status: GHStatusType.open),
            GHStatusBadge(status: GHStatusType.closed),
            GHStatusBadge(status: GHStatusType.merged),
            GHStatusBadge(status: GHStatusType.draft),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFieldSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Form Inputs', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing12),

        GHTextField(
          labelText: 'Repository Name',
          hintText: 'Enter repository name',
          helperText: 'Choose a unique name for your repository',
          required: true,
          onChanged: (value) {
            setState(() {
              _textFieldValue = value;
            });
          },
        ),

        const SizedBox(height: GHTokens.spacing16),

        const GHTextField(
          labelText: 'Description',
          hintText: 'Brief description of your repository',
          maxLines: 3,
          minLines: 3,
        ),

        const SizedBox(height: GHTokens.spacing16),

        const GHTextField(
          labelText: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
          prefixIcon: Icons.lock,
        ),

        const SizedBox(height: GHTokens.spacing16),

        const GHTextField(
          labelText: 'Email',
          hintText: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email,
        ),

        const SizedBox(height: GHTokens.spacing16),

        const GHTextField(
          labelText: 'Error State',
          hintText: 'This field has an error',
          errorText: 'This field is required',
          prefixIcon: Icons.error,
        ),

        const SizedBox(height: GHTokens.spacing16),

        const GHTextField(
          labelText: 'Disabled Field',
          hintText: 'This field is disabled',
          enabled: false,
          initialValue: 'Disabled value',
        ),

        if (_textFieldValue.isNotEmpty) ...[
          const SizedBox(height: GHTokens.spacing12),
          Text(
            'Repository name: "$_textFieldValue"',
            style: GHTokens.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
