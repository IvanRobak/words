import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:words/models/word.dart';

class WriteWordGameCard extends StatelessWidget {
  final Word word;
  final String? imageUrl;
  final bool showExample;
  final VoidCallback onToggleExample;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final String? feedback;

  const WriteWordGameCard({
    super.key,
    required this.word,
    required this.imageUrl,
    required this.showExample,
    required this.onToggleExample,
    required this.controller,
    required this.onSubmit,
    this.feedback,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Your answer',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (feedback != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        feedback!,
                        style: TextStyle(
                          fontSize: 18,
                          color: feedback == 'Correct!'
                              ? Colors.green
                              : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
