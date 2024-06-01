import 'package:flutter/material.dart';
import 'package:words/screens/word_details.dart';
import '../models/word.dart';

class WordListScreen extends StatelessWidget {
  final List<Word> words = List.generate(
    50,
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
        title: Text('Всі слова'),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return ListTile(
            title: Text(word.word),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordDetailScreen(word: word.word),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
