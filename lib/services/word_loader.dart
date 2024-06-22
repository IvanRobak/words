import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word.dart';

Future<List<Word>> loadWords() async {
  final String response = await rootBundle.loadString('assets/data/words.json');
  final List<dynamic> data = json.decode(response);
  return data
      .map((json) => Word.fromJson(json as Map<String, dynamic>))
      .toList();
}
