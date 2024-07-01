import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/widgets/word_details/word_detail.dart';
import 'package:words/widgets/word_button_list.dart';
import 'package:words/widgets/dot_builder.dart';

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
  bool isGridMode = false;
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

    if (isKnown) {
      ref.read(knownWordsProvider.notifier).add(wordId);
      ref.read(learnWordsProvider.notifier).remove(wordId);
    } else {
      ref.read(learnWordsProvider.notifier).add(wordId);
      ref.read(knownWordsProvider.notifier).remove(wordId);
    }

    setState(() {
      _currentPageIndex += 1;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_pageController != null &&
          _currentPageIndex < widget.words.length - 1) {
        _pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      isMarkingWord = false;
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

    final knownWords = ref.watch(knownWordsProvider);
    final learnWords = ref.watch(learnWordsProvider);

    int groupStartIndex = (widget.initialIndex ~/ 50) * 50;
    int groupEndIndex = groupStartIndex + 50;
    List<Word> groupWords = widget.words.sublist(
      groupStartIndex,
      groupEndIndex > widget.words.length ? widget.words.length : groupEndIndex,
    );

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
                words: groupWords,
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
