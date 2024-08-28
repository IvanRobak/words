import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordProgressNotifier extends StateNotifier<Map<int, double>> {
  WordProgressNotifier() : super({});

  void incrementProgress(int wordId) {
    state = {
      ...state,
      wordId: (state[wordId] ?? 0.0) + 0.2,
    };
  }

  double getProgress(int wordId) {
    return state[wordId] ?? 0.0;
  }
}

final wordProgressProvider =
    StateNotifierProvider<WordProgressNotifier, Map<int, double>>((ref) {
  return WordProgressNotifier();
});
