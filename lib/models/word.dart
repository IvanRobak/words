class Word {
  final String word;
  final String description;
  final int id;
  final String example;
  final String translation; // Додаємо властивість для перекладу
  List<String> userExamples;
  String? selectedFolder;

  Word({
    required this.word,
    required this.description,
    required this.id,
    required this.example,
    required this.translation, // Ініціалізуємо переклад
    required this.userExamples,
    this.selectedFolder,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      description: json['description'],
      id: json['id'],
      example: json['example'],
      translation: json['translation'], // Ініціалізуємо переклад
      userExamples: List<String>.from(json['userExamples'] ?? []),
      selectedFolder: json['selectedFolder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'description': description,
      'id': id,
      'example': example,
      'userExamples': userExamples,
      'translation': translation,
      'selectedFolder': selectedFolder,
    };
  }
}
