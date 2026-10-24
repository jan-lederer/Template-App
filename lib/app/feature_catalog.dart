import 'package:flutter/material.dart';

enum FeatureGroup { visual, interaction, reuse }

class FeatureItem {
  const FeatureItem({
    required this.id,
    required this.title,
    required this.description,
    required this.details,
    required this.source,
    required this.group,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String details;
  final String source;
  final FeatureGroup group;
  final IconData icon;

  String get groupLabel => switch (group) {
    FeatureGroup.visual => 'Visual',
    FeatureGroup.interaction => 'Interaction',
    FeatureGroup.reuse => 'Reuse',
  };
}

/// The in-app rulebook. Each card states a documented template rule and points
/// to the files where it is applied.
const featureCatalog = <FeatureItem>[
  FeatureItem(
    id: 'hierarchy',
    title: 'Hierarchy before decoration',
    description: 'Use spacing and readable type before adding effects.',
    details: 'Rule: Establish hierarchy with consistent spacing, readable type, and a small number of surface levels. Add borders or decoration only when they make the content easier to understand.',
    source: 'README.md · Visual principles; lib/widgets/page_body.dart',
    group: FeatureGroup.visual,
    icon: Icons.format_size_rounded,
  ),
  FeatureItem(
    id: 'semantic-color',
    title: 'Color with a job',
    description: 'Give each color a stable meaning across both themes.',
    details: 'Rule: Use semantic roles for page, surface, text, outline, and actions. Reserve bright accents for interactive or selected states, and check the palette in light and dark mode.',
    source: 'README.md · Visual principles; lib/theme/app_theme.dart',
    group: FeatureGroup.visual,
    icon: Icons.palette_outlined,
  ),
  FeatureItem(
    id: 'text-contrast',
    title: 'Readable text contrast',
    description: 'Keep regular text at 4.5:1 contrast or higher.',
    details: 'Rule: Keep text and controls distinct from their backgrounds. Aim for at least 4.5:1 contrast for regular text, and verify the actual colors in both light and dark themes.',
    source: 'README.md · Visual principles; lib/theme/app_theme.dart; test/widget_test.dart',
    group: FeatureGroup.visual,
    icon: Icons.contrast_rounded,
  ),
  FeatureItem(
    id: 'multiple-cues',
    title: 'Color is not the only cue',
    description: 'Pair color with a label, shape, or icon.',
    details: 'Rule: Never make color the only way to recognize an action or state. Pair an accent with text, an icon, a shape, or a selected indicator.',
    source: 'README.md · Visual principles; lib/app/app_config.dart; lib/widgets/feature_tile.dart',
    group: FeatureGroup.visual,
    icon: Icons.label_outline_rounded,
  ),
  FeatureItem(
    id: 'quiet-depth',
    title: 'Depth without noise',
    description: 'Use tonal layers and effects sparingly.',
    details: 'Rule: Separate content with a few tonal surfaces. Keep gradients and glow subtle, and use them to guide attention toward useful content instead of decorating every card.',
    source: 'README.md · Design system; lib/screens/home_screen.dart; lib/theme/app_theme.dart',
    group: FeatureGroup.visual,
    icon: Icons.blur_on_rounded,
  ),
  FeatureItem(
    id: 'spacing-scale',
    title: 'Keep spacing and shapes consistent',
    description: 'Reuse a small spacing scale and a few corner radii.',
    details: 'Rule: Let generous, consistent spacing establish hierarchy before adding borders or shadows. Reuse a small set of paddings and corner radii so cards feel related.',
    source: 'README.md · Visual principles; lib/widgets/feature_tile.dart; lib/theme/app_theme.dart',
    group: FeatureGroup.visual,
    icon: Icons.space_dashboard_outlined,
  ),
  FeatureItem(
    id: 'responsive-layout',
    title: 'Fit phones and wide screens',
    description: 'Scroll on phones and cap content width on larger screens.',
    details: 'Rule: Keep content scrollable on phones. On wide screens, center it and cap the content width at 760 dp so lines and cards remain easy to scan.',
    source: 'README.md · Design system; lib/widgets/page_body.dart',
    group: FeatureGroup.visual,
    icon: Icons.devices_rounded,
  ),
  FeatureItem(
    id: 'shared-dashboard-mark',
    title: 'Keep one dashboard mark',
    description: 'Share one tile layout between the title and launcher icons.',
    details: 'Rule: Keep the same 2-by-2 dashboard geometry in the title bar and launcher icon. The title mark follows the selected accent; the launcher mark uses coral, ion, violet, and mint.',
    source: 'README.md · Reuse checklist; lib/widgets/app_brand_icon.dart; android/app/src/main/res/drawable/ic_launcher.xml',
    group: FeatureGroup.visual,
    icon: Icons.dashboard_customize_outlined,
  ),
  FeatureItem(
    id: 'touch-targets',
    title: 'Use 48 dp touch targets',
    description: 'Keep interactive controls comfortable to tap.',
    details: 'Rule: Make interactive targets at least 48 dp. Keep labels clear, and give icon-only actions a useful tooltip or accessible name.',
    source: 'README.md · Visual principles; lib/theme/app_theme.dart; lib/screens/settings_screen.dart',
    group: FeatureGroup.interaction,
    icon: Icons.touch_app_outlined,
  ),
  FeatureItem(
    id: 'purposeful-motion',
    title: 'Motion explains a change',
    description: 'Use short, predictable motion as feedback.',
    details: 'Rule: Use motion briefly to explain a change, and keep navigation and dismiss gestures predictable. Motion should support the visible state instead of obscuring it.',
    source: 'README.md · Visual principles; lib/app/app_shell.dart; lib/screens/settings_screen.dart',
    group: FeatureGroup.interaction,
    icon: Icons.play_circle_outline_rounded,
  ),
  FeatureItem(
    id: 'primary-navigation',
    title: 'Keep navigation stable',
    description:
        'Reserve primary navigation for the few places people revisit.',
    details: 'Rule: Keep primary destinations short and easy to scan. Centralize their labels and icons, and preserve screen state while switching between them.',
    source: 'README.md · Design system; lib/app/app_config.dart; lib/app/app_shell.dart',
    group: FeatureGroup.interaction,
    icon: Icons.navigation_rounded,
  ),
  FeatureItem(
    id: 'secondary-settings',
    title: 'Keep settings secondary',
    description: 'Open occasional choices in a focused popup.',
    details: 'Rule: Keep primary destinations in the bottom navigation. Put secondary appearance and demo controls in an easy-to-dismiss settings sheet so the current screen stays in context.',
    source: 'README.md · Design system; lib/app/app_shell.dart; lib/screens/settings_screen.dart',
    group: FeatureGroup.interaction,
    icon: Icons.tune_rounded,
  ),
  FeatureItem(
    id: 'empty-state-next-step',
    title: 'Give empty states a next step',
    description: 'Explain what belongs in an empty list and what to do next.',
    details: 'Rule: An empty state should say what belongs here and offer a direct next action. The Library explains how to save a block and links back to Explore.',
    source: 'README.md · Visual principles; lib/screens/library_screen.dart',
    group: FeatureGroup.interaction,
    icon: Icons.inbox_outlined,
  ),
  FeatureItem(
    id: 'dark-mode-screenshots',
    title: 'Document dark-mode screens',
    description: 'Keep phone-size dark screenshots for each app destination.',
    details: 'Rule: Keep dark-mode screenshots of every primary destination and the settings popup in the README. Capture them at phone size and refresh the gallery whenever those screens change.',
    source: 'README.md · Dark mode screenshots; test/widget_test.dart',
    group: FeatureGroup.reuse,
    icon: Icons.dark_mode_outlined,
  ),
  FeatureItem(
    id: 'commercial-assets',
    title: 'Check commercial-use licenses',
    description:
        'Use only assets and dependencies with clear commercial terms.',
    details: 'Rule: Check the exact licenses for dependencies, icons, fonts, images, plugins, and copied assets, including transitive packages. Reject non-commercial, unclear, or unlicensed material; retain required notices and attribution.',
    source: 'README.md · Commercial use and licenses; THIRD_PARTY_NOTICES.md',
    group: FeatureGroup.reuse,
    icon: Icons.policy_outlined,
  ),
  FeatureItem(
    id: 'starter-identity',
    title: 'Replace the starter identity',
    description: 'Set a product name, package ID, policy URL, and signing key.',
    details: 'Rule: Before release, replace the example product identity and com.example.template_app with values you control. Publish the privacy policy and configure a unique upload key; do not reuse this template key across unrelated apps.',
    source: 'README.md · Reuse checklist and Android signing; lib/app/app_config.dart; android/app/build.gradle.kts',
    group: FeatureGroup.reuse,
    icon: Icons.badge_outlined,
  ),
  FeatureItem(
    id: 'demo-state',
    title: 'Treat saved data as demo state',
    description: 'Connect storage only when the derived app needs persistence.',
    details: 'Rule: Saved blocks and appearance choices are in-memory examples and reset when the process restarts. Add storage only when the new app needs persistence; this template has no backend by default.',
    source: 'README.md · Introduction and App behavior; lib/app/app_shell.dart',
    group: FeatureGroup.reuse,
    icon: Icons.storage_rounded,
  ),
  FeatureItem(
    id: 'android-versioning',
    title: 'Increment every app update',
    description: 'Increase the build number after the + for Android updates.',
    details: 'Rule: Increment the version in pubspec.yaml for every installable update. The number after + becomes Android versionCode and must keep increasing.',
    source: 'README.md · Reuse checklist; pubspec.yaml; android/app/build.gradle.kts',
    group: FeatureGroup.reuse,
    icon: Icons.system_update_alt_rounded,
  ),
];
