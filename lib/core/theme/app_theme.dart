import 'package:flutter/material.dart';
import '../constants/colors.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kDark,
    colorScheme: const ColorScheme.dark(
      primary: kGold,
      secondary: kGold,
      surface: kDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0x441F1F1F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0x33FFD700)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0x221F1F1F),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0x33FFD700)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kGold, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0x331F1F1F),
      labelStyle: const TextStyle(color: Colors.white),
      selectedColor: kGold.withOpacity(.18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: Color(0x33FFD700)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kGold,
      foregroundColor: Colors.black,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1.2),
      titleLarge: TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}
