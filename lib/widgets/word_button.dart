import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/screens/word_details.dart';

class WordButton extends StatelessWidget {
  const WordButton({super.key, required this.word, required this.columns});

  final Word word;
  final int columns;

  @override
  Widget build(BuildContext context) {
    // Налаштування стилю в залежності від кількості стовпців
    final double fontSize = columns == 2 ? 16 : 14;
    final double verticalPadding = columns == 2 ? 8 : 3;
    final double horizontalPadding = columns == 2 ? 12 : 5;

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
            padding: EdgeInsets.symmetric(
                vertical: verticalPadding, horizontal: horizontalPadding),
            textStyle: TextStyle(fontSize: fontSize),
          ),
          child: Text(
            word.word,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
            ),
          ),
        ));
  }
}
