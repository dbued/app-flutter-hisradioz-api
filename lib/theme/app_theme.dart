import 'package:flutter/material.dart';

const Color kYellow = Color(0xFFFFCE00);
const Color kYellowBright = Color(0xFFFFD600);
const Color kBlack = Color(0xFF000000);
const Color kGrey = Color(0xFF9A9A9E);
const Color kGreyLight = Color(0xFFD6D6D6);
const Color kGreyBg = Color(0xFFF0F0F0);
const Color kBlue = Color(0xFF1F6FBE);
const Color kBlueDark = Color(0xFF113E6B);
const Color kTurquoise = Color(0xFF26C6DA);
const Color kRedSoft = Color(0xFFE26060);

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kYellow,
      brightness: Brightness.light,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: kBlack,
      contentTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
  );
}
