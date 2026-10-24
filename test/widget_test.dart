import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/app/app_config.dart';
import 'package:template_app/main.dart';
import 'package:template_app/theme/app_theme.dart';

Future<void> _loadRobotoForScreenshot() async {
  final loader = FontLoader('Roboto');
  for (final filename in ['Roboto-Regular.ttf', 'Roboto-Bold.ttf']) {
    final bytes = await File('test/fonts/$filename').readAsBytes();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();

  final iconBytes = await File('test/fonts/MaterialIcons-Regular.otf')
      .readAsBytes();
  final iconLoader = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(iconBytes)));
  await iconLoader.load();
}

void main() {
  test('dark theme preserves readable secondary text contrast', () {
    final scheme = AppTheme.dark(AppColors.ion).colorScheme;
    expect(
      _contrastRatio(scheme.onSurfaceVariant, scheme.surface),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _contrastRatio(scheme.onSurfaceVariant, AppColors.pageDark),
      greaterThanOrEqualTo(4.5),
    );
  });

  test('added accent swatches keep the white selected mark legible', () {
    for (final accent in [
      AppColors.cobalt,
      AppColors.sky,
      AppColors.amber,
      AppColors.rose,
    ]) {
      expect(
        _contrastRatio(Colors.white, accent),
        greaterThanOrEqualTo(4.5),
        reason: 'The selected check mark must be readable on $accent.',
      );
    }
  });

  testWidgets('fresh installs follow system mode and show mode icons', (
    tester,
  ) async {
    final dispatcher = tester.platformDispatcher;
    dispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(dispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(const TemplateApp());

    final appHeading = find.text('A thoughtful place to start');
    Brightness appBrightness() =>
        Theme.of(tester.element(appHeading)).brightness;
    expect(appBrightness(), Brightness.light);

    await tester.tap(find.byTooltip('Open settings'));
    await tester.pumpAndSettle();
    final modeSelector = find.byType(SegmentedButton<ThemeMode>);
    expect(tester.widget<SegmentedButton<ThemeMode>>(modeSelector).selected, {
      ThemeMode.system,
    });
    expect(find.byIcon(Icons.brightness_auto_rounded), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    expect(find.text('System'), findsNothing);
    expect(find.text('Light'), findsNothing);
    expect(find.text('Dark'), findsNothing);
    expect(find.byTooltip('Follow device appearance'), findsOneWidget);
    expect(find.byTooltip('Use light appearance'), findsOneWidget);
    expect(find.byTooltip('Use dark appearance'), findsOneWidget);

    dispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(appBrightness(), Brightness.dark);

    await tester.tap(find.byTooltip('Close settings'));
    await tester.pumpAndSettle();
    expect(appBrightness(), Brightness.dark);
    expect(find.byTooltip('Switch to light theme'), findsNothing);
    expect(find.byTooltip('Switch to dark theme'), findsNothing);
  });

  testWidgets('title bar dashboard mark follows every accent choice', (
    tester,
  ) async {
    await tester.pumpWidget(const TemplateApp());
    expect(
      find.byKey(const ValueKey('app-brand-dashboard-mark')),
      findsOneWidget,
    );
    final brandBackground = find.byKey(
      const ValueKey('app-brand-icon-background'),
    );
    final appHeading = find.text('A thoughtful place to start');
    Color brandColor() =>
        (tester.widget<DecoratedBox>(brandBackground).decoration
                as BoxDecoration)
            .color!;
    Color expectedBrandColor(Color accent) {
      final brightness = Theme.of(tester.element(appHeading)).brightness;
      return (brightness == Brightness.dark
              ? AppTheme.dark(accent)
              : AppTheme.light(accent))
          .colorScheme
          .primary;
    }

    expect(brandColor(), expectedBrandColor(AppColors.ion));

    await tester.tap(find.byTooltip('Open settings'));
    await tester.pumpAndSettle();
    for (final option in accentOptions) {
      final accent = find.byTooltip(option.label);
      await tester.ensureVisible(accent);
      await tester.tap(accent);
      await tester.pumpAndSettle();

      expect(brandColor(), expectedBrandColor(option.color));
    }
  });

  testWidgets('dark mode phone screenshots', (tester) async {
    await tester.runAsync(_loadRobotoForScreenshot);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TemplateApp());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(TemplateApp),
      matchesGoldenFile('../screenshots/template-home.png'),
    );

    await tester.tap(find.byKey(const ValueKey('tab-explore')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(TemplateApp),
      matchesGoldenFile('../screenshots/template-explore.png'),
    );

    await tester.tap(find.byKey(const ValueKey('tab-library')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(TemplateApp),
      matchesGoldenFile('../screenshots/template-library.png'),
    );

    await tester.tap(find.byTooltip('Open settings'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(TemplateApp),
      matchesGoldenFile('../screenshots/template-settings.png'),
    );
  });

  testWidgets('tabs let people save and revisit a building block', (
    tester,
  ) async {
    await tester.pumpWidget(const TemplateApp());

    expect(find.text('A thoughtful place to start'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tab-explore')));
    await tester.pumpAndSettle();
    expect(find.text('Building blocks'), findsOneWidget);

    final ruleTitle = 'Hierarchy before decoration';
    final saveButton = find.byTooltip('Save $ruleTitle to library');
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tab-library')));
    await tester.pumpAndSettle();

    expect(find.text('Your library'), findsOneWidget);
    expect(find.text(ruleTitle), findsOneWidget);
  });

  testWidgets('long building block details scroll inside the sheet', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TemplateApp());
    await tester.tap(find.byKey(const ValueKey('tab-explore')));
    await tester.pumpAndSettle();

    final buildingBlock = find.text('Color with a job');
    await tester.ensureVisible(buildingBlock);
    await tester.tap(buildingBlock);
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('IMPLEMENTED IN'), findsOneWidget);
    expect(find.textContaining('lib/theme/app_theme.dart'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Save to library'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings is a popup, not a primary destination', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.viewPadding = const FakeViewPadding(bottom: 24);
    addTearDown(tester.view.resetViewPadding);
    await tester.pumpWidget(const TemplateApp());

    expect(find.byKey(const ValueKey('tab-home')), findsOneWidget);
    expect(find.byKey(const ValueKey('tab-explore')), findsOneWidget);
    expect(find.byKey(const ValueKey('tab-library')), findsOneWidget);
    expect(find.byKey(const ValueKey('tab-settings')), findsNothing);

    await tester.tap(find.byTooltip('Open settings'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Accent color'), findsOneWidget);
    expect(find.text('App identity'), findsOneWidget);
    expect(find.text('Privacy policy'), findsOneWidget);
    expect(find.byTooltip('Open-source licenses'), findsOneWidget);
    final colorModeCard = find
        .ancestor(of: find.text('Color mode'), matching: find.byType(Container))
        .first;
    final accentColorCard = find
        .ancestor(
          of: find.text('Accent color'),
          matching: find.byType(Container),
        )
        .first;
    expect(
      tester.getSize(colorModeCard).width,
      tester.getSize(accentColorCard).width,
    );
    expect(
      tester
          .widget<Padding>(
            find.byKey(const ValueKey('settings-sheet-safe-area-padding')),
          )
          .padding,
      const EdgeInsets.fromLTRB(12, 0, 12, 36),
    );

    await tester.tap(find.byTooltip('Use light appearance'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.byTooltip('Close settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsNothing);
    expect(find.text('A thoughtful place to start'), findsOneWidget);
  });

  testWidgets('license icon opens the license page with icon attribution', (
    tester,
  ) async {
    await tester.pumpWidget(const TemplateApp());
    await tester.tap(find.byTooltip('Open settings'));
    await tester.pumpAndSettle();

    final licenseButton = find.byTooltip('Open-source licenses');
    await tester.ensureVisible(licenseButton);
    await tester.tap(licenseButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Material Icons by Google'), findsOneWidget);
  });

  testWidgets('rulebook exposes visual, interaction, and reuse rules', (
    tester,
  ) async {
    await tester.pumpWidget(const TemplateApp());
    await tester.tap(find.byKey(const ValueKey('tab-explore')));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Visual'));
    await tester.pumpAndSettle();
    expect(find.text('Hierarchy before decoration'), findsOneWidget);
    expect(find.text('Color with a job'), findsOneWidget);
    expect(find.text('Readable text contrast'), findsOneWidget);
    expect(find.text('Use 48 dp touch targets'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'Interaction'));
    await tester.pumpAndSettle();
    expect(find.text('Use 48 dp touch targets'), findsOneWidget);
    expect(find.text('Keep settings secondary'), findsOneWidget);
    expect(find.text('Check commercial-use licenses'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'Reuse'));
    await tester.pumpAndSettle();
    expect(find.text('Check commercial-use licenses'), findsOneWidget);
    expect(find.text('Document dark-mode screens'), findsOneWidget);
    expect(find.text('Replace the starter identity'), findsOneWidget);
    expect(find.text('Increment every app update'), findsOneWidget);
    expect(find.text('Readable text contrast'), findsNothing);
  });
}

double _contrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final brighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;
  return (brighter + 0.05) / (darker + 0.05);
}
