import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/services/word_loader.dart';
import 'package:words/widgets/word_list_view.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  int columns = 2; // Поточна кількість стовпців
  final List<int> columnOptions = [2, 3]; // Можливі варіанти

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadWordsFromJson();
    });
  }

  Future<void> loadWordsFromJson() async {
    final loadedWords = await loadWords();
    ref.read(wordFilterProvider.notifier).setWords(loadedWords);
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(wordFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WordListView(
          words: words,
          columnOptions: columnOptions,
          columns: columns,
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
    );
  }
}
