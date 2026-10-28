import 'package:flutter/material.dart';

/// Palet Noot: satu latar, satu tinta, satu aksen biru.
/// Pemisah antar permukaan memakai selisih tone, bukan garis atau bayangan.
class NootColors {
  static const ground = Color(0xFFF3F6FC);
  static const surface = Colors.white;
  static const ink = Color(0xFF0E1A33);
  static const muted = Color(0xFF55657F);
  static const blue = Color(0xFF1457F5);
  static const blueSoft = Color(0xFFE4ECFF);
  static const danger = Color(0xFFD64545);
}

/// Pilihan warna catatan (dipakai di form dan kartu).
class NoteSwatch {
  const NoteSwatch(this.name, this.tint, this.solid);
  final String name;
  final Color tint;
  final Color solid;
}

const noteSwatches = <NoteSwatch>[
  NoteSwatch('Biru', Color(0xFFDDE8FF), Color(0xFF2F6BFF)),
  NoteSwatch('Hijau', Color(0xFFD6F3EA), Color(0xFF1FA97F)),
  NoteSwatch('Kuning', Color(0xFFFFF0C4), Color(0xFFE9A800)),
  NoteSwatch('Merah muda', Color(0xFFFFDDE6), Color(0xFFE5507C)),
  NoteSwatch('Ungu', Color(0xFFE7DFFF), Color(0xFF7352F0)),
];

ThemeData buildNootTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: NootColors.blue,
      primary: NootColors.blue,
      surface: NootColors.surface,
    ),
    scaffoldBackgroundColor: NootColors.ground,
  );

  final text = base.textTheme.apply(
    bodyColor: NootColors.ink,
    displayColor: NootColors.ink,
  );

  OutlineInputBorder border(Color c, [double w = 0]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: w == 0 ? BorderSide.none : BorderSide(color: c, width: w),
      );

  return base.copyWith(
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: NootColors.ground,
      foregroundColor: NootColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: NootColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: text.bodyMedium?.copyWith(color: const Color(0xFF8C98AE)),
      border: border(Colors.transparent),
      enabledBorder: border(Colors.transparent),
      focusedBorder: border(NootColors.blue, 1.5),
      errorBorder: border(NootColors.danger, 1.5),
      focusedErrorBorder: border(NootColors.danger, 1.5),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: NootColors.ink,
      contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
