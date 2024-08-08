import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/screens/group_carousel_screen.dart';
import 'package:words/widgets/custom_button.dart';

class WordButtonList extends ConsumerWidget {
  final List<Word> words;
  final int columns;
  final int startIndex;

  const WordButtonList({
    super.key,
    required this.words,
    required this.columns,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knownWords = ref.watch(knownWordsProvider);
    final learnWords = ref.watch(learnWordsProvider);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 8,
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
          columns: columns,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GroupCarouselScreen(
                  words: words,
                  initialIndex: index,
                  startIndex: startIndex,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
