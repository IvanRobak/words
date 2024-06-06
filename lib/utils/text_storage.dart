import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';

class TextStorage {
  static Future<void> saveText(Word word, String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(word.word, text);
    await prefs.setStringList('${word.word}_userExamples', word.userExamples);
  }

  static Future<Map<String, dynamic>> loadText(Word word) async {
    final prefs = await SharedPreferences.getInstance();
    final savedText = prefs.getString(word.word);
    final savedExamples = prefs.getStringList('${word.word}_userExamples');

    return {
      'savedText': savedText,
      'savedExamples': savedExamples,
    };
  }
}
