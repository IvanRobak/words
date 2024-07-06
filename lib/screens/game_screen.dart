import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/services/firebase_image_service.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/services/word_loader.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends ConsumerState<GameScreen> {
  late List<Word> learnWords;
  late List<Word> allWords;
  Map<int, String> imageUrls = {};
  int currentIndex = 0;
  bool isLoading = true;

  final FirebaseImageService firebaseImageService = FirebaseImageService();

  @override
  void initState() {
    super.initState();
    _loadLearnWords();
  }

  Future<void> _loadLearnWords() async {
    final learnWordIds = ref.read(learnWordsProvider);
    allWords = await loadWords();
    learnWords =
        allWords.where((word) => learnWordIds.contains(word.id)).toList();

    for (var word in learnWords) {
      final url = await firebaseImageService.fetchImageUrl(word.imageUrl);
      imageUrls[word.id] = url;
    }

    setState(() {
      isLoading = false;
    });
  }

  List<String> _generateOptions(Word word) {
    final int wordIndex = allWords.indexWhere((w) => w.id == word.id);
    List<Word> nearbyWords = [];

    for (int i = -5; i <= 5; i++) {
      if (i != 0 && wordIndex + i >= 0 && wordIndex + i < allWords.length) {
        nearbyWords.add(allWords[wordIndex + i]);
      }
    }

    nearbyWords.shuffle();
    List<String> options = nearbyWords.take(3).map((w) => w.word).toList();
    options.add(word.word);
    options.shuffle();

    return options;
  }

  void _checkAnswer(String answer, Word word) {
    // setState(() {
    //   bool isCorrect = answer == word.word;
    //   // логіку для обробки правильної або неправильної відповіді
    // });
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
          : PageView.builder(
              controller: PageController(viewportFraction: 0.97),
              itemCount: learnWords.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final word = learnWords[index];
                final options = _generateOptions(word);
                final imageUrl = imageUrls[word.id];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 250),
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
                                  imageUrl,
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
                                    onPressed: () => _checkAnswer(option, word),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
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
                            const SizedBox(height: 20),
                            // Додати текст для відображення правильної або неправильної відповіді, якщо потрібно
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
