import 'package:flutter/material.dart';
import 'package:words/widgets/filter.dart';
import '../models/word.dart';
import 'word_button.dart';

class WordListView extends StatelessWidget {
  final List<Word> words;
  final int columns;
  final Function(int?) onColumnsChanged;
  final Function(String) onSearchChanged;
  final TextEditingController searchController;
  final List<int> columnOptions;

  const WordListView({
    super.key,
    required this.words,
    required this.columns,
    required this.onColumnsChanged,
    required this.onSearchChanged,
    required this.searchController,
    required this.columnOptions,
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
          child: words.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
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
                      return WordButton(word: word, columns: columns);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
