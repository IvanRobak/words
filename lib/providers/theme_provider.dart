import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

  // Додаємо змінні для кольорів тексту та карток
  static const Color _textColor = Color.fromARGB(255, 51, 51, 51);
  static const Color _textColorDark = Colors.white;
  static const Color _cardColorLight = Color.fromARGB(199, 244, 240, 240);
  static const Color _cardColorDark = Color(0xFF1E1E1E);

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
        onSecondary: _textColor,
        onSurface: _cardColorLight, // Додаємо колір картки
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.white; // Білий колір для кнопок в світлій темі
              }
              return Colors.white; // Білий колір для кнопок в світлій темі
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return _textColor; // Колір тексту для кнопок в світлій темі
              }
              return _textColor; // Колір тексту для кнопок в світлій темі
            },
          ),
        ),
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
        onSecondary: _textColorDark,
        onSurface: _cardColorDark, // Додаємо колір картки
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.grey[
                    800]!; // Трохи темніший колір для кнопок в темній темі
              }
              return Colors
                  .grey[800]!; // Трохи темніший колір для кнопок в темній темі
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.white; // Колір тексту для кнопок в темній темі
              }
              return Colors.white; // Колір тексту для кнопок в темній темі
            },
          ),
        ),
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
        onSecondary: ThemeNotifier._textColor,
        onSurface: ThemeNotifier._cardColorLight, // Використовуємо змінну
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.white; // Білий колір для кнопок в світлій темі
              }
              return Colors.white; // Білий колір для кнопок в світлій темі
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return ThemeNotifier
                    ._textColor; // Колір тексту для кнопок в світлій темі
              }
              return ThemeNotifier
                  ._textColor; // Колір тексту для кнопок в світлій темі
            },
          ),
        ),
      ),
    ),
    false,
  );
  themeNotifier.loadTheme();
  return themeNotifier;
});
