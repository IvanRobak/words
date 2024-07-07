import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/services/firebase_image_service.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/services/word_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends ConsumerState<GameScreen> {
  late Future<void> _initialLoadFuture;
  late List<Word> learnWords;
  late List<Word> allWords;
  Map<int, String> imageUrls = {};
  Map<int, List<String>> optionsMap = {};
  int currentIndex = 0;
  bool showExample = false;
  String? selectedAnswer;

  final FirebaseImageService firebaseImageService = FirebaseImageService();
  final PageController _pageController = PageController(viewportFraction: 0.97);

  @override
  void initState() {
    super.initState();
    _initialLoadFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await ref.read(learnWordsProvider.notifier).loadLearnWords();
      final learnWordIds = ref.read(learnWordsProvider);

      allWords = await loadWords();

      learnWords =
          allWords.where((word) => learnWordIds.contains(word.id)).toList();

      await Future.wait(learnWords.map((word) async {
        final url = await firebaseImageService.fetchImageUrl(word.imageUrl);
        imageUrls[word.id] = url;
        optionsMap[word.id] = _generateOptions(word);
      }));
    } catch (error) {
      // error
    }
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
    setState(() {
      selectedAnswer = answer;
    });

    if (answer == word.word) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          selectedAnswer = null;
          currentIndex++;
          if (currentIndex < learnWords.length) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          } else {
            // Можна додати обробку, якщо всі слова вивчені
          }
        });
      });
    }
  }

  void _toggleExample() {
    setState(() {
      showExample = !showExample;
    });
  }

  String _getExampleWithPlaceholder(Word word) {
    final wordPattern =
        RegExp(r'\b' + RegExp.escape(word.word) + r'\b', caseSensitive: false);
    return word.example.replaceAll(wordPattern, '...');
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
      body: FutureBuilder<void>(
        future: _initialLoadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (learnWords.isEmpty) {
            return const Center(child: Text('No words to learn'));
          } else {
            return PageView.builder(
              controller: _pageController,
              itemCount: learnWords.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                  showExample = false;
                  selectedAnswer = null;
                });
              },
              itemBuilder: (context, index) {
                final word = learnWords[index];
                final options = optionsMap[word.id]!;
                final imageUrl = imageUrls[word.id];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 200),
                  child: Card(
                    color: Theme.of(context).colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (imageUrl != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: Center(
                            child: showExample
                                ? GestureDetector(
                                    onTap: _toggleExample,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        _getExampleWithPlaceholder(word),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.lightbulb_outline),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    onPressed: _toggleExample,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            childAspectRatio: 4,
                            physics: const NeverScrollableScrollPhysics(),
                            children: options.map((option) {
                              final isCorrect = selectedAnswer == option &&
                                  option == word.word;
                              final isWrong = selectedAnswer == option &&
                                  option != word.word;

                              return ElevatedButton(
                                onPressed: () => _checkAnswer(option, word),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isCorrect
                                      ? Colors.green
                                      : isWrong
                                          ? Colors.red
                                          : Theme.of(context)
                                              .colorScheme
                                              .inverseSurface,
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
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
