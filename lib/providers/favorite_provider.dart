import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<Word>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<List<Word>> {
  FavoriteNotifier() : super([]);

  void addWord(Word word) {
    if (!state.any((w) => w.id == word.id)) {
      state = [...state, word];
    }
  }

  void removeWord(Word word) {
    state = state.where((w) => w.id != word.id).toList();
  }

  void toggleFavorite(Word word) {
    if (isFavorite(word)) {
      removeWord(word);
    } else {
      addWord(word);
    }
  }

  bool isFavorite(Word word) {
    return state.any((w) => w.id == word.id);
  }

  List<Word> getFavorites() {
    return state;
  }
}
