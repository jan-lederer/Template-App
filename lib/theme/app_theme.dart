import 'package:flutter/material.dart';

abstract final class AppColors {
  static const brandMark = Color(0xFFE77860);
  static const ion = Color(0xFF19B8AA);
  static const violet = Color(0xFF8D78F6);
  static const coral = Color(0xFFD75E45);
  static const mint = Color(0xFF2C9B76);
  static const pageLight = Color(0xFFF3F6FA);
  static const pageDark = Color(0xFF090E19);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF111A2A);
  static const inkLight = Color(0xFF172235);
  static const inkDark = Color(0xFFF1F5FA);
  static const mutedLight = Color(0xFF56657B);
  static const mutedDark = Color(0xFFA4B2C5);
  static const lineLight = Color(0xFFDDE5EF);
  static const lineDark = Color(0xFF27364B);
}

abstract final class AppTheme {
  static ThemeData light(Color accent) => _create(accent, Brightness.light);

  static ThemeData dark(Color accent) => _create(accent, Brightness.dark);

  static ThemeData _create(Color accent, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark ? AppColors.pageDark : AppColors.pageLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final ink = isDark ? AppColors.inkDark : AppColors.inkLight;
    final muted = isDark ? AppColors.mutedDark : AppColors.mutedLight;
    final line = isDark ? AppColors.lineDark : AppColors.lineLight;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: accent,
          brightness: brightness,
        ).copyWith(
          surface: surface,
          onSurface: ink,
          onSurfaceVariant: muted,
          outline: line,
          outlineVariant: line,
          tertiary: AppColors.violet,
          onTertiary: AppColors.pageDark,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Roboto',
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      dividerTheme: DividerThemeData(color: line, thickness: 1),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: accent.withValues(alpha: isDark ? 0.18 : 0.14),
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        showDragHandle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      iconTheme: IconThemeData(color: muted),
    );
  }
}
