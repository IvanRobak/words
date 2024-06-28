// main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/widgets/carousel_footer.dart';
import 'package:words/widgets/word_details/word_detail.dart';

class WordCarouselScreen extends ConsumerStatefulWidget {
  final List<Word> words;
  final int initialIndex;
  final bool searchForUnselectedIndex;

  const WordCarouselScreen({
    super.key,
    required this.words,
    required this.initialIndex,
    this.searchForUnselectedIndex = false,
  });

  @override
  WordCarouselScreenState createState() => WordCarouselScreenState();
}

class WordCarouselScreenState extends ConsumerState<WordCarouselScreen> {
  PageController? _pageController;
  int _currentPageIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePageController();
  }

  Future<void> _initializePageController() async {
    await Future.wait([
      ref.read(knownWordsProvider.notifier).loadKnownWords(),
      ref.read(learnWordsProvider.notifier).loadLearnWords(),
    ]);

    int initialPage = widget.searchForUnselectedIndex
        ? _findFirstUnselectedIndex()
        : widget.initialIndex;

    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.95,
    );

    setState(() {
      _currentPageIndex = initialPage;
      isLoading = false;
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
    return 0;
  }

  void _markWord(int wordIndex, bool isKnown) {
    if (isKnown) {
      ref.read(knownWordsProvider.notifier).add(wordIndex);
      ref.read(learnWordsProvider.notifier).remove(wordIndex);
    } else {
      ref.read(learnWordsProvider.notifier).add(wordIndex);
      ref.read(knownWordsProvider.notifier).remove(wordIndex);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_pageController != null &&
          _currentPageIndex < widget.words.length - 1) {
        _pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Carousel',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
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
                    onKnowPressed: () => _markWord(index, true),
                    onLearnPressed: () => _markWord(index, false),
                  ),
                ),
              );
            },
          ),
          CarouselFooter(
            currentPageIndex: _currentPageIndex,
            totalWords: widget.words.length,
            pageController: _pageController!,
            ref: ref,
          ),
        ],
      ),
    );
  }
}
