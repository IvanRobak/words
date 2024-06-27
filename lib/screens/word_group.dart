import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/screens/word_carousel.dart';
import 'package:words/services/word_loader.dart';
import 'package:words/widgets/dot_builder.dart';

class WordGroupScreen extends ConsumerStatefulWidget {
  const WordGroupScreen({super.key});

  @override
  ConsumerState<WordGroupScreen> createState() => _WordGroupScreenState();
}

class _WordGroupScreenState extends ConsumerState<WordGroupScreen> {
  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await loadWords();
    ref.read(wordFilterProvider.notifier).setWords(words);
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(wordFilterProvider);
    final knownWords = ref.watch(knownWordsProvider);
    final learnWords = ref.watch(learnWordsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('All words',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: (words.length / 50).ceil(),
          itemBuilder: (context, index) {
            final start = index * 50;
            final end = start + 50;
            words.sublist(start, end > words.length ? words.length : end);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordCarouselScreen(
                      words: words,
                      initialIndex: start,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        alignment: Alignment.center,
                        child: Text(
                          '$start - $end',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 50,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 10, // 10 кружечків в рядку
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 8.0,
                            childAspectRatio: 1, // Співвідношення сторін 1:1
                          ),
                          itemBuilder: (context, dotIndex) {
                            return SizedBox(
                              // width: 10, // Збільшуємо розмір кружечків
                              // height: 10,
                              child: buildDot(
                                dotIndex,
                                start,
                                knownWords,
                                learnWords,
                                context,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
