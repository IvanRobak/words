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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction:
          0.95, // Змінити частину екрана, яку займає кожна сторінка
    );
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
                  height: MediaQuery.of(context).size.height *
                      0.7, // Обмеження висоти
                  child: WordDetail(word: word),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (_pageController.page! > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  if (_pageController.page! < widget.words.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
