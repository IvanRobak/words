import 'package:flutter/material.dart';

class LearnButton extends StatelessWidget {
  final bool isLearn;
  final VoidCallback onPressed;

  const LearnButton({
    super.key,
    required this.isLearn,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isLearn
            ? Colors.purple
            : Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.backgroundColor
                    ?.resolve({
                  WidgetState.pressed,
                  WidgetState.hovered,
                  WidgetState.focused
                }) ??
                Colors.white,
        foregroundColor: isLearn
            ? Colors.white
            : Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.foregroundColor
                    ?.resolve({
                  WidgetState.pressed,
                  WidgetState.hovered,
                  WidgetState.focused
                }) ??
                Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 30),
      ),
      onPressed: onPressed,
      child: const Text('Learn'),
    );
  }
}

class KnowButton extends StatelessWidget {
  final bool isKnown;
  final VoidCallback onPressed;

  const KnowButton({
    super.key,
    required this.isKnown,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isKnown
            ? (Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 89, 131, 148)
                : Theme.of(context).colorScheme.primary)
            : Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.backgroundColor
                    ?.resolve({
                  WidgetState.pressed,
                  WidgetState.hovered,
                  WidgetState.focused
                }) ??
                Colors.white,
        foregroundColor: isKnown
            ? Colors.white
            : Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.foregroundColor
                    ?.resolve({
                  WidgetState.pressed,
                  WidgetState.hovered,
                  WidgetState.focused
                }) ??
                Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 30),
      ),
      onPressed: onPressed,
      child: const Text('I know'),
    );
  }
}
