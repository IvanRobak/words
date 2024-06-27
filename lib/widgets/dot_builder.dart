// dot_builder.dart

import 'package:flutter/material.dart';

Widget buildDot(int index, int currentPageIndex, Set<int> knownWords,
    Set<int> learnWords, BuildContext context) {
  int wordIndex = (currentPageIndex ~/ 50) * 50 + index;
  Color dotColor;
  Border border;

  if (knownWords.contains(wordIndex)) {
    dotColor = Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 89, 131, 148)
        : Theme.of(context).colorScheme.primary;
    border = currentPageIndex % 50 == index
        ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 1)
        : Border.all(color: Colors.transparent);
  } else if (learnWords.contains(wordIndex)) {
    dotColor = Colors.purple;
    border = currentPageIndex % 50 == index
        ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 1)
        : Border.all(color: Colors.transparent);
  } else {
    dotColor = Colors.grey;
    border = currentPageIndex % 50 == index
        ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 1)
        : Border.all(color: Colors.transparent);
  }

  return Container(
    decoration: BoxDecoration(
      color: dotColor,
      shape: BoxShape.circle,
      border: border,
    ),
  );
}