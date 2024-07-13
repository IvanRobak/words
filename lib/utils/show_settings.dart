import 'package:flutter/material.dart';
import 'package:words/screens/settiings/settings.dart';

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
            onTap: () {},
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(left: 20, top: 80),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
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
