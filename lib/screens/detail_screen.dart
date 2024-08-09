import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
import 'package:words/widgets/word_details/word_detail.dart';

class DetailScreen extends ConsumerWidget {
  final List<Word> words;
  final int initialIndex;

  const DetailScreen({
    super.key,
    required this.words,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageController pageController = PageController(
      initialPage: initialIndex,
      viewportFraction: 0.95,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Details',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: WordDetail(
                word: word,
                onKnowPressed: () {},
                onLearnPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
