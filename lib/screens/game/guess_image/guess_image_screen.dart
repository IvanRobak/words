import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/screens/game/guess_image/image_game_summery.dart';
import 'package:words/services/firebase_image_service.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/services/word_loader.dart';
import 'package:words/widgets/game/image_game_card.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuessImageScreen extends ConsumerStatefulWidget {
  const GuessImageScreen({super.key});

  @override
  GuessImageScreenState createState() => GuessImageScreenState();
}

class GuessImageScreenState extends ConsumerState<GuessImageScreen> {
  late Future<void> _initialLoadFuture;
  late List<Word> learnWords;
  late List<Word> allWords;
  Map<int, String> imageUrls = {};
  Map<int, bool> answerResults = {};
  int currentIndex = 0;
  bool showExample = false;
  String? selectedAnswer;
  List<String> currentOptions = [];
  bool soundEnabled = true;
  final ConfettiController _confettiController = ConfettiController();

  final FirebaseImageService firebaseImageService = FirebaseImageService();
  final PageController _pageController = PageController(viewportFraction: 0.97);
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initialLoadFuture = _initializeData();
    _loadSoundSetting();
  }

  Future<void> _loadSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
    });
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

      await _loadImagesForCurrentAndNextWord();
    } catch (error) {
      // Свідомо ігноруємо помилки, оскільки вони не критичні для роботи додатка
    }
  }

  Future<void> _loadImagesForCurrentWord() async {
    if (currentIndex < learnWords.length) {
      final word = learnWords[currentIndex];
      imageUrls[word.id] =
          await firebaseImageService.fetchImageUrl(word.imageUrl);

      final options = await _generateImageOptions(word);

      setState(() {
        currentOptions = options;
      });
    }
  }

  Future<List<String>> _generateImageOptions(Word word) async {
    final int wordIndex = allWords.indexWhere((w) => w.id == word.id);
    List<Word> nearbyWords = [];

    for (int i = -5; i <= 5; i++) {
      if (i != 0 && wordIndex + i >= 0 && wordIndex + i < allWords.length) {
        nearbyWords.add(allWords[wordIndex + i]);
      }
    }

    nearbyWords.shuffle();

    // Завантаження URL-адрес для варіантів відповіді
    List<Future<String>> optionFutures = nearbyWords.take(3).map((w) async {
      final url = await firebaseImageService.fetchImageUrl(w.imageUrl);
      imageUrls[w.id] = url;
      return url;
    }).toList();

    // Очікування завершення всіх асинхронних запитів
    List<String> options = await Future.wait(optionFutures);

    // Додаємо правильну відповідь
    options.add(imageUrls[word.id]!);
    options.shuffle(); // Перемішуємо варіанти відповіді

    return options;
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Well done, great job!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Summary'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImageGameSummaryScreen(
                    words: learnWords,
                    answerResults: answerResults,
                  ),
                ));
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkImageAnswer(String imageUrl, Word word) async {
    setState(() {
      selectedAnswer = imageUrl;
      answerResults[word.id] =
          (imageUrl == imageUrls[word.id]); // Зберігаємо результат відповіді
    });

    await _audioPlayer.stop();

    if (imageUrl == imageUrls[word.id]) {
      if (soundEnabled) {
        await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
      }
    } else {
      if (soundEnabled) {
        await _audioPlayer.play(AssetSource('sounds/incorrect.mp3'));
      }
    }

    // Переходимо на наступну картку після короткої затримки
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        selectedAnswer = null;
        currentIndex++;
        if (currentIndex < learnWords.length) {
          _loadImagesForCurrentWord(); // Завантаження нових зображень для наступного слова
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        } else {
          _confettiController.play();
          _showCompletionDialog();
        }
      });
    });
  }

  void _toggleExample() {
    setState(() {
      showExample = !showExample;
    });
  }

  Future<void> _loadImagesForCurrentAndNextWord() async {
    if (currentIndex < learnWords.length) {
      // Завантажуємо зображення для поточної картки
      final currentWord = learnWords[currentIndex];
      imageUrls[currentWord.id] =
          await firebaseImageService.fetchImageUrl(currentWord.imageUrl);

      // Завантажуємо варіанти для поточної картки
      currentOptions = await _generateImageOptions(currentWord);

      // Якщо є наступна картка, завантажуємо зображення і для неї
      if (currentIndex + 1 < learnWords.length) {
        final nextWord = learnWords[currentIndex + 1];
        imageUrls[nextWord.id] =
            await firebaseImageService.fetchImageUrl(nextWord.imageUrl);
        // Ми можемо заздалегідь завантажити варіанти для наступної картки, якщо це потрібно
        await _generateImageOptions(nextWord);
      }

      setState(() {
        // Оновлюємо стан тільки після завершення завантаження всіх зображень
      });
    }
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
        title: const Text(
          'Guess the Image',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
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
              onPageChanged: (index) async {
                setState(() {
                  currentIndex = index;
                  showExample = false;
                  selectedAnswer = null;
                });

                await _loadImagesForCurrentAndNextWord(); // Завантажуємо зображення для поточної та наступної картки
              },
              itemBuilder: (context, index) {
                final word = learnWords[index];
                final correctImageUrl = imageUrls[word.id];

                return ImageGameCard(
                  word: word,
                  showExample: showExample,
                  onToggleExample: _toggleExample,
                  onOptionSelected: (option) => _checkImageAnswer(option, word),
                  options: currentOptions,
                  selectedAnswer: selectedAnswer,
                  correctImageUrl: correctImageUrl ??
                      'https://example.com/placeholder.jpg', // Placeholder image URL
                );
              },
            );
          }
        },
      ),
    );
  }
}
