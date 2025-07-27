import 'package:flutter/material.dart';
import '../tokens/gh_tokens.dart';
import '../components/gh_card.dart';
import '../components/gh_button.dart';

/// UAT home screen that provides navigation to design system showcase screens.
///
/// This screen serves as the main entry point for stakeholders and developers
/// to access all design system components and documentation during UAT.
class UATHomeScreen extends StatelessWidget {
  /// Callback to toggle between light and dark themes
  final VoidCallback onThemeToggle;

  const UATHomeScreen({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GH3 Design System - UAT'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
            tooltip: isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(GHTokens.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section
            Text(
              'Design System Showcase',
              style: GHTokens.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GHTokens.spacing12),
            Text(
              'Explore the complete GitHub mobile design system with interactive components and design tokens.',
              style: GHTokens.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GHTokens.spacing32),

            // Navigation cards
            _buildNavigationCard(
              context,
              title: 'Design Tokens',
              description:
                  'Colors, typography, spacing, and visual foundations',
              icon: Icons.palette,
              route: '/tokens',
              isPrimary: true,
            ),
            const SizedBox(height: GHTokens.spacing16),

            _buildNavigationCard(
              context,
              title: 'Component Catalog',
              description: 'Interactive showcase of all UI components',
              icon: Icons.widgets,
              route: '/components',
              isPrimary: false,
            ),

            const SizedBox(height: GHTokens.spacing32),

            // Information section
            _buildInfoSection(context),

            const SizedBox(height: GHTokens.spacing32),

            // Quick actions
            _buildQuickActionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String route,
    required bool isPrimary,
  }) {
    return GHCard(
      onTap: () => Navigator.pushNamed(context, route),
      child: Padding(
        padding: const EdgeInsets.all(GHTokens.spacing4),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isPrimary
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(GHTokens.radius12),
              ),
              child: Icon(
                icon,
                size: GHTokens.iconSize32,
                color: isPrimary
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: GHTokens.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GHTokens.titleMedium),
                  const SizedBox(height: GHTokens.spacing4),
                  Text(
                    description,
                    style: GHTokens.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: GHTokens.iconSize24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return GHCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
                size: GHTokens.iconSize24,
              ),
              const SizedBox(width: GHTokens.spacing8),
              Text('About This UAT Build', style: GHTokens.titleMedium),
            ],
          ),
          const SizedBox(height: GHTokens.spacing12),
          Text(
            'This is a dedicated User Acceptance Testing build of the GH3 design system. '
            'It showcases all design tokens, components, and patterns that will be used '
            'throughout the GitHub mobile application.',
            style: GHTokens.bodyMedium,
          ),
          const SizedBox(height: GHTokens.spacing16),

          // Feature highlights
          _buildFeatureItem(
            context,
            'Material Design 3 Integration',
            'Full MD3 theming with GitHub brand colors',
          ),
          const SizedBox(height: GHTokens.spacing8),
          _buildFeatureItem(
            context,
            'Cross-Platform Compatibility',
            'Consistent experience across web and mobile',
          ),
          const SizedBox(height: GHTokens.spacing8),
          _buildFeatureItem(
            context,
            'Accessibility Compliant',
            '48dp touch targets and WCAG 2.1 AA compliance',
          ),
          const SizedBox(height: GHTokens.spacing8),
          _buildFeatureItem(
            context,
            'Interactive Components',
            'All components support user interaction and feedback',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: GHTokens.spacing8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GHTokens.labelLarge),
              Text(
                description,
                style: GHTokens.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: GHTokens.titleMedium),
        const SizedBox(height: GHTokens.spacing16),

        Row(
          children: [
            Expanded(
              child: GHButton(
                label: 'View Tokens',
                icon: Icons.palette,
                onPressed: () => Navigator.pushNamed(context, '/tokens'),
              ),
            ),
            const SizedBox(width: GHTokens.spacing12),
            Expanded(
              child: GHButton(
                label: 'View Components',
                style: GHButtonStyle.secondary,
                icon: Icons.widgets,
                onPressed: () => Navigator.pushNamed(context, '/components'),
              ),
            ),
          ],
        ),

        const SizedBox(height: GHTokens.spacing16),

        // Build information
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(GHTokens.spacing12),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(GHTokens.radius8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Build Information',
                style: GHTokens.labelLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: GHTokens.spacing4),
              Text(
                'Design System Foundation v1.0.0',
                style: GHTokens.labelMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Built for cross-platform UAT and stakeholder review',
                style: GHTokens.labelMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
