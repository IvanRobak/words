import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/screens/word_carousel.dart';

class WordButton extends StatelessWidget {
  final Word word;
  final int columns;
  final List<Word> words;
  final int index;

  const WordButton(
      {super.key,
      required this.word,
      required this.columns,
      required this.words,
      required this.index});

  @override
  Widget build(BuildContext context) {
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
              builder: (context) =>
                  WordCarouselScreen(words: words, initialIndex: index),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
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
      ),
    );
  }
}
