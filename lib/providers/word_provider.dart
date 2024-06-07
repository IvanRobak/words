import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/word.dart';

class WordFilterNotifier extends StateNotifier<List<Word>> {
  WordFilterNotifier() : super([]);

  List<Word> allWords = [];

  void setWords(List<Word> words) {
    allWords = words;
    state = words;
  }

  void filterWords(String query) {
    final List<Word> results = allWords.where((word) {
      final String wordText = word.word.toLowerCase();
      final String input = query.toLowerCase();
      return wordText.startsWith(input);
    }).toList();
    state = results;
  }
}

final wordFilterProvider =
    StateNotifierProvider<WordFilterNotifier, List<Word>>((ref) {
  return WordFilterNotifier();
});
