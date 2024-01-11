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
      primaryColor: Colors.black,
      dividerColor: Colors.white,
      colorScheme: const ColorScheme.dark(),
      iconTheme: const IconThemeData(color: Colors.white),

      disabledColor: Colors.grey[900],
  );

  static final lightTheme = ThemeData(
      textTheme: TextTheme(
        bodyText1: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
      dividerColor: Colors.black,
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),

      disabledColor: Colors.white,
     );
}
