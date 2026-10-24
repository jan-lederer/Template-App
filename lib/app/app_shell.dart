import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/explore_screen.dart';
import '../screens/home_screen.dart';
import '../screens/library_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/settings_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/feature_tile.dart';
import 'app_config.dart';
import 'feature_catalog.dart';

class AppShell extends StatefulWidget {
  const AppShell({this.showStartupScreen = true, super.key});

  final bool showStartupScreen;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  AppTab _selectedTab = AppTab.home;
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = AppColors.ion;
  final Set<String> _savedFeatureIds = <String>{};
  late bool _showStartupScreen;

  @override
  void initState() {
    super.initState();
    _showStartupScreen = widget.showStartupScreen;
  }

  List<FeatureItem> get _savedFeatures => featureCatalog
      .where((feature) => _savedFeatureIds.contains(feature.id))
      .toList(growable: false);

  void _toggleSaved(FeatureItem feature) {
    setState(() {
      if (!_savedFeatureIds.add(feature.id)) {
        _savedFeatureIds.remove(feature.id);
      }
    });
  }

  void _showFeature(FeatureItem feature) {
    final context = _navigatorKey.currentContext;
    if (context == null) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) => FeatureDetailSheet(
        feature: feature,
        isSaved: _savedFeatureIds.contains(feature.id),
        onToggleSaved: () {
          _toggleSaved(feature);
          Navigator.of(sheetContext).pop();
        },
      ),
    );
  }

  void _showSettings() {
    final context = _navigatorKey.currentContext;
    if (context == null) return;

    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    var selectedTheme = _themeMode;
    var selectedAccent = _accentColor;
    var savedCount = _savedFeatureIds.length;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      constraints: const BoxConstraints(maxWidth: 640),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final brightness = switch (selectedTheme) {
            ThemeMode.light => Brightness.light,
            ThemeMode.dark => Brightness.dark,
            ThemeMode.system => MediaQuery.platformBrightnessOf(sheetContext),
          };
          final sheetTheme = brightness == Brightness.dark
              ? AppTheme.dark(selectedAccent)
              : AppTheme.light(selectedAccent);
          return Padding(
            key: const ValueKey('settings-sheet-safe-area-padding'),
            padding: EdgeInsets.fromLTRB(12, 0, 12, 12 + bottomInset),
            child: Theme(
              data: sheetTheme,
              child: Material(
                color: sheetTheme.colorScheme.surface,
                surfaceTintColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                    bottom: Radius.circular(28),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:
                        (MediaQuery.sizeOf(sheetContext).height - bottomInset) *
                        0.9,
                  ),
                  child: SettingsScreen(
                    themeMode: selectedTheme,
                    onThemeModeChanged: (mode) {
                      setState(() => _themeMode = mode);
                      setSheetState(() => selectedTheme = mode);
                    },
                    accentColor: selectedAccent,
                    onAccentChanged: (color) {
                      setState(() => _accentColor = color);
                      setSheetState(() => selectedAccent = color);
                    },
                    savedCount: savedCount,
                    onClearSaved: () {
                      setState(_savedFeatureIds.clear);
                      setSheetState(() => savedCount = 0);
                    },
                    onClose: () => Navigator.of(sheetContext).pop(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = <AppTab, Widget>{
      AppTab.home: HomeScreen(
        onExplore: () => setState(() => _selectedTab = AppTab.explore),
        onOpenFeature: _showFeature,
      ),
      AppTab.explore: ExploreScreen(
        savedFeatureIds: _savedFeatureIds,
        onOpenFeature: _showFeature,
        onToggleSaved: _toggleSaved,
      ),
      AppTab.library: LibraryScreen(
        savedFeatures: _savedFeatures,
        onExplore: () => setState(() => _selectedTab = AppTab.explore),
        onOpenFeature: _showFeature,
        onRemove: _toggleSaved,
      ),
    };
    final selectedIndex = appTabs.indexWhere((tab) => tab.id == _selectedTab);

    return MaterialApp(
      title: AppConfig.productName,
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(_accentColor),
      darkTheme: AppTheme.dark(_accentColor),
      themeMode: _themeMode,
      home: Builder(
        builder: (context) {
          final home = _showStartupScreen
              ? FocusLoadingScreen(
                  onFinished: () {
                    if (mounted) setState(() => _showStartupScreen = false);
                  },
                )
              : Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        AppHeader(onOpenSettings: _showSettings),
                        Expanded(
                          child: IndexedStack(
                            index: selectedIndex,
                            children: [
                              for (final tab in appTabs) screens[tab.id]!,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: NavigationBar(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (index) =>
                        setState(() => _selectedTab = appTabs[index].id),
                    destinations: [
                      for (final tab in appTabs)
                        NavigationDestination(
                          key: ValueKey('tab-${tab.id.name}'),
                          icon: Icon(tab.icon),
                          selectedIcon: Icon(tab.selectedIcon),
                          label: tab.label,
                        ),
                    ],
                  ),
                );
          final darkSystemBars =
              _showStartupScreen ||
              Theme.of(context).brightness == Brightness.dark;
          final barColor = darkSystemBars
              ? AppColors.pageDark
              : AppColors.pageLight;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: darkSystemBars
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: darkSystemBars
                  ? Brightness.dark
                  : Brightness.light,
              systemNavigationBarColor: barColor,
              systemNavigationBarIconBrightness: darkSystemBars
                  ? Brightness.light
                  : Brightness.dark,
              systemNavigationBarDividerColor: barColor,
              systemNavigationBarContrastEnforced: false,
            ),
            child: home,
          );
        },
      ),
    );
  }
}
