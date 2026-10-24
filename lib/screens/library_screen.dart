import 'package:flutter/material.dart';

import '../app/feature_catalog.dart';
import '../widgets/feature_tile.dart';
import '../widgets/page_body.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({
    required this.savedFeatures,
    required this.onExplore,
    required this.onOpenFeature,
    required this.onRemove,
    super.key,
  });

  final List<FeatureItem> savedFeatures;
  final VoidCallback onExplore;
  final ValueChanged<FeatureItem> onOpenFeature;
  final ValueChanged<FeatureItem> onRemove;

  @override
  Widget build(BuildContext context) {
    return PageBody(
      title: 'Your library',
      subtitle: 'Keep the ideas and patterns you want close at hand.',
      child: savedFeatures.isEmpty
          ? _EmptyLibrary(onExplore: onExplore)
          : Column(
              children: [
                for (final feature in savedFeatures) ...[
                  FeatureTile(
                    feature: feature,
                    onOpen: () => onOpenFeature(feature),
                    isSaved: true,
                    onToggleSaved: () => onRemove(feature),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border_rounded,
              color: scheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Keep good ideas close',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Save a building block from Explore and it will show up here.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onExplore,
            icon: const Icon(Icons.widgets_outlined),
            label: const Text('Explore building blocks'),
          ),
        ],
      ),
    );
  }
}
