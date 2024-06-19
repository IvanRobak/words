import 'package:flutter/material.dart';

class IconButtons extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onSpeakPressed;
  final VoidCallback onFavoritePressed;
  final int wordId; // Додано параметр wordId

  const IconButtons({
    super.key,
    required this.isFavorite,
    required this.onSpeakPressed,
    required this.onFavoritePressed,
    required this.wordId, // Ініціалізація параметра wordId
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -15,
      right: 0,
      left: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40, // Встановіть ширину, яка дорівнює ширині іконок
            child: Center(
              child: Text(
                '#$wordId', // Використання wordId для відображення номера
                style: const TextStyle(
                  color: Color.fromARGB(150, 245, 244, 244),
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
            onPressed: onFavoritePressed,
          ),
          IconButton(
            icon: const Icon(
              Icons.volume_up,
              color: Color.fromARGB(150, 245, 244, 244),
            ),
            onPressed: onSpeakPressed,
          ),
        ],
      ),
    );
  }
}
