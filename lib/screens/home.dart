import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:words/screens/auth.dart';
import 'package:words/screens/category.dart';
import 'package:words/screens/folder_list.dart';
import 'package:words/screens/word_group.dart';
import 'package:words/utils/show_settings.dart'; // Імпортуйте екран з категоріями

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _navigateToCategories(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoriesScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20), // Додаємо відступ зліва
          child: IconButton(
            icon: Icon(Icons.menu,
                color: Theme.of(context).colorScheme.onSecondary),
            onPressed: () {
              showSettingsScreen(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'All',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 50, // Більший розмір для "E"
                          fontWeight: FontWeight.bold,
                          height: 0.9, // Зменшений міжрядковий інтервал
                        ),
                      ),
                      Text(
                        'words',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 20, // Менший розмір для "words"
                          fontWeight: FontWeight.bold,
                          height: 0.9, // Зменшений міжрядковий інтервал
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: 250, // Задайте бажану ширину кнопки
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WordGroupScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: const Color.fromARGB(255, 65, 93, 104),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  child: const Center(
                    child: Text(
                      'Discover',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 250, // Задайте бажану ширину кнопки
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToCategories(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  child: const Center(
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 250, // Задайте бажану ширину кнопки
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FolderListScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  child: const Center(
                    child: Text(
                      'My folders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(
                  child:
                      SizedBox()), // Додаємо простір між кнопками та нижньою навігацією
            ],
          ),
        ),
      ),
    );
  }
}
