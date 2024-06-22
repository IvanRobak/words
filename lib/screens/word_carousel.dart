import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/widgets/word_details/word_detail.dart';

class WordCarouselScreen extends StatefulWidget {
  final List<Word> words;
  final int initialIndex;

  const WordCarouselScreen(
      {super.key, required this.words, required this.initialIndex});

  @override
  _WordCarouselScreenState createState() => _WordCarouselScreenState();
}

class _WordCarouselScreenState extends State<WordCarouselScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;

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
                  child: WordDetail(word: word),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 80,
                width: 220,
                child: GridView.builder(
                  itemCount: 50, // П'ять рядів по десять квадратів
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10, // 10 квадратів в рядку
                    mainAxisSpacing: 2, // Відстань між рядками
                    crossAxisSpacing: 1, // Відстань між стовпцями
                    childAspectRatio: 1.6, // Співвідношення сторін елементів
                  ),
                  itemBuilder: (context, index) {
                    return buildDot(index, context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      // height: 5,
      // width: 5,
      decoration: BoxDecoration(
        color: _currentPageIndex == index ? Colors.blue : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
