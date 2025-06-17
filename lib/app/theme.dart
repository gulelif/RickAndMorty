import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  ThemeData get theme => themeMode == ThemeMode.light ? lightTheme : darkTheme;

  void toggleThemeMode() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

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

  static ThemeData get darkTheme => ThemeData(
    fontFamily: 'Inter',
    scaffoldBackgroundColor: Color(0xff414a4c),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF97C3E9),
      secondary: Color.fromARGB(255, 112, 124, 127),
      surface: Color(0xff414a4c),
      onSurface: Colors.white,
      error: Color(0XFFEA7979),
      tertiary: Color(0XFFB5C4C7),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: const Color(0xFF97C3E9)),
    ),
  );
}
