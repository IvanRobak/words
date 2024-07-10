import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/providers/favorite_provider.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/screens/group_carousel_screen.dart';
import 'package:words/widgets/custom_button.dart';
import 'package:words/widgets/filter.dart';

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

  void _navigateToDetails(BuildContext context, WidgetRef ref, List<Word> words,
      int index, int startIndex,
      {bool showFooter = true}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupCarouselScreen(
          words: words,
          initialIndex: index,
          startIndex: startIndex, // Передаємо правильний startIndex
          showFooter: showFooter,
        ),
      ),
    ).then((_) {
      // Перезавантаження стану вручну
      final favorites = ref.read(favoriteProvider.notifier).getFavorites();
      ref.read(wordFilterProvider.notifier).setWords(favorites);
    });
  }

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
              final startIndex = (index ~/ 50) *
                  50; // Визначаємо startIndex для поточної групи
              final endIndex = (startIndex + 50 > words.length)
                  ? words.length
                  : startIndex + 50;
              final currentGroupWords = words.sublist(startIndex, endIndex);
              return CustomButton(
                label: word.word,
                isKnown: knownWords.contains(word.id),
                isLearned: learnWords.contains(word.id),
                onPressed: () => _navigateToDetails(context, ref,
                    currentGroupWords, index - startIndex, startIndex,
                    showFooter:
                        true), // Використовуємо showFooter: true і передаємо правильний startIndex
              );
            },
          ),
        ),
      ],
    );
  }
}
