import 'package:flutter/material.dart';
import 'package:words/screens/word_details.dart';
import '../models/word.dart';

class WordListScreen extends StatelessWidget {
  WordListScreen({super.key});

  final List<Word> words = List.generate(
    20,
    (index) => Word(
      word: 'Слово $index',
      description: 'Опис для слова $index',
      difficulty: index % 3,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All words'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Два стовпці
            mainAxisSpacing: 10, // Відстань між рядами
            crossAxisSpacing: 15, // Відстань між стовпцями
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
                      builder: (context) => WordDetailScreen(word: word.word),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF426CD8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                child: Text(
                  word.word,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
