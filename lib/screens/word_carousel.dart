// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/widgets/dot_builder.dart';
import 'package:words/widgets/word_details/word_detail.dart';

class WordCarouselScreen extends ConsumerStatefulWidget {
  final List<Word> words;
  final int initialIndex;

  const WordCarouselScreen(
      {super.key, required this.words, required this.initialIndex});

  @override
  // ignore: library_private_types_in_public_api
  _WordCarouselScreenState createState() => _WordCarouselScreenState();
}

class _WordCarouselScreenState extends ConsumerState<WordCarouselScreen> {
  PageController? _pageController;
  int _currentPageIndex = 0;
  bool isLoading = true; // Додаємо цей стан

  @override
  void initState() {
    super.initState();
    _initializePageController();
  }

  Future<void> _initializePageController() async {
    await ref.read(knownWordsProvider.notifier).loadKnownWords();
    await ref.read(learnWordsProvider.notifier).loadLearnWords();
    int firstUnselectedIndex = _findFirstUnselectedIndex();
    _pageController = PageController(
      initialPage: firstUnselectedIndex,
      viewportFraction: 0.95,
    );

    setState(() {
      _currentPageIndex = firstUnselectedIndex;
      isLoading = false; // Завантаження завершено
    });

    _pageController!.addListener(() {
      final nextPage = _pageController!.page?.round();
      if (nextPage != null && nextPage != _currentPageIndex) {
        setState(() {
          _currentPageIndex = nextPage;
        });
      }
    });
  }

  int _findFirstUnselectedIndex() {
    final knownWords = ref.read(knownWordsProvider);
    final learnWords = ref.read(learnWordsProvider);
    for (int i = 0; i < widget.words.length; i++) {
      if (!knownWords.contains(i) && !learnWords.contains(i)) {
        return i;
      }
    }
    return 0; // Якщо всі слова обрані, повертаємо 0
  }

  int _findFirstUnselectedInRange(int start, int end) {
    final knownWords = ref.read(knownWordsProvider);
    final learnWords = ref.read(learnWordsProvider);
    for (int i = start; i < end; i++) {
      if (!knownWords.contains(i) && !learnWords.contains(i)) {
        return i;
      }
    }
    return start; // Якщо всі слова обрані, повертаємо початок діапазону
  }

  void _jumpToGroup(int groupStart) {
    int groupEnd = groupStart + 50;
    int targetIndex = _findFirstUnselectedInRange(groupStart, groupEnd);
    if (_pageController != null) {
      _pageController!
          .animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        setState(() {
          _currentPageIndex = targetIndex;
        });
      });
    } else {}
  }

  void _markWordAsKnown(int wordIndex) {
    ref.read(knownWordsProvider.notifier).add(wordIndex);
    ref.read(learnWordsProvider.notifier).remove(wordIndex);
    Future.delayed(Duration(milliseconds: 500), () {
      if (_pageController != null &&
          _currentPageIndex < widget.words.length - 1) {
        _pageController!.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {}
    });
  }

  void _markWordAsLearn(int wordIndex) {
    ref.read(learnWordsProvider.notifier).add(wordIndex);
    ref.read(knownWordsProvider.notifier).remove(wordIndex);
    Future.delayed(Duration(milliseconds: 500), () {
      if (_pageController != null &&
          _currentPageIndex < widget.words.length - 1) {
        _pageController!.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {}
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Якщо стан завантажується, показуємо індикатор завантаження
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Word Carousel',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Carousel',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        iconTheme: IconThemeData(
          color: Theme.of(context)
              .colorScheme
              .onSecondary, // Задаємо колір для значків
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.words.length,
            itemBuilder: (context, index) {
              final word = widget.words[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: WordDetail(
                    word: word,
                    onKnowPressed: () => _markWordAsKnown(index),
                    onLearnPressed: () => _markWordAsLearn(index),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: () {
                    if (_pageController != null && _currentPageIndex >= 50) {
                      int targetIndex = (_currentPageIndex ~/ 50 - 1) * 50;
                      _jumpToGroup(targetIndex);
                    } else {}
                  },
                ),
                Column(
                  children: [
                    Text(
                        '${(_currentPageIndex ~/ 50) * 50}-${((_currentPageIndex ~/ 50) + 1) * 50}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary)),
                    Center(
                      child: SizedBox(
                        height: 80,
                        width: 220,
                        child: GridView.builder(
                          itemCount: 50,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 10,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 1,
                            childAspectRatio: 1.6,
                          ),
                          itemBuilder: (context, index) {
                            return buildDot(
                                index,
                                _currentPageIndex,
                                ref.watch(knownWordsProvider),
                                ref.watch(learnWordsProvider),
                                context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () {
                    if (_pageController != null &&
                        _currentPageIndex < widget.words.length - 1) {
                      int targetIndex = (_currentPageIndex ~/ 50 + 1) * 50;
                      _jumpToGroup(targetIndex);
                    } else {}
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
