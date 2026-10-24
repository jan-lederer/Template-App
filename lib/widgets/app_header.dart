import 'package:flutter/material.dart';

import '../app/app_config.dart';
import 'app_brand_icon.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.onOpenSettings,
    super.key,
  });

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      height: 68,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const AppBrandIcon(),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: AppConfig.brandName,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.1,
                  ),
                ),
                TextSpan(
                  text: '.',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            style: const TextStyle(fontSize: 23, height: 1),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Open settings',
            onPressed: onOpenSettings,
            icon: const Icon(Icons.tune_rounded, size: 21),
          ),
        ],
      ),
    );
  }
}
