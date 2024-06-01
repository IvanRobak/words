import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word.dart';

Future<List<Word>> loadWords() async {
  final String response = await rootBundle.loadString('assets/data/words.json');
  final data = await json.decode(response) as List;
  return data.map((json) => Word.fromJson(json)).toList();
}
