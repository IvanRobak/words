import 'package:flutter_riverpod/flutter_riverpod.dart';

final correctAnswersProvider =
    StateNotifierProvider<CorrectAnswersNotifier, int>((ref) {
  return CorrectAnswersNotifier();
});

class CorrectAnswersNotifier extends StateNotifier<int> {
  CorrectAnswersNotifier() : super(0);

  void increment() {
    state = state + 1;
  }

  void reset() {
    state = 0;
  }
}
