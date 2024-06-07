import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/providers/favorite_provider.dart';
import 'package:words/widgets/filter.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  TextEditingController searchController = TextEditingController();
  int columns = 2; // Поточна кількість стовпців
  final List<int> columnOptions = [2, 3]; // Можливі варіанти

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadFavoriteWords();
    });
  }

  void loadFavoriteWords() {
    final favorites = ref.read(favoriteProvider);
    ref.read(wordFilterProvider.notifier).setWords(favorites);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = ref.watch(wordFilterProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Favorite Words'),
      ),
      body: Column(
        children: [
          FilterBar(
            columns: columns,
            columnOptions: columnOptions,
            searchController: searchController,
            onColumnsChanged: (int? newValue) {
              setState(() {
                columns = newValue!;
              });
            },
            onSearchChanged: (query) {
              ref.read(wordFilterProvider.notifier).filterWords(query);
            },
          ),
          Expanded(
            child: filteredWords.isEmpty
                ? const Center(child: Text('No favorite words'))
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 3,
                      ),
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];
                        return ListTile(
                          title: Text(word.word),
                          subtitle: Text(word.description),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref
                                  .read(favoriteProvider.notifier)
                                  .removeWord(word);
                            },
                          ),
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
