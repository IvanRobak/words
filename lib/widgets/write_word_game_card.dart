import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:words/models/word.dart';
import 'package:words/utils/text_utils.dart';

class WriteWordGameCard extends StatefulWidget {
  final Word word;
  final String? imageUrl;
  final bool showExample;
  final VoidCallback onToggleExample;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final VoidCallback onNext;
  final VoidCallback onHint;
  final String? feedback;
  final bool showFeedback;
  final bool showHint;

  const WriteWordGameCard({
    super.key,
    required this.word,
    required this.imageUrl,
    required this.showExample,
    required this.onToggleExample,
    required this.controller,
    required this.onSubmit,
    required this.onNext,
    required this.onHint,
    required this.showHint,
    this.feedback,
    required this.showFeedback,
  });

  @override
  WriteWordGameCardState createState() => WriteWordGameCardState();
}

class WriteWordGameCardState extends State<WriteWordGameCard> {
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Card(
          color: Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.imageUrl != null)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl!,
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
                height: 30,
                child: Center(
                  child: widget.showExample
                      ? GestureDetector(
                          onTap: widget.onToggleExample,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              getExampleWithPlaceholder(widget.word),
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.lightbulb_outline),
                          color: Theme.of(context).colorScheme.onSecondary,
                          onPressed: widget.onToggleExample,
                        ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: TextField(
                        controller: widget.controller,
                        decoration: const InputDecoration(
                          labelText: 'Your answer',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: widget.onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: widget.onHint,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                              ),
                              child: widget.showHint
                                  ? Text(
                                      widget.word.word,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      'Hint',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                            TextButton(
                              onPressed: widget.onNext,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                              ),
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        if (widget.feedback != null)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: AnimatedOpacity(
                                opacity: widget.showFeedback ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  child: Text(
                                    widget.feedback!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: widget.feedback == 'Correct!'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
