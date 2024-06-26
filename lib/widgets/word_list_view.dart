import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/screens/word_carousel.dart';
import 'package:words/widgets/custom_button.dart';
import 'package:words/widgets/filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordListView extends ConsumerWidget {
  final List<Word> words;
  final int columns;
  final List<int> columnOptions;
  final TextEditingController searchController;
  final ValueChanged<int?> onColumnsChanged;
  final ValueChanged<String> onSearchChanged;

  const WordListView({
    super.key,
    required this.words,
    required this.columns,
    required this.columnOptions,
    required this.searchController,
    required this.onColumnsChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knownWords = ref.watch(knownWordsProvider);
    final learnWords = ref.watch(learnWordsProvider);

    return Column(
      children: [
        FilterBar(
          columns: columns,
          columnOptions: columnOptions,
          searchController: searchController,
          onColumnsChanged: onColumnsChanged,
          onSearchChanged: onSearchChanged,
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3,
            ),
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return CustomButton(
                label: word.word,
                isKnown: knownWords.contains(word.id),
                isLearned: learnWords.contains(word.id),
                onPressed: () {
                  // Навігація до WordCarouselScreen з відповідним індексом
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WordCarouselScreen(
                        words: words,
                        initialIndex: index,
                        // searchForUnselectedIndex: false, // Передаємо параметр
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
