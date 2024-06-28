// carousel_footer.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/button_provider.dart';
import 'package:words/widgets/dot_builder.dart';

class CarouselFooter extends StatelessWidget {
  final int currentPageIndex;
  final int totalWords;
  final PageController pageController;
  final WidgetRef ref;

  const CarouselFooter({
    required this.currentPageIndex,
    required this.totalWords,
    required this.pageController,
    required this.ref,
    Key? key,
  }) : super(key: key);

  void _jumpToGroup(int groupStart) {
    int groupEnd = groupStart + 50;
    int targetIndex = _findFirstUnselectedInRange(groupStart, groupEnd);
    pageController.animateToPage(
      targetIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  int _findFirstUnselectedInRange(int start, int end) {
    final knownWords = ref.read(knownWordsProvider);
    final learnWords = ref.read(learnWordsProvider);
    for (int i = start; i < end; i++) {
      if (!knownWords.contains(i) && !learnWords.contains(i)) {
        return i;
      }
    }
    return start; // Якщо всі слова обрані, повертаємо початок діапазону
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              if (currentPageIndex >= 50) {
                int targetIndex = (currentPageIndex ~/ 50 - 1) * 50;
                _jumpToGroup(targetIndex);
              }
            },
          ),
          Column(
            children: [
              Text(
                '${(currentPageIndex ~/ 50) * 50}-${((currentPageIndex ~/ 50) + 1) * 50}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              Center(
                child: SizedBox(
                  height: 80,
                  width: 220,
                  child: GridView.builder(
                    itemCount: 50,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 1,
                      childAspectRatio: 1.6,
                    ),
                    itemBuilder: (context, index) {
                      return buildDot(
                        index,
                        currentPageIndex,
                        ref.watch(knownWordsProvider),
                        ref.watch(learnWordsProvider),
                        context,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              if (currentPageIndex < totalWords - 1) {
                int targetIndex = (currentPageIndex ~/ 50 + 1) * 50;
                _jumpToGroup(targetIndex);
              }
            },
          ),
        ],
      ),
    );
  }
}
