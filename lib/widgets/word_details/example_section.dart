import 'package:flutter/material.dart';

class ExampleSection extends StatelessWidget {
  final List<InlineSpan> exampleSpans;

  const ExampleSection({super.key, required this.exampleSpans});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: exampleSpans),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            width: 200,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }
}
