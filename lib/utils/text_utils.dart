import 'package:flutter/material.dart';

List<TextSpan> buildExampleSpans(
    BuildContext context, String exampleText, String wordText) {
  final List<TextSpan> spans = [];
  final wordStartIndex =
      exampleText.toLowerCase().indexOf(wordText.toLowerCase());

  if (wordStartIndex == -1) {
    spans.add(TextSpan(
        text: exampleText,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary, fontSize: 16)));
  } else {
    if (wordStartIndex > 0) {
      spans.add(TextSpan(
          text: exampleText.substring(0, wordStartIndex),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary, fontSize: 16)));
    }
    spans.add(TextSpan(
        text: exampleText.substring(
            wordStartIndex, wordStartIndex + wordText.length),
        style: const TextStyle(
            color: Color.fromARGB(255, 255, 145, 0),
            fontSize: 16,
            fontWeight: FontWeight.bold)));
    if (wordStartIndex + wordText.length < exampleText.length) {
      spans.add(TextSpan(
          text: exampleText.substring(wordStartIndex + wordText.length),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary, fontSize: 16)));
    }
  }

  return spans;
}
