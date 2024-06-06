import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';

class UserExamplesStorage {
  // Метод для збереження прикладів користувача
  static Future<void> saveUserExamples(Word word) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${word.word}_userExamples', word.userExamples);
  }

  // Метод для завантаження прикладів користувача
  static Future<List<String>?> loadUserExamples(Word word) async {
    final prefs = await SharedPreferences.getInstance();
    final savedExamples = prefs.getStringList('${word.word}_userExamples');
    return savedExamples;
  }
}
