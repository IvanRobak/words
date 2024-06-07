import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Word>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<List<Word>> {
  FavoriteNotifier() : super([]);

  void addWord(Word word) {
    state = [...state, word];
  }

  void removeWord(Word word) {
    state = state.where((w) => w != word).toList();
  }
}
