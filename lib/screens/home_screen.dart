import 'package:flutter/material.dart';

import '../app/app_config.dart';
import '../app/feature_catalog.dart';
import '../widgets/feature_tile.dart';
import '../widgets/page_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onExplore,
    required this.onOpenFeature,
    super.key,
  });

  final VoidCallback onExplore;
  final ValueChanged<FeatureItem> onOpenFeature;

  @override
  Widget build(BuildContext context) {
    return PageBody(
      eyebrow: 'YOUR NEXT APP',
      title: 'A thoughtful place to start',
      subtitle: AppConfig.tagline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WelcomeCard(onExplore: onExplore),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _QuickStat(
                  value: '03',
                  label: 'clear destinations',
                  icon: Icons.space_dashboard_outlined,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QuickStat(
                  value: '48dp',
                  label: 'minimum touch target',
                  icon: Icons.touch_app_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          SectionHeading(
            title: 'Start with the basics',
            actionLabel: 'See all',
            onAction: onExplore,
          ),
          const SizedBox(height: 8),
          for (final feature in featureCatalog.take(2)) ...[
            FeatureTile(feature: feature, onOpen: () => onOpenFeature(feature)),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          const _DesignNote(),
        ],
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final base = scheme.surfaceContainerLow;
    final glow = Color.lerp(base, scheme.primary, 0.2)!;
    final orbit = Color.lerp(base, scheme.tertiary, 0.14)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [glow, base, orbit],
            stops: const [0, 0.58, 1],
          ),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.32)),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -44,
              top: -55,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primary.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: -13,
              top: -24,
              child: Container(
                width: 136,
                height: 136,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: scheme.tertiary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surface.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'FUTURE-READY UI KIT',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Make room for your next good idea.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.65,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'A complete app shell with a crisp, futuristic visual system and useful pieces to build on.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: onExplore,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                    label: const Text('Explore the template'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesignNote extends StatelessWidget {
  const _DesignNote();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: scheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clarity is the finishing touch',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reserve bright accents for actions, keep text legible, and let motion explain change.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
