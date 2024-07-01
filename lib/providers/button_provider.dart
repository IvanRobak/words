import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KnownWordsNotifier extends StateNotifier<Set<int>> {
  KnownWordsNotifier() : super({}) {
    loadKnownWords();
  }

  void add(int wordIndex) {
    print('Adding $wordIndex to known words');
    if (!state.contains(wordIndex)) {
      state = {...state, wordIndex};
      _saveKnownWords();
      print('Added $wordIndex to known words: $state');
    }
  }

  void remove(int wordIndex) {
    print('Removing $wordIndex from known words');
    if (state.contains(wordIndex)) {
      state = {...state}..remove(wordIndex);
      _saveKnownWords();
      print('Removed $wordIndex from known words: $state');
    }
  }

  Future<void> loadKnownWords() async {
    final prefs = await SharedPreferences.getInstance();
    final knownWords = (prefs.getStringList('knownWords') ?? [])
        .map((id) => int.tryParse(id) ?? -1)
        .where((id) => id != -1)
        .toSet();
    state = knownWords;
    print('Loaded known words: $knownWords');
  }

  Future<void> _saveKnownWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'knownWords', state.map((id) => id.toString()).toList());
    print('Saved known words: $state');
  }
}

class LearnWordsNotifier extends StateNotifier<Set<int>> {
  LearnWordsNotifier() : super({}) {
    loadLearnWords();
  }

  void add(int wordIndex) {
    print('Adding $wordIndex to learn words');
    if (!state.contains(wordIndex)) {
      state = {...state, wordIndex};
      _saveLearnWords();
      print('Added $wordIndex to learn words: $state');
    }
  }

  void remove(int wordIndex) {
    print('Removing $wordIndex from learn words');
    if (state.contains(wordIndex)) {
      state = {...state}..remove(wordIndex);
      _saveLearnWords();
      print('Removed $wordIndex from learn words: $state');
    }
  }

  Future<void> loadLearnWords() async {
    final prefs = await SharedPreferences.getInstance();
    final learnWords = (prefs.getStringList('learnWords') ?? [])
        .map((id) => int.tryParse(id) ?? -1)
        .where((id) => id != -1)
        .toSet();
    state = learnWords;
    print('Loaded learn words: $learnWords');
  }

  Future<void> _saveLearnWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'learnWords', state.map((id) => id.toString()).toList());
    print('Saved learn words: $state');
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
