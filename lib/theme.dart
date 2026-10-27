import 'package:flutter/material.dart';

/// Palet Noot. Navy dan biru berasal dari latar logo, kuning dari badan pensil.
class NootColors {
  NootColors._();

  /// Sama persis dengan latar gambar logo, supaya logo menyatu di layar splash.
  static const navy = Color(0xFF0C3962);
  static const blue = Color(0xFF2F91E7);
  static const yellow = Color(0xFFF6C948);
  static const ground = Color(0xFFF4F7FB);
  static const muted = Color(0xFF4F6580);
  static const line = Color(0x330C3962);
  static const hint = Color(0x990C3962);
  static const danger = Color(0xFF8A1C14);
}

/// Satu-satunya keluarga huruf di aplikasi: TeX Gyre Pagella.
const String kFont = 'Pagella';

TextStyle nootText(
  double size, {
  FontWeight weight = FontWeight.w400,
  FontStyle style = FontStyle.normal,
  Color color = NootColors.navy,
  double height = 1.3,
  double letterSpacing = 0,
}) {
  return TextStyle(
    fontFamily: kFont,
    fontSize: size,
    fontWeight: weight,
    fontStyle: style,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

ThemeData buildNootTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: NootColors.navy,
    brightness: Brightness.light,
  ).copyWith(
    primary: NootColors.navy,
    onPrimary: Colors.white,
    secondary: NootColors.yellow,
    onSecondary: NootColors.navy,
    surface: NootColors.ground,
    onSurface: NootColors.navy,
    error: NootColors.danger,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: kFont,
  );

  final shape8 = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));

  return base.copyWith(
    scaffoldBackgroundColor: NootColors.ground,
    splashFactory: InkRipple.splashFactory,
    textTheme: base.textTheme.apply(
      fontFamily: kFont,
      bodyColor: NootColors.navy,
      displayColor: NootColors.navy,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: NootColors.ground,
      foregroundColor: NootColors.navy,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: nootText(21, weight: FontWeight.w700),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: NootColors.yellow,
        foregroundColor: NootColors.navy,
        minimumSize: const Size.fromHeight(54),
        shape: shape8,
        textStyle: nootText(18, weight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: NootColors.navy,
        minimumSize: const Size.fromHeight(54),
        side: const BorderSide(color: NootColors.line),
        shape: shape8,
        textStyle: nootText(17),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: NootColors.navy,
        textStyle: nootText(16, weight: FontWeight.w700),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: NootColors.navy,
      contentTextStyle: nootText(16, color: Colors.white),
      actionTextColor: NootColors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      textStyle: nootText(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: NootColors.ground,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: NootColors.navy,
      selectionColor: Color(0x330C3962),
      selectionHandleColor: NootColors.navy,
    ),
  );
}

/// Dekorasi untuk kolom isian yang berdiri sendiri (Beranda dan Login).
InputDecoration nootInput(String hint, {Widget? prefix, Widget? suffix}) {
  OutlineInputBorder border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    hintText: hint,
    hintStyle: nootText(17, color: NootColors.hint),
    prefixIcon: prefix,
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    border: border(NootColors.line),
    enabledBorder: border(NootColors.line),
    focusedBorder: border(NootColors.navy, 2),
  );
}
