import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/widgets/dot_builder.dart';

class CarouselFooter extends ConsumerWidget {
  final int currentPageIndex;
  final int totalWords;
  final PageController pageController;
  final int startIndex;

  const CarouselFooter({
    super.key,
    required this.currentPageIndex,
    required this.totalWords,
    required this.pageController,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knownWords = ref.watch(knownWordsProvider);
    final learnWords = ref.watch(learnWordsProvider);
    final wordsInCurrentGroup = totalWords - (currentPageIndex ~/ 50) * 50;
    final itemCount = wordsInCurrentGroup > 50 ? 50 : wordsInCurrentGroup;

    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            '$startIndex-${startIndex + itemCount - 1}',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          Center(
            child: SizedBox(
              height: 80,
              width: 220,
              child: GridView.builder(
                itemCount: itemCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 1,
                  childAspectRatio: 1.6,
                ),
                itemBuilder: (context, index) {
                  final adjustedIndex = (currentPageIndex ~/ 50) * 50 + index;
                  return buildDot(
                    adjustedIndex, // Коректний індекс для поточної групи
                    currentPageIndex,
                    knownWords,
                    learnWords,
                    context,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
