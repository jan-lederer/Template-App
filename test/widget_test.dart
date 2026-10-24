import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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

  testWidgets('title bar mark follows the selected accent color', (
    tester,
  ) async {
    await tester.pumpWidget(const TemplateApp());
    final brandBackground = find.byKey(
      const ValueKey('app-brand-icon-background'),
    );
    Color brandColor() =>
        (tester.widget<DecoratedBox>(brandBackground).decoration
                as BoxDecoration)
            .color!;

    expect(brandColor(), AppTheme.dark(AppColors.ion).colorScheme.primary);

    await tester.tap(find.byTooltip('Open settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Coral'));
    await tester.pumpAndSettle();

    expect(brandColor(), AppTheme.dark(AppColors.coral).colorScheme.primary);
  });

  testWidgets('home screen phone-size preview', (tester) async {
    await tester.runAsync(_loadRobotoForScreenshot);
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
  });

  testWidgets('tabs let people save and revisit a building block', (
    tester,
  ) async {
    await tester.pumpWidget(const TemplateApp());

    expect(find.text('A thoughtful place to start'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tab-explore')));
    await tester.pumpAndSettle();
    expect(find.text('Building blocks'), findsOneWidget);

    final saveButton = find.byTooltip('Save Reusable cards to library');
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tab-library')));
    await tester.pumpAndSettle();

    expect(find.text('Your library'), findsOneWidget);
    expect(find.text('Reusable cards'), findsOneWidget);
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
    expect(
      tester
          .widget<Padding>(
            find.byKey(const ValueKey('settings-sheet-safe-area-padding')),
          )
          .padding,
      const EdgeInsets.fromLTRB(12, 0, 12, 36),
    );

    await tester.tap(find.text('Light'));
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

  testWidgets('patterns include clean futuristic design defaults', (
    tester,
  ) async {
    await tester.pumpWidget(const TemplateApp());
    await tester.tap(find.byKey(const ValueKey('tab-explore')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'Patterns'));
    await tester.pumpAndSettle();

    expect(find.text('Color with a job'), findsOneWidget);
    expect(find.text('Comfortable controls'), findsOneWidget);
    expect(find.text('Depth without noise'), findsOneWidget);
    expect(find.text('Motion with purpose'), findsOneWidget);
    expect(find.text('Settings stay in reach'), findsOneWidget);
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
