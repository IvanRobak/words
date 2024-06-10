import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';
import '../providers/favorite_provider.dart';
import '../providers/folder_provider.dart';
import '../utils/text_utils.dart';

class WordDetail extends ConsumerStatefulWidget {
  final Word word;

  const WordDetail({super.key, required this.word});

  @override
  // ignore: library_private_types_in_public_api
  _WordDetailState createState() => _WordDetailState();
}

class _WordDetailState extends ConsumerState<WordDetail> {
  final TextEditingController _textController = TextEditingController();
  bool isTranslationVisible = false;
  String? selectedFolder;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedFolder();
  }

  Future<void> _loadSavedFolder() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFolderName = prefs.getString('selectedFolder_${widget.word.id}');
    if (savedFolderName != null) {
      setState(() {
        selectedFolder = savedFolderName;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleTranslation() {
    setState(() {
      isTranslationVisible = !isTranslationVisible;
    });
  }

  void _addWordToFolder(String? folderName) async {
    final folderProviderNotifier = ref.read(folderProvider);
    if (folderName == null || folderName == 'None') {
      // Видалення слова з усіх папок
      for (var folder in folderProviderNotifier.folders) {
        folderProviderNotifier.removeWordFromFolder(folder.name, widget.word);
      }
      setState(() {
        selectedFolder = 'None';
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selectedFolder_${widget.word.id}');
    } else {
      folderProviderNotifier.addWordToFolder(folderName, widget.word);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedFolder_${widget.word.id}', folderName);
    }
  }

  void _showNoFoldersMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No folders available. Create a folder first.',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteWords = ref.watch(favoriteProvider);
    final isFavorite = favoriteWords.contains(widget.word);

    final exampleText = widget.word.example;
    final wordText = widget.word.word;
    final exampleSpans = buildExampleSpans(exampleText, wordText);

    final folderNotifier = ref.watch(folderProvider);
    final folders = folderNotifier.folders;

    // Перевірка, чи існує selectedFolder у списку папок
    if (selectedFolder != null &&
        selectedFolder != 'None' &&
        !folders.any((folder) => folder.name == selectedFolder)) {
      selectedFolder = null;
    }

    const imagePath = 'assets/images/apple.webp';

    return Padding(
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
            child: Stack(
              children: [
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
                      child: Image.asset(
                        imagePath,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                    const SizedBox(height: 40),
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
                          items: [
                            const DropdownMenuItem<String>(
                              value: 'None',
                              alignment: Alignment.center,
                              child: Text('None'),
                            ),
                            ...folders.map((folder) => DropdownMenuItem<String>(
                                  value: folder.name,
                                  alignment: Alignment.center,
                                  child: Text(folder.name),
                                ))
                          ],
                          alignment: Alignment.center,
                          onChanged: (value) {
                            if (folders.isEmpty) {
                              _showNoFoldersMessage();
                            } else {
                              setState(() {
                                selectedFolder = value;
                                _addWordToFolder(value);
                              });
                            }
                          },
                          dropdownColor: Theme.of(context).colorScheme.primary,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
