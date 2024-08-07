import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/services/firebase_image_service.dart';
import 'package:words/services/word_loader.dart';
import 'package:words/widgets/write_word_game_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WriteWordScreen extends ConsumerStatefulWidget {
  final Word word;

  const WriteWordScreen({super.key, required this.word});

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
      });
    } else {
      setState(() {
        feedback = 'Try again!';
        showFeedback = true;
      });
    }

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showFeedback = false;
      });
    });
  }

  void nextWord() {
    if (currentIndex < learnWords.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {}
  }

  void toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Write the Word',
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
                        onHint: toggleHint,
                        showHint: showHint);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
