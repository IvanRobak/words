import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/screens/folder_list.dart';
import 'package:words/screens/word_list.dart';
// import 'package:words/screens/categories_screen.dart'; // Імпортуйте екран з категоріями, коли він буде створений

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF3EA),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20), // Додаємо відступ зліва
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Додайте дію для кнопки налаштувань
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20), // Додаємо відступ справа
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {
                // Додайте дію для кнопки профілю
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Center(
                  child: Text(
                    'Discover\nwords',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
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
                        builder: (context) => const WordListScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 65, 93, 104),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  child: const Center(
                    child: Text(
                      'All words',
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 65, 93, 104),
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
                    backgroundColor: const Color.fromARGB(255, 65, 93, 104),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 233, 225, 219),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
        // currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        // onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Додайте дію для кнопки
        },
        backgroundColor: const Color.fromARGB(255, 65, 93, 104),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
