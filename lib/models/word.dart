class Word {
  final String word;
  final int id;
  final String example;
  String? translation; // Робимо властивість опціональною
  final String imageUrl; // Додаємо поле для URL зображення
  String? selectedFolder;

  Word({
    required this.word,
    required this.id,
    required this.example,
    this.translation, // Ініціалізуємо переклад як опціональний
    required this.imageUrl, // Ініціалізуємо URL зображення
    this.selectedFolder,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      id: json['id'],
      example: json['example'],
      translation:
          json['translation'], // Ініціалізуємо переклад як опціональний
      imageUrl: json['imageUrl'], // Ініціалізуємо URL зображення
      selectedFolder: json['selectedFolder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'id': id,
      'example': example,
      'translation': translation,
      'imageUrl': imageUrl, // Додаємо URL зображення до JSON
      'selectedFolder': selectedFolder,
    };
  }
}
