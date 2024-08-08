import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/services/word_loader.dart';
import 'package:words/widgets/word_list_view.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  int columns = 3;
  final List<int> columnOptions = [2, 3];
  late FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadWordsFromJson();
    });
  }

  Future<void> loadWordsFromJson() async {
    final loadedWords = await loadWords();
    ref.read(wordFilterProvider.notifier).setWords(loadedWords);
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(wordFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WordListView(
          words: words,
          columnOptions: columnOptions,
          columns: columns,
          searchFocusNode: searchFocusNode,
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
