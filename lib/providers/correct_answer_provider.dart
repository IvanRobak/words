import 'package:flutter_riverpod/flutter_riverpod.dart';

// Створення StateNotifier для управління станом прогресу
class ProgressNotifier extends StateNotifier<double> {
  ProgressNotifier() : super(0.0);

  void incrementProgress() {
    if (state < 1.0) {
      state += 0.1;
      print('Progress incremented: $state');
    } else {
      print('Progress is already at maximum.');
    }
  }

  void resetProgress() {
    state = 0.0;
    print('Progress reset'); // Лог скидання прогресу
  }
}

// Провайдер для доступу до ProgressNotifier
final progressProvider = StateNotifierProvider<ProgressNotifier, double>((ref) {
  return ProgressNotifier();
});
