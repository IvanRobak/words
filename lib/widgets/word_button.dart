import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/screens/word_details.dart';

class WordButton extends StatelessWidget {
  const WordButton({super.key, required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 12), // Зменште ці значення
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
  }
}
