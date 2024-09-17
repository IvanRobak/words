import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeEvent { toggle }

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  bool _isDarkMode = false;

  ThemeBloc() : super(_lightTheme()) {
    on<ThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      if (_isDarkMode) {
        _isDarkMode = false;
        emit(_lightTheme());
      } else {
        _isDarkMode = true;
        emit(_darkTheme());
      }
      await prefs.setBool('isDarkMode', _isDarkMode);
    });
    _loadTheme();
  }

  static ThemeData _lightTheme() {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blueGrey,
      ).copyWith(
        primary: const Color.fromARGB(255, 65, 93, 104),
        secondary: const Color.fromARGB(255, 255, 145, 0),
        surface: const Color(0xFFFFF3EA),
        onSurface: const Color.fromARGB(199, 244, 240, 240),
        onSecondary: const Color.fromARGB(255, 51, 51, 51),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color.fromARGB(255, 51, 51, 51)),
        bodyMedium: TextStyle(color: Color.fromARGB(255, 51, 51, 51)),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF3EA),
    );
  }

  static ThemeData _darkTheme() {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
      ),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: const Color.fromARGB(255, 18, 32, 47),
        secondary: const Color.fromARGB(255, 255, 145, 0),
        surface: const Color(0xFF121212),
        onSurface: const Color(0xFF1E1E1E),
        onSecondary: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    if (_isDarkMode) {
      add(ThemeEvent.toggle);
    }
  }
}
