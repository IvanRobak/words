import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/favorite_provider.dart';
import 'package:words/models/word.dart';

class IconButtons extends ConsumerWidget {
  final VoidCallback onSpeakPressed;
  final int wordId;
  final Word word;

  const IconButtons({
    super.key,
    required this.onSpeakPressed,
    required this.wordId,
    required this.word,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteProvider).contains(word);
    final favoriteNotifier = ref.read(favoriteProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 45,
          child: Center(
            child: Text(
              '#$wordId',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 16,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            favoriteNotifier.toggleFavorite(word);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.volume_up,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          onPressed: onSpeakPressed,
        ),
      ],
    );
  }
}
