import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/models/word.dart';
import 'package:words/screens/word_carousel.dart';
import 'package:words/services/word_loader.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('All words'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Кількість стовпців у рядку
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1, // Співвідношення сторін елементів
          ),
          itemCount: 10, // Кількість квадратиків
          itemBuilder: (context, index) {
            final start = index * 50;
            final end = start + 50;
            words.length > start
                ? words.sublist(start, end > words.length ? words.length : end)
                : <Word>[];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordCarouselScreen(
                      words: words, // Передаємо всі слова
                      initialIndex: start,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    '$start - $end',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
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
