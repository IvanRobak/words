import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/favorite_provider.dart';
import '../models/word.dart';
import '../utils/text_utils.dart';
import '../utils/text_storage.dart';
import '../utils/user_examples_storage.dart';
import '../providers/folder_provider.dart';
import '../widgets/word_user_example_list.dart';

class WordDetailScreen extends ConsumerStatefulWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  // ignore: library_private_types_in_public_api
  _WordDetailScreenState createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends ConsumerState<WordDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  bool isTranslationVisible = false;
  String? selectedFolder;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedText();
    _textController.addListener(_handleTyping);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleTyping() {
    setState(() {});
    TextStorage.saveText(widget.word, _textController.text);
  }

  Future<void> _loadSavedText() async {
    final loadedData = await TextStorage.loadText(widget.word);
    final savedText = loadedData['savedText'] as String?;
    final savedExamples =
        await UserExamplesStorage.loadUserExamples(widget.word);

    if (savedText != null) {
      _textController.text = savedText;
    }

    if (savedExamples != null) {
      setState(() {
        widget.word.userExamples = savedExamples;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _addExample() {
    setState(() {
      widget.word.userExamples.add('');
    });
    UserExamplesStorage.saveUserExamples(widget.word);
  }

  void _removeExample(int index) {
    setState(() {
      widget.word.userExamples.removeAt(index);
    });
    UserExamplesStorage.saveUserExamples(widget.word);
  }

  void _updateExample(int index, String value) {
    setState(() {
      widget.word.userExamples[index] = value;
    });
    UserExamplesStorage.saveUserExamples(widget.word);
  }

  void _toggleTranslation() {
    setState(() {
      isTranslationVisible = !isTranslationVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteWords = ref.watch(favoriteProvider);
    final isFavorite = favoriteWords.contains(widget.word);

    final exampleText = widget.word.example;
    final wordText = widget.word.word;
    final exampleSpans = buildExampleSpans(
      exampleText,
      wordText,
    );

    final folderNotifier = ref.watch(folderProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Study'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Card(
                color: Theme.of(context).colorScheme.primary,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    child: Stack(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 30),
                          Center(
                            child: Text(
                              widget.word.word,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              widget.word.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: exampleSpans),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 1,
                                  width: 200,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          WordExamplesList(
                            word: widget.word,
                            onUpdate: _updateExample,
                            onRemove: _removeExample,
                            onAddExample: _addExample,
                          ),
                          const SizedBox(height: 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: _toggleTranslation,
                                child: Text(
                                  isTranslationVisible
                                      ? widget.word.translation
                                      : 'ua',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DropdownButton<String>(
                                hint: const Text(
                                  "Select Folder",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: selectedFolder,
                                items: folderNotifier.folders
                                    .map((folder) => DropdownMenuItem<String>(
                                          value: folder.name,
                                          child: Text(folder.name),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedFolder = value;
                                  });
                                },
                                dropdownColor:
                                    Theme.of(context).colorScheme.primary,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            if (isFavorite) {
                              ref
                                  .read(favoriteProvider.notifier)
                                  .removeWord(widget.word);
                            } else {
                              ref
                                  .read(favoriteProvider.notifier)
                                  .addWord(widget.word);
                            }
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
    );
  }
}
