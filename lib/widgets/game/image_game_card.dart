import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/image_progress_provider.dart';
import 'package:words/services/cache_manager_service.dart';

class ImageGameCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final progress = ref.watch(imageGameProgressProvider)[word.id] ?? 0.0;

    return Padding(
      padding:
          EdgeInsets.only(bottom: height > 799 ? height * 0.15 : height * 0.06),
      child: Card(
        color: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 15, bottom: 30),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
                physics: const NeverScrollableScrollPhysics(),
                children: options.map((option) {
                  final isCorrect =
                      selectedAnswer == option && option == correctImageUrl;
                  final isWrong =
                      selectedAnswer == option && option != correctImageUrl;

                  return GestureDetector(
                    onTap: () {
                      onOptionSelected(option);
                      if (option == correctImageUrl) {
                        ref
                            .read(imageGameProgressProvider.notifier)
                            .incrementProgress(word.id);
                      }
                    },
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
                          cacheManager: customCacheManager,
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
              height: height * 0.04,
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
            SizedBox(
              height: height * 0.07,
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
            Center(
              child: Container(
                height: height * 0.015,
                width: width * 0.8,
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
