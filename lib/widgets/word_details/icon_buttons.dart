import 'package:flutter/material.dart';

class IconButtons extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onSpeakPressed;
  final VoidCallback onFavoritePressed;

  const IconButtons({
    super.key,
    required this.isFavorite,
    required this.onSpeakPressed,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: onSpeakPressed, // Call _speakWord when pressed
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: onFavoritePressed,
          ),
        ],
      ),
    );
  }
}
