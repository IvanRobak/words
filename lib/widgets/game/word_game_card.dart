import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/word_progress_provider.dart';
import 'package:words/utils/text_utils.dart'; // Імпорт вашого провайдера

class WordGameCard extends ConsumerWidget {
  final Word word;
  final String? imageUrl;
  final bool showExample;
  final VoidCallback onToggleExample;
  final Function(String) onOptionSelected;
  final List<String> options;
  final String? selectedAnswer;

  const WordGameCard({
    super.key,
    required this.word,
    required this.imageUrl,
    required this.showExample,
    required this.onToggleExample,
    required this.onOptionSelected,
    required this.options,
    required this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomPadding;
    if (screenHeight > 800) {
      bottomPadding = 150;
    } else if (screenHeight > 600) {
      bottomPadding = 50;
    } else {
      bottomPadding = 0;
    }

    final progress = ref.watch(wordProgressWordProvider)[word.id] ?? 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Card(
        color: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: Center(
                child: showExample
                    ? GestureDetector(
                        onTap: onToggleExample,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            getExampleWithPlaceholder(word),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.lightbulb_outline),
                        color: Theme.of(context).colorScheme.onSecondary,
                        onPressed: onToggleExample,
                      ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 100,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  children: options.map((option) {
                    final isCorrect =
                        selectedAnswer == option && option == word.word;
                    final isWrong =
                        selectedAnswer == option && option != word.word;

                    return ElevatedButton(
                      onPressed: () {
                        onOptionSelected(option);
                        if (isCorrect) {
                          ref
                              .read(wordProgressWordProvider.notifier)
                              .incrementProgress(word.id);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCorrect
                            ? Colors.green
                            : isWrong
                                ? Colors.red
                                : Theme.of(context).colorScheme.inverseSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Container(
                height: 10,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
