import 'package:flutter/material.dart';
import '../tokens/gh_tokens.dart';
import '../components/gh_card.dart';
import '../widgets/gh_navigation_grid.dart';
import 'comparison_screen.dart';
import 'mock_screen.dart';

/// A comparison screen showing spacing improvements.
///
/// This screen demonstrates the transition from inconsistent spacing
/// to the standardized 4dp grid system.
class SpacingComparisonScreen extends StatelessWidget {
  const SpacingComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonScreen(
      title: 'Spacing Standardization',
      beforeDescription:
          'Inconsistent spacing with varying measurements and double padding issues',
      afterDescription:
          'Consistent 4dp grid system throughout with proper spacing hierarchy',
      highlights: const [
        ImprovementHighlight(
          description: 'Standardized all spacing to 4dp grid system',
        ),
        ImprovementHighlight(
          description: 'Fixed activity card double padding issues',
        ),
        ImprovementHighlight(
          description: 'Consistent 16dp page margins across all screens',
        ),
        ImprovementHighlight(
          description: 'Professional visual hierarchy with proper spacing',
        ),
        ImprovementHighlight(
          description: 'Eliminated random spacing values (7dp, 15dp, 25dp)',
        ),
      ],
      beforeWidget: _buildInconsistentSpacing(context),
      afterWidget: _buildConsistentSpacing(context),
    );
  }

  Widget _buildInconsistentSpacing(BuildContext context) {
    return MockScreen(
      title: 'Home',
      showBackButton: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User card with wrong spacing
            Container(
              padding: const EdgeInsets.all(
                23,
              ), // Wrong: 23dp instead of standard
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      'U',
                      style: GHTokens.titleMedium.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ), // Wrong: 15dp instead of 12dp or 16dp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User Name', style: GHTokens.titleLarge),
                        const SizedBox(
                          height: 7,
                        ), // Wrong: 7dp instead of 4dp or 8dp
                        Text(
                          '@username',
                          style: GHTokens.bodyMedium.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 31), // Wrong: 31dp instead of 20dp or 32dp
            // Quick actions with wrong spacing
            Text('Quick Actions', style: GHTokens.titleMedium),
            const SizedBox(height: 14), // Wrong: 14dp instead of 12dp or 16dp
            // Grid with inconsistent internal spacing
            Container(
              padding: const EdgeInsets.all(
                19,
              ), // Wrong: 19dp instead of 16dp or 20dp
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInconsistentActionCard(
                          context,
                          Icons.folder,
                          'Repos',
                          '12',
                        ),
                      ),
                      const SizedBox(
                        width: 13,
                      ), // Wrong: 13dp instead of 8dp or 12dp
                      Expanded(
                        child: _buildInconsistentActionCard(
                          context,
                          Icons.star,
                          'Starred',
                          '45',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 9,
                  ), // Wrong: 9dp instead of 8dp or 12dp
                  Row(
                    children: [
                      Expanded(
                        child: _buildInconsistentActionCard(
                          context,
                          Icons.people,
                          'Orgs',
                          '3',
                        ),
                      ),
                      const SizedBox(width: 13), // Wrong: 13dp (inconsistent)
                      Expanded(
                        child: _buildInconsistentActionCard(
                          context,
                          Icons.settings,
                          'Settings',
                          '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26), // Wrong: 26dp instead of 24dp or 32dp
            // Activity section with double padding issue
            Text('Recent Activity', style: GHTokens.titleMedium),
            const SizedBox(height: 18), // Wrong: 18dp instead of 16dp or 20dp
            // Card with double padding (common issue)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.all(16), // Double padding issue!
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Activity Item', style: GHTokens.titleMedium),
                    const SizedBox(
                      height: 6,
                    ), // Wrong: 6dp instead of 4dp or 8dp
                    Text(
                      'This demonstrates the double padding issue that was common in the old system.',
                      style: GHTokens.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22), // Wrong: 22dp instead of 20dp or 24dp
            // Spacing issues label
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 5,
              ), // Wrong values
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '❌ Inconsistent spacing values: 23dp, 15dp, 7dp, 31dp, 14dp, 19dp, 13dp, 9dp, 26dp, 18dp, 6dp, 22dp',
                style: GHTokens.labelMedium.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsistentSpacing(BuildContext context) {
    return MockScreen(
      title: 'Home',
      showBackButton: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User card with correct spacing
            Container(
              padding: const EdgeInsets.all(
                GHTokens.spacing16,
              ), // Correct: 16dp
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      'U',
                      style: GHTokens.titleMedium.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: GHTokens.spacing12), // Correct: 12dp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User Name', style: GHTokens.titleLarge),
                        const SizedBox(
                          height: GHTokens.spacing8,
                        ), // Correct: 8dp
                        Text(
                          '@username',
                          style: GHTokens.bodyMedium.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: GHTokens.spacing20), // Correct: 20dp
            // Quick actions with correct spacing
            Text('Quick Actions', style: GHTokens.titleMedium),
            const SizedBox(height: GHTokens.spacing12), // Correct: 12dp
            // Grid with consistent internal spacing
            GHNavigationGrid.twoByTwo(
              items: [
                GHNavigationItem.withCount(
                  icon: Icons.folder,
                  title: 'Repositories',
                  description: 'Your repos',
                  count: 12,
                ),
                GHNavigationItem.withCount(
                  icon: Icons.star,
                  title: 'Starred',
                  description: 'Starred repos',
                  count: 45,
                ),
                GHNavigationItem.withCount(
                  icon: Icons.people,
                  title: 'Organizations',
                  description: 'Your orgs',
                  count: 3,
                ),
                GHNavigationItem.simple(
                  icon: Icons.settings,
                  title: 'Settings',
                  description: 'Account settings',
                ),
              ],
            ),

            const SizedBox(height: GHTokens.spacing20), // Correct: 20dp
            // Activity section with proper spacing
            Text('Recent Activity', style: GHTokens.titleMedium),
            const SizedBox(height: GHTokens.spacing12), // Correct: 12dp
            // Card with single, correct padding
            GHCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity Item', style: GHTokens.titleMedium),
                  const SizedBox(height: GHTokens.spacing8), // Correct: 8dp
                  Text(
                    'This demonstrates proper spacing using the standardized 4dp grid system.',
                    style: GHTokens.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: GHTokens.spacing20), // Correct: 20dp
            // Grid system explanation
            Container(
              padding: const EdgeInsets.all(GHTokens.spacing16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.grid_4x4,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                      const SizedBox(width: GHTokens.spacing8),
                      Text(
                        '4dp Grid System',
                        style: GHTokens.titleMedium.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: GHTokens.spacing12),

                  _buildSpacingReference(
                    context,
                    '4dp',
                    'Micro spacing (icon gaps)',
                  ),
                  _buildSpacingReference(
                    context,
                    '8dp',
                    'Small spacing (element gaps)',
                  ),
                  _buildSpacingReference(
                    context,
                    '12dp',
                    'Medium spacing (section padding)',
                  ),
                  _buildSpacingReference(
                    context,
                    '16dp',
                    'Standard spacing (card padding)',
                  ),
                  _buildSpacingReference(
                    context,
                    '20dp',
                    'Large spacing (section margins)',
                  ),
                  _buildSpacingReference(
                    context,
                    '24dp',
                    'XL spacing (screen padding)',
                  ),
                  _buildSpacingReference(
                    context,
                    '32dp',
                    'XXL spacing (major sections)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInconsistentActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String count,
  ) {
    return Container(
      padding: const EdgeInsets.all(17), // Wrong: 17dp instead of 16dp
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 26), // Wrong: 26dp instead of 24dp
          const SizedBox(height: 11), // Wrong: 11dp instead of 8dp or 12dp
          Text(title, style: GHTokens.labelLarge),
          if (count.isNotEmpty) ...[
            const SizedBox(height: 5), // Wrong: 5dp instead of 4dp or 8dp
            Text(count, style: GHTokens.titleMedium),
          ],
        ],
      ),
    );
  }

  Widget _buildSpacingReference(
    BuildContext context,
    String spacing,
    String usage,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GHTokens.spacing8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                spacing,
                style: GHTokens.labelSmall.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: GHTokens.spacing12),
          Expanded(
            child: Text(
              usage,
              style: GHTokens.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
