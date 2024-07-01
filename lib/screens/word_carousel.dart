import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/widgets/word_button_list.dart';
import 'package:words/widgets/word_details/word_detail.dart';

class WordCarouselScreen extends ConsumerStatefulWidget {
  final List<Word> words;
  final int initialIndex;

  const WordCarouselScreen({
    super.key,
    required this.words,
    required this.initialIndex,
  });

  @override
  WordCarouselScreenState createState() => WordCarouselScreenState();
}

class WordCarouselScreenState extends ConsumerState<WordCarouselScreen> {
  PageController? _pageController;
  int _currentPageIndex = 0;
  bool isLoading = true;
  bool isGridMode = false; // Додаємо стан для перемикання режиму
  bool isMarkingWord = false;

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

    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 0.95,
    );

    setState(() {
      _currentPageIndex = widget.initialIndex;
      isLoading = false;
    });

    _pageController!.addListener(() {
      final nextPage = _pageController!.page?.round();
      if (nextPage != null && nextPage != _currentPageIndex) {
        setState(() {
          _currentPageIndex = nextPage;
        });
        print(
            'Page controller listener: Current page index is $_currentPageIndex');
      }
    });
  }

  void _toggleViewMode() {
    setState(() {
      isGridMode = !isGridMode;
    });
  }

  void _markWord(int wordId, bool isKnown) {
    if (isMarkingWord) return;
    isMarkingWord = true;

    print('Marking word $wordId as ${isKnown ? 'known' : 'learning'}');

    if (isKnown) {
      print('Before adding to known words: ${ref.read(knownWordsProvider)}');
      ref.read(knownWordsProvider.notifier).add(wordId);
      print('After adding to known words: ${ref.read(knownWordsProvider)}');
      print(
          'Before removing from learn words: ${ref.read(learnWordsProvider)}');
      ref.read(learnWordsProvider.notifier).remove(wordId);
      print('After removing from learn words: ${ref.read(learnWordsProvider)}');
    } else {
      print('Before adding to learn words: ${ref.read(learnWordsProvider)}');
      ref.read(learnWordsProvider.notifier).add(wordId);
      print('After adding to learn words: ${ref.read(learnWordsProvider)}');
      print(
          'Before removing from known words: ${ref.read(knownWordsProvider)}');
      ref.read(knownWordsProvider.notifier).remove(wordId);
      print('After removing from known words: ${ref.read(knownWordsProvider)}');
    }

    print('Known words after marking: ${ref.read(knownWordsProvider)}');
    print('Learn words after marking: ${ref.read(learnWordsProvider)}');

    setState(() {
      _currentPageIndex += 1;
      print('Set state: Current page index $_currentPageIndex');
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_pageController != null &&
          _currentPageIndex < widget.words.length - 1) {
        _pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      print('Current page index after marking: $_currentPageIndex');
      isMarkingWord = false;
    });
  }

  Widget buildDot(int index, int currentPageIndex, Set<int> knownWords,
      Set<int> learnWords, BuildContext context) {
    int wordIndex = (currentPageIndex ~/ 50) * 50 + index + 1; // Додаємо 1 тут
    Color dotColor;
    Border border;

    if (knownWords.contains(wordIndex)) {
      dotColor = Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 89, 131, 148)
          : Theme.of(context).colorScheme.primary;
      border = Border.all(
        color: currentPageIndex % 50 == index
            ? Theme.of(context).colorScheme.secondary
            : Colors.transparent,
        width: 1,
      );
    } else if (learnWords.contains(wordIndex)) {
      dotColor = Colors.purple;
      border = Border.all(
        color: currentPageIndex % 50 == index
            ? Theme.of(context).colorScheme.secondary
            : Colors.transparent,
        width: 1,
      );
    } else {
      dotColor = Colors.grey;
      border = Border.all(
        color: currentPageIndex % 50 == index
            ? Theme.of(context).colorScheme.secondary
            : Colors.transparent,
        width: 1,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
        border: border,
      ),
      width: 20,
      height: 20,
    );
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

    final knownWords = ref.watch(knownWordsProvider);
    final learnWords = ref.watch(learnWordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Carousel',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        actions: [
          IconButton(
            icon: Icon(isGridMode ? Icons.view_carousel : Icons.grid_view),
            onPressed: _toggleViewMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!isGridMode)
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
                      onKnowPressed: () => _markWord(word.id, true),
                      onLearnPressed: () => _markWord(word.id, false),
                    ),
                  ),
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: WordButtonList(
                words: widget.words.sublist(0, 50), // Відображаємо лише 50
                columns: 3,
              ),
            ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '${(_currentPageIndex ~/ 50) * 50}-${((_currentPageIndex ~/ 50) + 1) * 50}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
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
                          knownWords,
                          learnWords,
                          context,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
