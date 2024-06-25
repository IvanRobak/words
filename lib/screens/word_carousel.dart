// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Set<int> knownWords = {};
  Set<int> learnWords = {}; // Додайте цей стан

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
    _loadButtonStates(); // Завантаження стану кнопок
  }

  Future<void> _loadButtonStates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      knownWords = (prefs.getStringList('knownWords') ?? [])
          .map((id) => int.parse(id))
          .toSet();
      learnWords = (prefs.getStringList('learnWords') ?? [])
          .map((id) => int.parse(id))
          .toSet();
    });
  }

  Future<void> _saveButtonState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'knownWords', knownWords.map((id) => id.toString()).toList());
    await prefs.setStringList(
        'learnWords', learnWords.map((id) => id.toString()).toList());
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
      learnWords.remove(wordIndex); // Видаляємо з learnWords
    });
    _saveButtonState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (_currentPageIndex < widget.words.length - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _markWordAsLearn(int wordIndex) {
    setState(() {
      learnWords.add(wordIndex);
      knownWords.remove(wordIndex); // Видаляємо з knownWords
    });
    _saveButtonState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (_currentPageIndex < widget.words.length - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    if (_currentPageIndex >= 50) {
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
    Color dotColor;
    Border border;

    if (knownWords.contains(wordIndex)) {
      dotColor = Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 89, 131, 148)
          : Theme.of(context).colorScheme.primary;
      border = _currentPageIndex % 50 == index
          ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 1)
          : Border.all(color: Colors.transparent);
    } else if (learnWords.contains(wordIndex)) {
      dotColor = Colors.purple;
      border = _currentPageIndex % 50 == index
          ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 1)
          : Border.all(color: Colors.transparent);
    } else {
      dotColor = Colors.grey;
      border = _currentPageIndex % 50 == index
          ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 1)
          : Border.all(color: Colors.transparent);
    }

    return Container(
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
        border: border,
      ),
    );
  }
}
