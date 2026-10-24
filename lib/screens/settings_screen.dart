import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/app_config.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.accentColor,
    required this.onAccentChanged,
    required this.savedCount,
    required this.onClearSaved,
    required this.onClose,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final Color accentColor;
  final ValueChanged<Color> onAccentChanged;
  final int savedCount;
  final VoidCallback onClearSaved;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: scheme.outlineVariant,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Tune the look and feel of your app.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Close settings',
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: scheme.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingsCard(
                      title: 'Color mode',
                      subtitle: 'Follow the device or choose a theme.',
                      child: SegmentedButton<ThemeMode>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto_rounded),
                            label: Text('System'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode_rounded),
                            label: Text('Light'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode_rounded),
                            label: Text('Dark'),
                          ),
                        ],
                        selected: {themeMode},
                        onSelectionChanged: (selection) =>
                            onThemeModeChanged(selection.first),
                      ),
                    ),
                    const SizedBox(height: 13),
                    _SettingsCard(
                      title: 'Accent color',
                      subtitle: 'The main highlight used for actions and selected items.',
                      child: Wrap(
                        spacing: 14,
                        runSpacing: 12,
                        children: [
                          for (final option in accentOptions)
                            Tooltip(
                              message: option.label,
                              child: Semantics(
                                button: true,
                                selected: accentColor == option.color,
                                label: '${option.label} accent',
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () => onAccentChanged(option.color),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: accentColor == option.color
                                            ? scheme.onSurface
                                            : scheme.outlineVariant,
                                        width: accentColor == option.color
                                            ? 2
                                            : 1,
                                      ),
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: option.color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: accentColor == option.color
                                          ? const Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                    _SettingsCard(
                      title: 'App identity',
                      subtitle: 'The main values to rename when you reuse this starter.',
                      child: Column(
                        children: [
                          _InfoRow(
                            label: 'Display name',
                            value: AppConfig.productName,
                          ),
                          const SizedBox(height: 9),
                          _InfoRow(
                            label: 'Package ID',
                            value: AppConfig.packageId,
                          ),
                          const SizedBox(height: 9),
                          _InfoRow(label: 'Version', value: AppConfig.version),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _openPrivacyPolicy(context),
                                  icon: const Icon(
                                    Icons.privacy_tip_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Privacy policy'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip: 'Open-source licenses',
                                onPressed: () => showLicensePage(
                                  context: context,
                                  applicationName: AppConfig.productName,
                                  applicationVersion: AppConfig.version,
                                  applicationLegalese:
                                      'Material Icons by Google. CC BY 4.0: '
                                      'https://creativecommons.org/licenses/by/4.0/',
                                ),
                                icon: const Icon(
                                  Icons.policy_outlined,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                    _SettingsCard(
                      title: 'Demo data',
                      subtitle:
                          '$savedCount saved building block${savedCount == 1 ? '' : 's'}',
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: savedCount == 0 ? null : onClearSaved,
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text('Clear saved items'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: scheme.secondary,
                          size: 19,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Your choices stay in memory for this demo session.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    try {
      final opened = await launchUrl(
        Uri.parse(AppConfig.privacyPolicyUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) _showPrivacyPolicyError(context);
    } catch (_) {
      if (context.mounted) _showPrivacyPolicyError(context);
    }
  }

  void _showPrivacyPolicyError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the privacy policy.')),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
