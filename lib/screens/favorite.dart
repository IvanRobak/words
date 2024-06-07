import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/favorite_provider.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteWords = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Favorite Words'),
      ),
      body: ListView.builder(
        itemCount: favoriteWords.length,
        itemBuilder: (context, index) {
          final word = favoriteWords[index];
          return ListTile(
            title: Text(word.word),
            subtitle: Text(word.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(favoriteProvider.notifier).removeWord(word);
              },
            ),
          );
        },
      ),
    );
  }
}
