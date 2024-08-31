import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageProgressNotifier extends StateNotifier<Map<int, double>> {
  final String gameKey;

  ImageProgressNotifier({required this.gameKey}) : super({});

  void incrementProgress(int wordId) {
    double currentProgress = state[wordId] ?? 0.0;
    double newProgress = (currentProgress + 0.2).clamp(0.0, 1.0);

    state = {
      ...state,
      wordId: newProgress,
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
    final progressData = prefs.getString('imageProgress_$gameKey') ?? '{}';

    // Конвертуємо назад з Map<String, double> на Map<int, double>
    final Map<String, double> jsonMap =
        Map<String, double>.from(json.decode(progressData));
    state = jsonMap.map((key, value) => MapEntry(int.parse(key), value));
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Конвертуємо Map<int, double> на Map<String, double>
    final progressData =
        state.map((key, value) => MapEntry(key.toString(), value));

    await prefs.setString('imageProgress_$gameKey', json.encode(progressData));
  }
}

final imageGameProgressProvider =
    StateNotifierProvider<ImageProgressNotifier, Map<int, double>>((ref) {
  return ImageProgressNotifier(gameKey: 'image_game')..loadProgress();
});
