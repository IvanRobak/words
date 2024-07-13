import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words/models/word.dart';
import 'package:words/services/firebase_image_service.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/services/word_loader.dart';
import 'package:words/widgets/confetti.dart';
import 'package:words/widgets/word_game_card.dart';

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
  bool soundEnabled = true;
  final ConfettiController _confettiController = ConfettiController();

  final FirebaseImageService firebaseImageService = FirebaseImageService();
  final PageController _pageController = PageController(viewportFraction: 0.97);
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initialLoadFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await ref.read(learnWordsProvider.notifier).loadLearnWords();
      final learnWordIds = ref.read(learnWordsProvider);

      final prefs = await SharedPreferences.getInstance();
      soundEnabled = prefs.getBool('soundEnabled') ?? true;

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

  Future<void> _checkAnswer(String answer, Word word) async {
    setState(() {
      selectedAnswer = answer;
    });

    if (answer == word.word) {
      await _audioPlayer.stop(); // Зупиняємо попередній звук, якщо він ще грає
      if (soundEnabled) {
        await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
      }

      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          selectedAnswer = null;
          currentIndex++;
          if (currentIndex < learnWords.length) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          } else {
            _confettiController.play();
          }
        });
      });
    } else {
      await _audioPlayer.stop(); // Зупиняємо попередній звук, якщо він ще грає
      if (soundEnabled) {
        await _audioPlayer.play(AssetSource('sounds/incorrect.mp3'));
      }
    }
  }

  void _toggleExample() {
    setState(() {
      showExample = !showExample;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
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
      body: Stack(
        children: [
          FutureBuilder<void>(
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

                    return WordGameCard(
                      word: word,
                      imageUrl: imageUrl,
                      showExample: showExample,
                      onToggleExample: _toggleExample,
                      onOptionSelected: (option) => _checkAnswer(option, word),
                      options: options,
                      selectedAnswer: selectedAnswer,
                    );
                  },
                );
              }
            },
          ),
          ConfettiOverlay(confettiController: _confettiController),
        ],
      ),
    );
  }
}
