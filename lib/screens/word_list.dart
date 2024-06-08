import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/widgets/word_list_view.dart';
import 'package:words/services/word_loader.dart';

class WordListScreen extends ConsumerStatefulWidget {
  const WordListScreen({super.key});

  @override
  ConsumerState<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends ConsumerState<WordListScreen> {
  TextEditingController searchController = TextEditingController();
  int columns = 2; // Поточна кількість стовпців
  final List<int> columnOptions = [2, 3]; // Можливі варіанти
  int currentPage = 0; // Поточна сторінка
  final int wordsPerPage = 20; // Кількість слів на сторінку

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadWordsFromJson();
    });
  }

  Future<void> loadWordsFromJson() async {
    final loadedWords = await loadWords();
    ref.read(wordFilterProvider.notifier).setWords(loadedWords);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Word> getCurrentPageWords(List<Word> filteredWords) {
    final start = currentPage * wordsPerPage;
    final end = start + wordsPerPage;
    return filteredWords.sublist(
        start, end < filteredWords.length ? end : filteredWords.length);
  }

  void nextPage() {
    if ((currentPage + 1) * wordsPerPage <
        ref.read(wordFilterProvider).length) {
      setState(() {
        currentPage++;
      });
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  String getCurrentPageRange() {
    final start = currentPage * wordsPerPage;
    final end =
        (currentPage + 1) * wordsPerPage < ref.read(wordFilterProvider).length
            ? (currentPage + 1) * wordsPerPage
            : ref.read(wordFilterProvider).length;
    return '$start-$end';
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = ref.watch(wordFilterProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('All words'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: WordListView(
                words: getCurrentPageWords(filteredWords),
                columns: columns,
                columnOptions: columnOptions,
                searchController: searchController,
                onColumnsChanged: (int? newValue) {
                  setState(() {
                    columns = newValue!;
                  });
                },
                onSearchChanged: (query) {
                  ref.read(wordFilterProvider.notifier).filterWords(query);
                  setState(() {
                    currentPage = 0; // Скидаємо на першу сторінку при пошуку
                  });
                },
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: previousPage,
                    color: currentPage > 0
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey,
                  ),
                  Text(getCurrentPageRange()),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: nextPage,
                    color:
                        (currentPage + 1) * wordsPerPage < filteredWords.length
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
