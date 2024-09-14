import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/providers/write_progress_provider.dart';
import 'package:words/screens/game/write_word/write_game_summary.dart';
import 'package:words/services/firebase_image_service.dart';
import 'package:words/services/word_loader.dart';
import 'package:words/widgets/confetti.dart';
import 'package:words/widgets/game/write_word_game_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WriteWordScreen extends ConsumerStatefulWidget {
  const WriteWordScreen({super.key});

  @override
  WriteWordScreenState createState() => WriteWordScreenState();
}

class WriteWordScreenState extends ConsumerState<WriteWordScreen> {
  final TextEditingController _controller = TextEditingController();
  late Future<void> _initialLoadFuture;
  late List<Word> learnWords;
  late List<Word> allWords;
  Map<int, String> imageUrls = {};
  int currentIndex = 0;
  bool showExample = false;
  bool showFeedback = false;
  bool showHint = false;
  String? feedback;
  bool showSubmitButton = true;
  final ConfettiController _confettiController = ConfettiController();

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
      }));
    } catch (error) {
      // Handle error
    }
  }

  void toggleExample() {
    setState(() {
      showExample = !showExample;
    });
  }

  void _checkAnswer() {
    if (_controller.text.trim().toLowerCase() ==
        learnWords[currentIndex].word.toLowerCase()) {
      setState(() {
        feedback = 'Correct!';
        showFeedback = true;
        showSubmitButton = false;

        ref
            .read(writeWordProgressProvider.notifier)
            .incrementProgress(learnWords[currentIndex].id);
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          showFeedback = false;
          feedback = null;

          // Перевіряємо, чи всі слова пройдені
          if (currentIndex < learnWords.length - 1) {
            currentIndex++;
            _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          } else {
            _confettiController.play();
            _showCompletionDialog(); // Викликаємо діалог після завершення гри
          }
        });
      });
    } else {
      setState(() {
        feedback = 'Try again!';
        showFeedback = true;
        showSubmitButton = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          showFeedback = false;
          feedback = null;
          showSubmitButton = true;
        });
      });
    }
  }

  void nextWord() {
    if (currentIndex < learnWords.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      _confettiController.play();
      _showCompletionDialog(); // Викликаємо діалог після завершення гри
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'All words completed!',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Summary'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WriteGameSummaryScreen(
                    words: learnWords,
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

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text(
          'Write the Word',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
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
                      feedback = null;
                      _controller.clear();
                    });
                  },
                  itemBuilder: (context, index) {
                    final word = learnWords[index];
                    final imageUrl = imageUrls[word.id];

                    return WriteWordGameCard(
                        word: word,
                        imageUrl: imageUrl,
                        showExample: showExample,
                        showFeedback: showFeedback,
                        onToggleExample: toggleExample,
                        controller: _controller,
                        onSubmit: _checkAnswer,
                        feedback: feedback,
                        onNext: nextWord,
                        showSubmitButton: showSubmitButton);
                  },
                );
              }
            },
          ),
          ConfettiOverlay(confettiController: _confettiController)
        ],
      ),
    );
  }
}
