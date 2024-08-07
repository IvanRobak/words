import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/word.dart';
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
  int columns = 3;
  final List<int> columnOptions = [2, 3];

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
    final favoriteWords = ref.watch(favoriteProvider);

    ref.listen<List<Word>>(favoriteProvider, (previous, next) {
      ref.read(wordFilterProvider.notifier).setWords(next);
    });

    bool hasFavorites = favoriteWords.isNotEmpty;
    bool hasSearchQuery = searchController.text.isNotEmpty;
    bool hasFilteredResults = filteredWords.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Favorite Words',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
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
            if (!hasFavorites)
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Add words to favorites.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
            else if (hasFavorites && !hasFilteredResults && hasSearchQuery)
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No matching words found.',
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
      ),
    );
  }
}
