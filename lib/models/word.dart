class Word {
  final String word;
  final String description;
  final int id;

  Word({
    required this.word,
    required this.description,
    required this.id,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      description: json['description'],
      id: json['id'],
    );
  }
}
