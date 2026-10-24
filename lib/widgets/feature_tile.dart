import 'package:flutter/material.dart';

import '../app/feature_catalog.dart';

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    required this.feature,
    required this.onOpen,
    this.isSaved = false,
    this.onToggleSaved,
    super.key,
  });

  final FeatureItem feature;
  final VoidCallback onOpen;
  final bool isSaved;
  final VoidCallback? onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = scheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onOpen,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accent.withValues(
                          alpha: theme.brightness == Brightness.dark
                              ? 0.16
                              : 0.11,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(feature.icon, color: accent, size: 21),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  feature.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                feature.groupLabel,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            feature.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (onToggleSaved != null)
            IconButton(
              tooltip: isSaved
                  ? 'Remove ${feature.title} from library'
                  : 'Save ${feature.title} to library',
              onPressed: onToggleSaved,
              icon: Icon(
                isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: isSaved ? accent : scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class FeatureDetailSheet extends StatelessWidget {
  const FeatureDetailSheet({
    required this.feature,
    required this.isSaved,
    required this.onToggleSaved,
    super.key,
  });

  final FeatureItem feature;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(feature.icon, color: scheme.primary, size: 26),
            ),
            const SizedBox(height: 17),
            Text(
              feature.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              feature.details,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IMPLEMENTED IN',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    feature.source,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onToggleSaved,
                icon: Icon(
                  isSaved
                      ? Icons.bookmark_remove_outlined
                      : Icons.bookmark_add_outlined,
                ),
                label: Text(
                  isSaved ? 'Remove from library' : 'Save to library',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
