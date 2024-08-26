import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words/models/word.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<Word>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<List<Word>> {
  FavoriteNotifier() : super([]) {
    loadFavoriteWords();
  }

  void addWord(Word word) {
    if (!state.any((w) => w.id == word.id)) {
      state = [...state, word];
      _saveFavoriteWords();
    }
  }

  void removeWord(Word word) {
    state = state.where((w) => w.id != word.id).toList();
    _saveFavoriteWords();
  }

  bool isFavorite(Word word) {
    return state.any((w) => w.id == word.id);
  }

  List<Word> getFavorites() {
    return state;
  }

  void clearFavorites() {
    state = [];
    _saveFavoriteWords(); // Очищення даних також повинно бути збережено
  }

  Future<void> loadFavoriteWords() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteWordsJson = prefs.getStringList('favoriteWords') ?? [];
    state = favoriteWordsJson.map((wordJson) {
      final Map<String, dynamic> wordMap = json.decode(wordJson);
      return Word.fromJson(wordMap);
    }).toList();
  }

  Future<void> _saveFavoriteWords() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteWordsJson =
        state.map((word) => json.encode(word.toJson())).toList();
    await prefs.setStringList('favoriteWords', favoriteWordsJson);
  }
}
