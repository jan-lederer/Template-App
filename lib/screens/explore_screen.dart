import 'package:flutter/material.dart';

import '../app/feature_catalog.dart';
import '../widgets/feature_tile.dart';
import '../widgets/page_body.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    required this.savedFeatureIds,
    required this.onOpenFeature,
    required this.onToggleSaved,
    super.key,
  });

  final Set<String> savedFeatureIds;
  final ValueChanged<FeatureItem> onOpenFeature;
  final ValueChanged<FeatureItem> onToggleSaved;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const _filters = ['All', 'Screens', 'Components', 'Patterns'];
  String _selectedFilter = _filters.first;

  @override
  Widget build(BuildContext context) {
    final filtered = featureCatalog.where((feature) {
      if (_selectedFilter == 'All') return true;
      return feature.groupLabel ==
              _selectedFilter.substring(0, _selectedFilter.length - 1) ||
          (_selectedFilter == 'Screens' &&
              feature.group == FeatureGroup.screen);
    }).toList();

    return PageBody(
      title: 'Building blocks',
      subtitle: 'Polished patterns for the screens and moments in your app.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final filter in _filters)
                FilterChip(
                  label: Text(filter),
                  selected: _selectedFilter == filter,
                  onSelected: (_) => setState(() => _selectedFilter = filter),
                  showCheckmark: false,
                ),
            ],
          ),
          const SizedBox(height: 16),
          for (final feature in filtered) ...[
            FeatureTile(
              key: ValueKey('feature-${feature.id}'),
              feature: feature,
              onOpen: () => widget.onOpenFeature(feature),
              isSaved: widget.savedFeatureIds.contains(feature.id),
              onToggleSaved: () => widget.onToggleSaved(feature),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
