import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/screens/tabs.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final theme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
      builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()}),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blueGrey,
  ).copyWith(
    primary: const Color.fromARGB(255, 65, 93, 104),
    secondary: const Color.fromARGB(255, 255, 145, 0),
    background: const Color(0xFFFFF3EA),
    surface: const Color.fromARGB(255, 233, 225, 219),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
