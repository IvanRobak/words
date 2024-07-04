// dot_builder.dart

import 'package:flutter/material.dart';

Widget buildDot(
  int index,
  int currentPageIndex,
  Set<int> knownWords,
  Set<int> learnWords,
  BuildContext context,
) {
  int wordIndex = index + 1; // Інкрементувати index на 1 для відповідності ID
  Color dotColor;
  Border border;

  if (knownWords.contains(wordIndex)) {
    dotColor = Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 89, 131, 148)
        : Theme.of(context).colorScheme.primary;
  } else if (learnWords.contains(wordIndex)) {
    dotColor = Colors.purple;
  } else {
    dotColor = Colors.grey;
  }

  border = Border.all(
    color: currentPageIndex % 500 == index // більше ніж кількість слів
        ? Theme.of(context).colorScheme.secondary
        : Colors.transparent,
    width: 1,
  );

  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: dotColor,
      border: border,
    ),
  );
}

Widget buildDotWithoutHighlight(int index, int start, Set<int> knownWords,
    Set<int> learnWords, BuildContext context) {
  int wordIndex = start + index + 1; // Додаємо 1 тут
  Color dotColor;

  if (knownWords.contains(wordIndex)) {
    dotColor = Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 89, 131, 148)
        : Theme.of(context).colorScheme.primary;
  } else if (learnWords.contains(wordIndex)) {
    dotColor = Colors.purple;
  } else {
    dotColor = Colors.grey;
  }

  return Container(
    decoration: BoxDecoration(
      color: dotColor,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.transparent),
    ),
    width: 20,
    height: 20,
  );
}
