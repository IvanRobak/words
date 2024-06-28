import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/screens/word_carousel.dart';
import 'package:words/widgets/custom_button.dart';

class WordButtonList extends ConsumerWidget {
  final List<Word> words;
  final int columns;

  const WordButtonList({
    super.key,
    required this.words,
    required this.columns,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knownWords = ref.watch(knownWordsProvider);
    final learnWords = ref.watch(learnWordsProvider);

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 4,
        ),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return CustomButton(
            label: word.word,
            isKnown: knownWords.contains(word.id),
            isLearned: learnWords.contains(word.id),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordCarouselScreen(
                    words: words,
                    initialIndex: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
