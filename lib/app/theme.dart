import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._(); //nesne oluşturmaya izin verme
  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'Inter',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF42B4CA),
      secondary: Color(0XFFD5E9ED),
      surface: Colors.white,
      onSurface: Color(0xFF414A4C),
      error: Color(0XFFEA7979),
      tertiary: Color(0XFFB5C4C7),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: const Color(0xFF42B4CA)),
    ),
  );
}
