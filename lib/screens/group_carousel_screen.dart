import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/widgets/carousel_footer.dart';
import 'package:words/widgets/word_button_list.dart';
import 'package:words/widgets/word_details/word_detail.dart';

class GroupCarouselScreen extends ConsumerStatefulWidget {
  final List<Word> words;
  final int initialIndex;
  final int startIndex;
  final bool showFooter;

  const GroupCarouselScreen({
    super.key,
    required this.words,
    required this.initialIndex,
    required this.startIndex,
    this.showFooter = true,
  });

  @override
  GroupCarouselScreenState createState() => GroupCarouselScreenState();
}

class GroupCarouselScreenState extends ConsumerState<GroupCarouselScreen> {
  PageController? _pageController;
  int _currentPageIndex = 0;
  bool isLoading = true;
  bool isGridMode = false;

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

  void _markWord(int wordIndex, bool isKnown) {
    final wordId = widget.words[wordIndex].id;
    if (isKnown) {
      ref.read(knownWordsProvider.notifier).add(wordId);
      ref.read(learnWordsProvider.notifier).remove(wordId);
    } else {
      ref.read(learnWordsProvider.notifier).add(wordId);
      ref.read(knownWordsProvider.notifier).remove(wordId);
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
                      onKnowPressed: () => _markWord(index, true),
                      onLearnPressed: () => _markWord(index, false),
                    ),
                  ),
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: WordButtonList(
                words: widget.words,
                columns: 3,
                startIndex: widget.startIndex,
              ),
            ),
          if (widget.showFooter)
            CarouselFooter(
              currentPageIndex: _currentPageIndex,
              totalWords: widget.words.length,
              pageController: _pageController!,
              startIndex: widget.startIndex, 
            ),
        ],
      ),
    );
  }
}
