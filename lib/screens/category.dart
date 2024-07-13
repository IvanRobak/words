import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context)
              .colorScheme
              .onSecondary, 
        ),
      ),
      body: const Center(
        child: Text('Here will be categories list'),
      ),
    );
  }
}
