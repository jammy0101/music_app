import 'package:flutter/material.dart';
import 'package:music/theme/dark_mode.dart';
import 'package:music/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //light mode
  ThemeData _themeData = lightMode;

  //get theme

  ThemeData get themeData => _themeData;

  //dark mode

  bool get isDarkMode => _themeData == darkMode;

  //set theme

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
