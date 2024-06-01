import 'package:flutter/material.dart';
import 'package:words/screens/word_details.dart';
import 'package:words/services/word_loader.dart';
import '../models/word.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> words = [];

  @override
  void initState() {
    super.initState();
    loadWordsFromJson();
  }

  Future<void> loadWordsFromJson() async {
    final loadedWords = await loadWords();
    setState(() {
      words = loadedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All words'),
      ),
      body: words.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Два стовпці
                  mainAxisSpacing: 10, // Відстань між рядами
                  crossAxisSpacing: 10, // Відстань між стовпцями
                  childAspectRatio: 3, // Співвідношення сторін елемента
                ),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  return Padding(
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WordDetailScreen(word: word.word),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF426CD8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12), // Зменште ці значення
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ));
                },
              ),
            ),
    );
  }
}
