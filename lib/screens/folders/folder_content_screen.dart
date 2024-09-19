import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Повертаємо Riverpod
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words/models/folder.dart';
import 'package:words/providers/folder/folder_bloc.dart';
import 'package:words/providers/folder/folder_state.dart';
import 'package:words/providers/word_provider.dart'; // Використовуємо для фільтрації слів
import 'package:words/widgets/word_list_view.dart';
import 'package:words/services/word_loader.dart';

class FolderContentScreen extends ConsumerStatefulWidget {
  final Folder folder;

  const FolderContentScreen({super.key, required this.folder});

  @override
  FolderContentScreenState createState() => FolderContentScreenState();
}

class FolderContentScreenState extends ConsumerState<FolderContentScreen> {
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
    ref
        .read(wordFilterProvider.notifier)
        .setWords(allWords); // Використовуємо ref для доступу до провайдера
  }

  void loadFolderWords() async {
    final prefs = await SharedPreferences.getInstance();

    final savedWordIds = prefs.getStringList('folder_${widget.folder.name}');
    if (savedWordIds != null) {
      final allWords = ref
          .read(wordFilterProvider.notifier)
          .allWords; // Використання ref для отримання слів

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
    final filteredWords = ref.watch(
        wordFilterProvider); // Використовуємо ref для доступу до провайдера слів
    final hasWordsInFolder = filteredWords
        .isNotEmpty; // Визначаємо наявність слів у папці на основі фільтрованих слів
    bool hasSearchQuery = searchController.text.isNotEmpty;
    bool hasFilteredResults = filteredWords.isNotEmpty;

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
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<FolderBloc, FolderState>(
                        builder: (context, state) {
                          if (state is FoldersLoaded) {
                            return WordListView(
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
                                    .filterWords(query); // Використовуємо ref
                              },
                              searchFocusNode: searchFocusNode,
                            );
                          } else if (state is FolderInitial) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return const Center(
                                child: Text('Failed to load folders.'));
                          }
                        },
                      ),
                    ),
                    if (!hasWordsInFolder) // Використовуємо визначену змінну hasWordsInFolder
                      const Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No words in this folder.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                    else if (hasSearchQuery && !hasFilteredResults)
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
            ),
    );
  }
}
