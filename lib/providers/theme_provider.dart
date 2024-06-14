import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

  ThemeNotifier(this._themeData, this._isDarkMode);

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (_isDarkMode) {
      _themeData = lightTheme();
      _isDarkMode = false;
    } else {
      _themeData = darkTheme();
      _isDarkMode = true;
    }
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    if (_isDarkMode) {
      _themeData = darkTheme();
    } else {
      _themeData = lightTheme();
    }
    notifyListeners();
  }

  ThemeData lightTheme() {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blueGrey,
      ).copyWith(
        primary: const Color.fromARGB(255, 65, 93, 104),
        secondary: const Color.fromARGB(255, 255, 145, 0),
        background: const Color(0xFFFFF3EA),
        surface: const Color.fromARGB(255, 233, 225, 219),
        onSecondary: Colors.black,
      ),
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
      ),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: const Color.fromARGB(255, 18, 32, 47),
        secondary: const Color.fromARGB(255, 255, 145, 0),
        background: const Color(0xFF121212),
        surface: const Color(0xFF1E1E1E),
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}

final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  final themeNotifier = ThemeNotifier(
    ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blueGrey,
      ).copyWith(
        primary: const Color.fromARGB(255, 65, 93, 104),
        secondary: const Color.fromARGB(255, 255, 145, 0),
        background: const Color(0xFFFFF3EA),
        surface: const Color.fromARGB(255, 233, 225, 219),
      ),
    ),
    false,
  );
  themeNotifier.loadTheme();
  return themeNotifier;
});
