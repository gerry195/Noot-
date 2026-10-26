import 'package:flutter/material.dart';

class NootColors {
  static const primary = Color(0xFF1F6FEB);
  static const primaryDark = Color(0xFF1448C9);
  static const ink = Color(0xFF0B2447);
  static const muted = Color(0xFF6B7A99);
  static const canvas = Color(0xFFF4F8FF);
  static const line = Color(0xFFDDE6F5);
  static const danger = Color(0xFFE5484D);
}

ThemeData buildNootTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: NootColors.primary,
      primary: NootColors.primary,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: NootColors.canvas,
    textTheme: base.textTheme.apply(
      bodyColor: NootColors.ink,
      displayColor: NootColors.ink,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: NootColors.canvas,
      foregroundColor: NootColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: NootColors.ink,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: NootColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: NootColors.ink,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: NootColors.line),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: NootColors.ink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

OutlineInputBorder _border(Color color, [double width = 1]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: color, width: width),
  );
}

/// Dekorasi input yang sama untuk semua form di Noot.
InputDecoration nootInput(String hint, {Widget? prefix, Widget? suffix}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: NootColors.muted),
    prefixIcon: prefix,
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: _border(NootColors.line),
    enabledBorder: _border(NootColors.line),
    focusedBorder: _border(NootColors.primary, 1.6),
    errorBorder: _border(NootColors.danger),
    focusedErrorBorder: _border(NootColors.danger, 1.6),
  );
}
