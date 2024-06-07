import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/screens/tabs.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blueGrey,
  ).copyWith(
    primary: const Color.fromARGB(255, 65, 93, 104),
    secondary: const Color.fromARGB(255, 255, 145, 0),
    background: const Color(0xFFFFF3EA),
    surface: const Color.fromARGB(255, 233, 225, 219),
  ),
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const TabsScreen(),
    );
  }
}
