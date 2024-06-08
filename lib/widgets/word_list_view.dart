import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/widgets/word_button.dart';
import 'package:words/widgets/filter.dart';

class WordListView extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
              return WordButton(
                word: word,
                columns: columns,
                words: words,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}
