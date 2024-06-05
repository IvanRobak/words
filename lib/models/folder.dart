import 'package:words/models/word.dart';

class Folder {
  late final String name;
  final List<Word> words;

  Folder({
    required this.name,
    required this.words,
  });
}
