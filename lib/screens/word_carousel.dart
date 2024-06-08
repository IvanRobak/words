import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/widgets/word_detail.dart';

class WordCarouselScreen extends StatelessWidget {
  final List<Word> words;
  final int initialIndex;

  const WordCarouselScreen(
      {super.key, required this.words, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Carousel'),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 160),
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height * 0.7, // Обмеження висоти
              child: WordDetail(word: word),
            ),
          );
        },
      ),
    );
  }
}
