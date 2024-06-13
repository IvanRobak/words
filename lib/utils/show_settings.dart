import 'package:flutter/material.dart';
import 'package:words/screens/settings.dart';

void showSettingsScreen(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap:
                () {}, // Щоб всередині контейнера натискання не закривало його
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: Container(
                height:
                    MediaQuery.of(context).size.height, // Висота на увесь екран
                padding: const EdgeInsets.only(left: 20, top: 80),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const SettingsScreen(),
              ),
            ),
          ),
        ),
      );
    },
  );
}
