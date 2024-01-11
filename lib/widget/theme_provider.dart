// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';



class ThemeProvider extends ChangeNotifier {

  ThemeMode themeMode = ThemeMode.system;
  bool checktheme = false;
  double? fontSize;

  void update() {
    notifyListeners();
  }

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
      toggleableActiveColor: const Color(0xff021226),
      primaryColor: Colors.black,
      dividerColor: Colors.white,
      colorScheme: const ColorScheme.dark(),
      iconTheme: const IconThemeData(color: Colors.white),
      secondaryHeaderColor: Colors.blueGrey[700]!,
      // secondaryHeaderColor: const Color(0xff141414),
      dialogBackgroundColor: Colors.white,
      backgroundColor: Colors.blue.shade700,
      highlightColor: Colors.white,
      primaryColorDark: Colors.grey[900],
      primaryColorLight: Colors.grey[500],
      focusColor: Colors.grey[900],
      disabledColor: Colors.grey[900],
      scaffoldBackgroundColor: Colors.grey[900]);

  static final lightTheme = ThemeData(
      textTheme: TextTheme(
        bodyText1: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
      toggleableActiveColor: const Color(0xfffff7EC),
      dividerColor: Colors.black,
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      // secondaryHeaderColor: const Color.fromARGB(255, 245, 237, 237),
      dialogBackgroundColor: Colors.blue,
      backgroundColor: Colors.grey.shade500,
      highlightColor: Colors.black,
      primaryColorDark: Colors.grey.shade200,
      primaryColorLight: Colors.grey.shade700,
      focusColor: const Color(0xfff5f5f5),
      disabledColor: Colors.white,
      scaffoldBackgroundColor: Color(0xfff5f7f8),
      secondaryHeaderColor: Colors.blue.withOpacity(.2));
}
