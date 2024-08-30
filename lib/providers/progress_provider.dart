// word_progress_providers.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordProgressNotifier extends StateNotifier<Map<int, double>> {
  final String gameKey;

  WordProgressNotifier({required this.gameKey}) : super({});

  void incrementProgress(int wordId) {
    state = {
      ...state,
      wordId: (state[wordId] ?? 0.0) + 0.2,
    };
    _saveProgress();
  }

  double getProgress(int wordId) {
    return state[wordId] ?? 0.0;
  }

  void clearProgress() {
    state = {};
    _saveProgress(); // Зберегти очищений прогрес
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressData = prefs.getString('wordProgress_$gameKey') ?? '{}';
    state = Map<int, double>.from(json.decode(progressData));
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wordProgress_$gameKey', json.encode(state));
  }
}

final wordProgressWordProvider =
    StateNotifierProvider<WordProgressNotifier, Map<int, double>>((ref) {
  return WordProgressNotifier(gameKey: 'word')..loadProgress();
});

final wordProgressImageProvider =
    StateNotifierProvider<WordProgressNotifier, Map<int, double>>((ref) {
  return WordProgressNotifier(gameKey: 'image')..loadProgress();
});
