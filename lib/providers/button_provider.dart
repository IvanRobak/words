import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KnownWordsNotifier extends StateNotifier<Set<int>> {
  KnownWordsNotifier() : super({}) {
    loadKnownWords();
  }

  void add(int wordIndex) {
    state = {...state, wordIndex};
    _saveKnownWords();
  }

  void remove(int wordIndex) {
    state = {...state}..remove(wordIndex);
    _saveKnownWords();
  }

  Future<void> loadKnownWords() async {
    final prefs = await SharedPreferences.getInstance();
    final knownWords =
        (prefs.getStringList('knownWords') ?? []).map(int.parse).toSet();
    state = knownWords;
  }

  Future<void> _saveKnownWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'knownWords', state.map((id) => id.toString()).toList());
  }
}

class LearnWordsNotifier extends StateNotifier<Set<int>> {
  LearnWordsNotifier() : super({}) {
    loadLearnWords();
  }

  void add(int wordIndex) {
    state = {...state, wordIndex};
    _saveLearnWords();
  }

  void remove(int wordIndex) {
    state = {...state}..remove(wordIndex);
    _saveLearnWords();
  }

  Future<void> loadLearnWords() async {
    final prefs = await SharedPreferences.getInstance();
    final learnWords =
        (prefs.getStringList('learnWords') ?? []).map(int.parse).toSet();
    state = learnWords;
  }

  Future<void> _saveLearnWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'learnWords', state.map((id) => id.toString()).toList());
  }
}

final knownWordsProvider =
    StateNotifierProvider<KnownWordsNotifier, Set<int>>((ref) {
  return KnownWordsNotifier();
});

final learnWordsProvider =
    StateNotifierProvider<LearnWordsNotifier, Set<int>>((ref) {
  return LearnWordsNotifier();
});
