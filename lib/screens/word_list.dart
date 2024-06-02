import 'package:flutter/material.dart';
import 'package:words/widgets/word_button.dart';
import 'package:words/services/word_loader.dart';
import '../models/word.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({Key? key}) : super(key: key);

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> words = [];
  int columns = 2; // Поточна кількість стовпців
  final List<int> columnOptions = [2, 3]; // Можливі варіанти

  @override
  void initState() {
    super.initState();
    loadWordsFromJson();
  }

  Future<void> loadWordsFromJson() async {
    final loadedWords = await loadWords();
    setState(() {
      words = loadedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Налаштування відстані між картками в залежності від кількості стовпців
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
          ),
          Expanded(
            child: words.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns, // Використовуйте змінну
                        mainAxisSpacing: mainAxisSpacing, // Відстань між рядами
                        crossAxisSpacing:
                            crossAxisSpacing, // Відстань між стовпцями
                        childAspectRatio: 3, // Співвідношення сторін елемента
                      ),
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        final word = words[index];
                        return WordButton(word: word, columns: columns);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
