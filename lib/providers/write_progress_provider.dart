import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteWordProgressNotifier extends StateNotifier<Map<int, double>> {
  final String gameKey;

  WriteWordProgressNotifier({required this.gameKey}) : super({});

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
    _saveProgress();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressData = prefs.getString('wordProgress_$gameKey') ?? '{}';

    // Конвертуємо назад з Map<String, double> на Map<int, double>
    final Map<String, double> jsonMap =
        Map<String, double>.from(json.decode(progressData));
    state = jsonMap.map((key, value) => MapEntry(int.parse(key), value));
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final progressData =
        state.map((key, value) => MapEntry(key.toString(), value));

    await prefs.setString('wordProgress_$gameKey', json.encode(progressData));
  }
}

final writeWordProgressProvider =
    StateNotifierProvider<WriteWordProgressNotifier, Map<int, double>>((ref) {
  return WriteWordProgressNotifier(gameKey: 'writeWord')..loadProgress();
});
