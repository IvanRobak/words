class Word {
  final String word;
  final String description;
  final int id;
  final String example;

  Word(
      {required this.word,
      required this.description,
      required this.id,
      required this.example});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
        word: json['word'],
        description: json['description'],
        id: json['id'],
        example: json['example']);
  }
}
