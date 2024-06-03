import 'package:flutter/material.dart';
import 'package:words/widgets/word_button.dart';
import 'package:words/services/word_loader.dart';
import '../models/word.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> words = [];
  List<Word> filteredWords = [];
  int columns = 2; // Поточна кількість стовпців
  final List<int> columnOptions = [2, 3]; // Можливі варіанти
  TextEditingController searchController = TextEditingController();
  int currentPage = 0; // Поточна сторінка
  final int wordsPerPage = 20; // Кількість слів на сторінку

  @override
  void initState() {
    super.initState();
    loadWordsFromJson();
  }

  Future<void> loadWordsFromJson() async {
    final loadedWords = await loadWords();
    setState(() {
      words = loadedWords;
      filteredWords = loadedWords;
    });
  }

  void filterWords(String query) {
    final List<Word> results = words.where((word) {
      final String wordText = word.word.toLowerCase();
      final String input = query.toLowerCase();
      return wordText.startsWith(input);
    }).toList();

    setState(() {
      filteredWords = results;
      currentPage = 0; // Скидаємо на першу сторінку при пошуку
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Word> getCurrentPageWords() {
    final start = currentPage * wordsPerPage;
    final end = start + wordsPerPage;
    return filteredWords.sublist(
        start, end < filteredWords.length ? end : filteredWords.length);
  }

  void nextPage() {
    if ((currentPage + 1) * wordsPerPage < filteredWords.length) {
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
    final end = (currentPage + 1) * wordsPerPage < filteredWords.length
        ? (currentPage + 1) * wordsPerPage
        : filteredWords.length;
    return '$start-$end';
  }

  @override
  Widget build(BuildContext context) {
    final double mainAxisSpacing = columns == 2 ? 10 : 4;
    final double crossAxisSpacing = columns == 2 ? 10 : 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All words'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    DropdownButton<int>(
                      value: columns,
                      items: columnOptions.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          columns = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 100),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      onChanged: (query) {
                        filterWords(query);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredWords.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: mainAxisSpacing,
                        crossAxisSpacing: crossAxisSpacing,
                        childAspectRatio: 3,
                      ),
                      itemCount: getCurrentPageWords().length,
                      itemBuilder: (context, index) {
                        final word = getCurrentPageWords()[index];
                        return WordButton(word: word, columns: columns);
                      },
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: previousPage,
                  color: currentPage > 0 ? Colors.blue : Colors.grey,
                ),
                Text(getCurrentPageRange()),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: nextPage,
                  color: (currentPage + 1) * wordsPerPage < filteredWords.length
                      ? Colors.blue
                      : Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
