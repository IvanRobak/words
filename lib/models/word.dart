class Word {
  final String word;
  final String description;
  final int id;
  final String example;
  List<String> userExamples;

  Word({
    required this.word,
    required this.description,
    required this.id,
    required this.example,
    this.userExamples = const [],
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      description: json['description'],
      id: json['id'],
      example: json['example'],
      userExamples: json['userExamples'] != null
          ? List<String>.from(json['userExamples'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'description': description,
      'id': id,
      'example': example,
      'userExamples': userExamples,
    };
  }
}
