import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final bool isKnown;
  final bool isLearned;
  final VoidCallback onPressed;
  final int columns;

  const CustomButton({
    super.key,
    required this.label,
    required this.isKnown,
    required this.isLearned,
    required this.onPressed,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor;

    if (isKnown) {
      buttonColor = Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 89, 131, 148)
          : Theme.of(context).colorScheme.primary;
    } else if (isLearned) {
      buttonColor = Colors.purple;
    } else {
      buttonColor = Colors.grey;
    }

    double fontSize = columns == 2 ? 24 : 18; // змінюємо розмір шрифту

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        foregroundColor: Colors.white,
        backgroundColor: buttonColor,
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(
        label,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
