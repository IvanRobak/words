import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/screens/detail_screen.dart';

class FolderButton extends StatelessWidget {
  final Word word;
  final int columns;
  final List<Word> words;
  final int index;

  const FolderButton(
      {super.key,
      required this.word,
      required this.columns,
      required this.words,
      required this.index});

  @override
  Widget build(BuildContext context) {
    double fontSize = 24;
    double verticalPadding = 8;
    double horizontalPadding = 12;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                words: words,
                initialIndex: index,
              ),
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
