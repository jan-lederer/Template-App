import 'package:flutter/material.dart';

enum FeatureGroup { screen, component, pattern }

class FeatureItem {
  const FeatureItem({
    required this.id,
    required this.title,
    required this.description,
    required this.details,
    required this.group,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String details;
  final FeatureGroup group;
  final IconData icon;

  String get groupLabel => switch (group) {
    FeatureGroup.screen => 'Screen',
    FeatureGroup.component => 'Component',
    FeatureGroup.pattern => 'Pattern',
  };
}

const featureCatalog = <FeatureItem>[
  FeatureItem(
    id: 'home-dashboard',
    title: 'Home dashboard',
    description: 'A clear welcome, a useful next step, and room to breathe.',
    details: 'Keep the first screen focused. Lead with one useful action, then add the supporting information people need to feel oriented.',
    group: FeatureGroup.screen,
    icon: Icons.dashboard_customize_outlined,
  ),
  FeatureItem(
    id: 'explore-screen',
    title: 'Browse and discover',
    description: 'A searchable home for the main things your app offers.',
    details: 'Use a short filter row and readable cards to help people scan a growing collection without adding visual noise.',
    group: FeatureGroup.screen,
    icon: Icons.grid_view_rounded,
  ),
  FeatureItem(
    id: 'progress-overview',
    title: 'Progress overview',
    description: 'Small, useful signals that make progress easy to read.',
    details: 'Show a few meaningful totals and trends. Keep metrics close to the action they describe, and make empty progress feel welcoming.',
    group: FeatureGroup.screen,
    icon: Icons.insights_rounded,
  ),
  FeatureItem(
    id: 'reusable-cards',
    title: 'Reusable cards',
    description: 'One surface style for actions, summaries, and saved items.',
    details: 'The same rounded surface, quiet outline, and clear title hierarchy can support many kinds of content while keeping the app coherent.',
    group: FeatureGroup.component,
    icon: Icons.view_agenda_outlined,
  ),
  FeatureItem(
    id: 'theme-controls',
    title: 'Theme controls',
    description: 'Light, dark, and accent choices gathered in one place.',
    details: 'Color roles come from one seed and adapt across light and dark modes. Settings opens as a compact sheet, so appearance choices stay close without taking a navigation destination.',
    group: FeatureGroup.component,
    icon: Icons.palette_outlined,
  ),
  FeatureItem(
    id: 'bottom-navigation',
    title: 'Bottom navigation',
    description: 'Three stable destinations with familiar labels and icons.',
    details: 'Keep the primary route short and easy to scan. The tab list is centralized in app_config.dart, the shell preserves each screen state, and secondary controls such as Settings stay in the top bar.',
    group: FeatureGroup.pattern,
    icon: Icons.tablet_android_outlined,
  ),
  FeatureItem(
    id: 'semantic-color',
    title: 'Color with a job',
    description: 'A restrained palette gives every accent a clear meaning.',
    details: 'Use semantic color roles for surfaces, text, and actions. Reserve the bright accent for interactive or selected states, keep its meaning consistent, and check the palette in both light and dark themes.',
    group: FeatureGroup.pattern,
    icon: Icons.palette_rounded,
  ),
  FeatureItem(
    id: 'accessible-controls',
    title: 'Comfortable controls',
    description: 'Large targets, clear labels, and contrast that holds up.',
    details: 'Give touch actions at least 48 dp of interactive space. Keep small text at a 4.5:1 contrast ratio where possible, label icon-only actions, and pair color with shape or text so meaning is never color-only.',
    group: FeatureGroup.pattern,
    icon: Icons.touch_app_outlined,
  ),
  FeatureItem(
    id: 'ambient-depth',
    title: 'Depth without noise',
    description: 'Quiet surfaces and a soft accent glow add a futuristic edge.',
    details: 'Start with a neutral base and use tonal surfaces to separate content. A subtle gradient or glow can guide the eye toward one useful action; avoid adding effects to every card or control.',
    group: FeatureGroup.pattern,
    icon: Icons.blur_on_rounded,
  ),
  FeatureItem(
    id: 'purposeful-motion',
    title: 'Motion with purpose',
    description: 'Short feedback helps people understand a change.',
    details: 'Use brief transitions to show cause and effect, preserve a familiar direction for opening and closing surfaces, and respect reduced-motion preferences. Never make animation the only way to understand a state.',
    group: FeatureGroup.pattern,
    icon: Icons.play_circle_outline_rounded,
  ),
  FeatureItem(
    id: 'progressive-settings',
    title: 'Settings stay in reach',
    description: 'Secondary choices open in a focused popup.',
    details: 'Keep the main navigation for primary places people visit often. Put occasional appearance and demo controls in an easy-to-dismiss sheet, keeping the current screen in context.',
    group: FeatureGroup.pattern,
    icon: Icons.tune_rounded,
  ),
  FeatureItem(
    id: 'empty-states',
    title: 'Helpful empty states',
    description: 'A gentle explanation and a next step when a list is empty.',
    details: 'An empty state should tell people what belongs here and offer a direct action. The Library tab shows this before anything is saved.',
    group: FeatureGroup.pattern,
    icon: Icons.inbox_outlined,
  ),
  FeatureItem(
    id: 'spacing-system',
    title: 'Spacing and surfaces',
    description: 'Consistent padding, borders, and rounded shapes.',
    details: 'Use a small spacing scale and a handful of corner radii. Let generous spacing establish hierarchy before adding borders, shadows, or decoration.',
    group: FeatureGroup.pattern,
    icon: Icons.space_dashboard_outlined,
  ),
];
