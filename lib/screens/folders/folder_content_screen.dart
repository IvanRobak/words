import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/folder.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/widgets/word_list_view.dart';

class FolderContentScreen extends ConsumerStatefulWidget {
  final Folder folder;

  const FolderContentScreen({super.key, required this.folder});

  @override
  ConsumerState<FolderContentScreen> createState() =>
      _FolderContentScreenState();
}

class _FolderContentScreenState extends ConsumerState<FolderContentScreen> {
  TextEditingController searchController = TextEditingController();
  int columns = 2;
  final List<int> columnOptions = [2, 3];
  late FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadFolderWords();
    });
  }

  void loadFolderWords() {
    ref.read(wordFilterProvider.notifier).setWords(widget.folder.words);
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = ref.watch(wordFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.folder.name,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: GestureDetector(
        onTap: () {
          searchFocusNode.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
            searchFocusNode: searchFocusNode,
          ),
        ),
      ),
    );
  }
}
