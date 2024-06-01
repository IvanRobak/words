import 'package:flutter/material.dart';

class WordDetailScreen extends StatelessWidget {
  final String word;

  const WordDetailScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Опис для слова $word'),
      ),
    );
  }
}
