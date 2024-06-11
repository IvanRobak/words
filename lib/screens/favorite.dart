import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/providers/favorite_provider.dart';
import '../widgets/word_list_view.dart';

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
          Expanded(
            child: WordListView(
              words: filteredWords,
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
          ),
          if (filteredWords.isEmpty)
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No favorite words found.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
