import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

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
        surface:
            const Color(0xFFFFF3EA), // Replaced 'background' with 'surface'
        onSurface: _cardColorLight,
        onSecondary: _textColor,
        inverseSurface: const Color.fromARGB(255, 233, 225, 219),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: _textColor),
        bodyMedium: TextStyle(color: _textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white;
              }
              return Colors.white;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return _textColor;
              }
              return _textColor;
            },
          ),
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF3EA),
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
        surface:
            const Color(0xFF121212), // Replaced 'background' with 'surface'
        onSurface: _cardColorDark,
        onSecondary: _textColorDark,
        inverseSurface: const Color.fromARGB(255, 44, 37, 64),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: _textColorDark),
        bodyMedium: TextStyle(color: _textColorDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.grey[800]!;
              }
              return Colors.grey[800]!;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white;
              }
              return Colors.white;
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
        surface:
            const Color(0xFFFFF3EA), // Replaced 'background' with 'surface'
        onSurface: ThemeNotifier._cardColorLight,
        onSecondary: ThemeNotifier._textColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: ThemeNotifier._textColor),
        bodyMedium: TextStyle(color: ThemeNotifier._textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white;
              }
              return Colors.white;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return ThemeNotifier._textColor;
              }
              return ThemeNotifier._textColor;
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
