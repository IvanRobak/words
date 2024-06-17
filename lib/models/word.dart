class Word {
  final String word;
  final String description;
  final int id;
  final String example;
  String? translation; // Робимо властивість опціональною
  final String imageUrl; // Додаємо поле для URL зображення
  List<String> userExamples;
  String? selectedFolder;

  Word({
    required this.word,
    required this.description,
    required this.id,
    required this.example,
    this.translation, // Ініціалізуємо переклад як опціональний
    required this.imageUrl, // Ініціалізуємо URL зображення
    required this.userExamples,
    this.selectedFolder,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      description: json['description'],
      id: json['id'],
      example: json['example'],
      translation:
          json['translation'], // Ініціалізуємо переклад як опціональний
      imageUrl: json['imageUrl'], // Ініціалізуємо URL зображення
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
      'translation': translation,
      'imageUrl': imageUrl, // Додаємо URL зображення до JSON
      'userExamples': userExamples,
      'selectedFolder': selectedFolder,
    };
  }
}
