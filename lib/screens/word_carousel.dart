// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/widgets/word_details/word_detail.dart';

class WordCarouselScreen extends StatefulWidget {
  final List<Word> words;
  final int initialIndex;

  const WordCarouselScreen(
      {super.key, required this.words, required this.initialIndex});

  @override
  // ignore: library_private_types_in_public_api
  _WordCarouselScreenState createState() => _WordCarouselScreenState();
}

class _WordCarouselScreenState extends State<WordCarouselScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  Set<int> knownWords = {}; // Додайте цей стан

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 0.95,
    );

    _currentPageIndex = widget.initialIndex;

    _pageController.addListener(() {
      final nextPage = _pageController.page?.round();
      if (nextPage != null && nextPage != _currentPageIndex) {
        setState(() {
          _currentPageIndex = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _jumpToGroup(int groupStart) {
    _pageController
        .animateToPage(
      groupStart,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((_) {
      setState(() {
        _currentPageIndex = groupStart;
      });
    });
  }

  void _markWordAsKnown(int wordIndex) {
    setState(() {
      knownWords.add(wordIndex);
    });
    if (_currentPageIndex < widget.words.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Carousel'),
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
                    if (_currentPageIndex >= 50) {
                      int targetIndex = (_currentPageIndex ~/ 50 - 1) * 50;
                      _jumpToGroup(targetIndex);
                    } else {}
                  },
                ),
                Column(
                  children: [
                    Text(
                        '${(_currentPageIndex ~/ 50) * 50}-${((_currentPageIndex ~/ 50) + 1) * 50}'),
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
                            return buildDot(index, context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () {
                    if (_currentPageIndex < widget.words.length - 50) {
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

  Widget buildDot(int index, BuildContext context) {
    int wordIndex = (_currentPageIndex ~/ 50) * 50 + index;
    return Container(
      decoration: BoxDecoration(
        color: knownWords.contains(wordIndex)
            ? Colors.green
            : (_currentPageIndex % 50 == index ? Colors.blue : Colors.grey),
        shape: BoxShape.circle,
      ),
    );
  }
}
