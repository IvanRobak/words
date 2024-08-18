import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words/models/folder.dart';
import 'package:words/providers/folder_provider.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/widgets/word_list_view.dart';
import 'package:words/services/word_loader.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
    _loadColumnsPreference();

    _loadAllWords().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadFolderWords();
      });
    });
  }

  Future<void> _saveColumnsPreference(int columns) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('columns_preference', columns);
  }

  Future<void> _loadColumnsPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      columns = prefs.getInt('columns_preference') ?? 2;
    });
  }

  Future<void> _loadAllWords() async {
    final allWords = await loadWords();
    ref.read(wordFilterProvider.notifier).setWords(allWords);
  }

  void loadFolderWords() async {
    final prefs = await SharedPreferences.getInstance();

    final savedWordIds = prefs.getStringList('folder_${widget.folder.name}');
    if (savedWordIds != null) {
      final allWords = ref.read(wordFilterProvider.notifier).allWords;

      final wordsInFolder = allWords.where((word) {
        return savedWordIds.contains(word.id.toString());
      }).toList();

      ref.read(wordFilterProvider.notifier).setWords(wordsInFolder);
    } else {
      ref.read(wordFilterProvider.notifier).setWords(widget.folder.words);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(folderProvider).folders;
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                searchFocusNode.unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: filteredWords.isEmpty
                    ? Center(
                        child: Text(
                          'No words in ${widget.folder.name}.',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : WordListView(
                        words: filteredWords,
                        columns: columns,
                        columnOptions: columnOptions,
                        searchController: searchController,
                        onColumnsChanged: (int? newValue) {
                          setState(() {
                            columns = newValue!;
                          });
                          _saveColumnsPreference(newValue!);
                        },
                        onSearchChanged: (query) {
                          ref
                              .read(wordFilterProvider.notifier)
                              .filterWords(query);
                        },
                        searchFocusNode: searchFocusNode,
                      ),
              ),
            ),
    );
  }
}
