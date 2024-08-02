import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:words/models/word.dart';

class ImageGameCard extends StatelessWidget {
  final Word word;
  final bool showExample;
  final VoidCallback onToggleExample;
  final Function(String) onOptionSelected;
  final List<String> options;
  final String? selectedAnswer;
  final String correctImageUrl;

  const ImageGameCard({
    super.key,
    required this.word,
    required this.showExample,
    required this.onToggleExample,
    required this.onOptionSelected,
    required this.options,
    required this.selectedAnswer,
    required this.correctImageUrl,
  });

  String _getExampleWithPlaceholder(Word word) {
    final wordPattern =
        RegExp(r'\b' + RegExp.escape(word.word) + r'\b', caseSensitive: false);
    return word.example.replaceAll(wordPattern, '...');
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Встановлення відступу залежно від висоти екрану
    double bottomPadding;
    if (screenHeight > 800) {
      bottomPadding = 200;
    } else if (screenHeight > 600) {
      bottomPadding = 80;
    } else {
      bottomPadding = 0;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Card(
        color: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    top: 15, bottom: 30), // Встановлюємо padding на нуль
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10, // Зменшення відступів між елементами
                childAspectRatio: 1.0,
                physics: const NeverScrollableScrollPhysics(),
                children: options.map((option) {
                  final isCorrect =
                      selectedAnswer == option && option == correctImageUrl;
                  final isWrong =
                      selectedAnswer == option && option != correctImageUrl;

                  return GestureDetector(
                    onTap: () => onOptionSelected(option),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isCorrect
                              ? Colors.green
                              : isWrong
                                  ? Colors.red
                                  : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: option,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
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
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  word.word,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
