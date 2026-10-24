import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum AppTab { home, explore, library }

class AppTabConfig {
  const AppTabConfig({
    required this.id,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final AppTab id;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

abstract final class AppConfig {
  static const productName = 'Template';
  static const brandName = 'template';
  static const tagline = 'A calm, capable start for your next app.';
  static const packageId = 'com.example.template_app';
  static const version = '1.1.0';
  static const privacyPolicyUrl =
      'https://github.com/your-org/your-app/blob/main/PRIVACY.md';
}

class AccentOption {
  const AccentOption(this.label, this.color);

  final String label;
  final Color color;
}

const appTabs = <AppTabConfig>[
  AppTabConfig(
    id: AppTab.home,
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  AppTabConfig(
    id: AppTab.explore,
    label: 'Explore',
    icon: Icons.widgets_outlined,
    selectedIcon: Icons.widgets_rounded,
  ),
  AppTabConfig(
    id: AppTab.library,
    label: 'Library',
    icon: Icons.bookmark_border_rounded,
    selectedIcon: Icons.bookmark_rounded,
  ),
];

const accentOptions = <AccentOption>[
  AccentOption('Ion', AppColors.ion),
  AccentOption('Violet', AppColors.violet),
  AccentOption('Coral', AppColors.coral),
  AccentOption('Mint', AppColors.mint),
  AccentOption('Cobalt', AppColors.cobalt),
  AccentOption('Sky', AppColors.sky),
  AccentOption('Amber', AppColors.amber),
  AccentOption('Rose', AppColors.rose),
];
