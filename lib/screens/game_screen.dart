import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/services/firebase_image_service.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late Word currentWord;
  late List<String> options;
  bool? isCorrect;
  String? imageUrl;
  bool isLoading = true;

  final FirebaseImageService firebaseImageService = FirebaseImageService();

  @override
  void initState() {
    super.initState();
    _loadWord();
  }

  Future<void> _loadWord() async {
    // Для демонстрації завантажуємо випадкове слово
    currentWord = Word(
      id: 1,
      word: 'to',
      example: 'I am going to school.',
      imageUrl: 'gs://words-385e3.appspot.com/to.webp',
    );

    // Завантаження зображення з Firebase
    imageUrl = await firebaseImageService.fetchImageUrl(currentWord.imageUrl);

    options = _generateOptions();
    setState(() {
      isLoading = false;
    });
  }

  List<String> _generateOptions() {
    // Для демонстрації просто повертаємо список варіантів
    return ['to', 'to', 'to', 'to'];
  }

  void _checkAnswer(String answer) {
    setState(() {
      isCorrect = answer == currentWord.word;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Guess the Word',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Theme.of(context).colorScheme.onSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (imageUrl != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Image.network(
                              imageUrl!,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 4,
                            children: options.map((option) {
                              return ElevatedButton(
                                onPressed: () => _checkAnswer(option),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isCorrect == null
                                      ? Theme.of(context).colorScheme.surface
                                      : (option == currentWord.word
                                          ? Colors.green
                                          : Colors.red),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        // const SizedBox(height: 20),
                        if (isCorrect != null)
                          Text(
                            isCorrect! ? 'Correct!' : 'Wrong! Try Again!',
                            style: TextStyle(
                              color: isCorrect! ? Colors.green : Colors.red,
                              fontSize: 24,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
