import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/image_progress_provider.dart';

class ImageGameSummaryScreen extends ConsumerWidget {
  final List<Word> words;
  final Map<int, bool> answerResults; // Мапа з результатами гри

  const ImageGameSummaryScreen({
    super.key,
    required this.words,
    required this.answerResults,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordProgressProvider = imageGameProgressProvider;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text(
          'Image Game Summary',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: ListView.builder(
          itemCount: words.length,
          itemBuilder: (context, index) {
            final word = words[index];
            final progress = ref.read(wordProgressProvider)[word.id] ?? 0.0;

            return ListTile(
              title: Text(
                word.word,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              trailing: SizedBox(
                width: 150,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.blue // Синій колір для заповнення
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
