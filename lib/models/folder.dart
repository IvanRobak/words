import 'package:words/models/word.dart';
import 'package:flutter/material.dart';

class Folder {
  final String name;
  final List<Word> words;
  Color color;

  Folder({
    required this.name,
    required this.words,
    required this.color,
  });

  void addWord(Word word) {
    words.add(word);
  }

  void removeWord(Word word) {
    words.remove(word);
  }
}
