import 'package:flutter/material.dart';
import '../constants/colors.dart';

ButtonStyle _goldButton(Color bg, Color fg) => FilledButton.styleFrom(
  backgroundColor: bg,
  foregroundColor: fg,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
);

ThemeData buildLightTheme() {
  final scheme = const ColorScheme.light(
    primary: kGoldDarkened,               // ← أغمق شوية في اللايت
    secondary: kGoldDarkened,
    surface: kLightSurface,
    background: kLightBackground,
    onSurface: kLightOnSurface,
    onSurfaceVariant: kLightOnSurfaceVariant,
    outlineVariant: kOutlineLight,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: scheme,
    scaffoldBackgroundColor: kLightBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: kLightAppBarFg,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: kCardFillOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kCardBorderGoldAlpha),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: kLightOnSurfaceVariant),
      filled: true,
      fillColor: kLightInputFill,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: kLightInputBorder),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: kLightInputFocusBorder, width: 1.4),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: kErrorRed),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: kLightChipBg,
      labelStyle: const TextStyle(color: kLightOnSurface),
      selectedColor: kGoldSelectedLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: kOutlineLight),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kGoldDarkened, // توحيد مع لون الأزرار في اللايت
      foregroundColor: kOnPrimary,
    ),

    // ===== أزرار =====
    filledButtonTheme: FilledButtonThemeData(
      style: _goldButton(kGoldDarkened, kOnPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _goldButton(kGoldDarkened, kOnPrimary),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kGoldDarkened,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(color: kGoldDarkened, fontWeight: FontWeight.w700),
      displayLarge: TextStyle(color: kGoldDarkened, fontWeight: FontWeight.w800, letterSpacing: -1.2),
      bodyLarge: TextStyle(color: kLightOnSurface),
      bodyMedium: TextStyle(color: kLightOnSurface),
      bodySmall: TextStyle(color: kLightOnSurfaceVariant),
    ),
  );
}

ThemeData buildDarkTheme() {
  final scheme = const ColorScheme.dark(
    primary: kGold,                 // ← زي ما هو في الدارك
    secondary: kGold,
    surface: kDarkSurface,
    background: kDark,
    onSurface: kGrey,
    onSurfaceVariant: kGreyVariant,
    outlineVariant: kOutlineDark,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: kDark,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: kGrey,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: kCardFillOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kCardBorderGoldAlpha),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: kGreyVariant),
      filled: true,
      fillColor: kDarkInputFill,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: kDarkInputBorder),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: kDarkInputFocusBorder, width: 1.4),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: kErrorRed),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: kDarkChipBg,
      labelStyle: const TextStyle(color: kGrey),
      selectedColor: kGoldSelectedDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: kCardBorderGoldAlpha),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kGold,
      foregroundColor: kOnPrimary,
    ),

    // ===== أزرار =====
    filledButtonTheme: FilledButtonThemeData(
      style: _goldButton(kGold, kOnPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _goldButton(kGold, kOnPrimary),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kGold,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(color: kGold, fontWeight: FontWeight.w700),
      displayLarge: TextStyle(color: kGold, fontWeight: FontWeight.w800, letterSpacing: -1.2),
      bodyLarge: TextStyle(color: kGrey),
      bodyMedium: TextStyle(color: kGrey),
      bodySmall: TextStyle(color: kGreyVariant),
    ),
  );
}
