class Word {
  final String word;
  final int id;
  final String example;
  String? translation;
  final String imageUrl;
  String? selectedFolder;

  Word({
    required this.word,
    required this.id,
    required this.example,
    this.translation,
    required this.imageUrl,
    this.selectedFolder,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      id: json['id'],
      example: json['example'],
      translation: json['translation'],
      imageUrl: json['imageUrl'],
      selectedFolder: json['selectedFolder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'id': id,
      'example': example,
      'translation': translation,
      'imageUrl': imageUrl,
      'selectedFolder': selectedFolder,
    };
  }
}
