import 'package:flutter/material.dart';
import 'package:words/models/word.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Card(
          color: const Color(0xFF426CD8),
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  Text(
                    word.word,
                    style: const TextStyle(color: Colors.white, fontSize: 35),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    word.description,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Column(
                    children: [
                      TextField(),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'ua',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Hobby'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
