import 'package:flutter/material.dart';
import 'package:words/services/word_loader.dart';
import 'package:words/widgets/word_button.dart';
import '../models/word.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> words = [];

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('All words'),
        ),
        body: words.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Два стовпці
                    mainAxisSpacing: 10, // Відстань між рядами
                    crossAxisSpacing: 10, // Відстань між стовпцями
                    childAspectRatio: 3, // Співвідношення сторін елемента
                  ),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return WordButton(word: word);
                  },
                ),
              ));
  }
}
