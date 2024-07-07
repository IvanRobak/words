import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:words/models/word.dart';

class WordGameCard extends StatelessWidget {
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

  String _getExampleWithPlaceholder(Word word) {
    final wordPattern =
        RegExp(r'\b' + RegExp.escape(word.word) + r'\b', caseSensitive: false);
    return word.example.replaceAll(wordPattern, '...');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 200),
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
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
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
                            _getExampleWithPlaceholder(word),
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
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                childAspectRatio: 4,
                physics: const NeverScrollableScrollPhysics(),
                children: options.map((option) {
                  final isCorrect =
                      selectedAnswer == option && option == word.word;
                  final isWrong =
                      selectedAnswer == option && option != word.word;

                  return ElevatedButton(
                    onPressed: () => onOptionSelected(option),
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
                          vertical: 5, horizontal: 5),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
