import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';
import '../utils/text_utils.dart';
import '../providers/folder_provider.dart';

class WordDetailScreen extends ConsumerStatefulWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  ConsumerState<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends ConsumerState<WordDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  bool isTranslationVisible = false;
  String? selectedFolder;

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
    _saveText();
  }

  Future<void> _saveText() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.word.word, _textController.text);
    await prefs.setStringList(
        '${widget.word.word}_userExamples', widget.word.userExamples);
  }

  Future<void> _loadSavedText() async {
    final prefs = await SharedPreferences.getInstance();
    final savedText = prefs.getString(widget.word.word);
    final savedExamples =
        prefs.getStringList('${widget.word.word}_userExamples');

    if (savedText != null) {
      _textController.text = savedText;
    }

    if (savedExamples != null) {
      setState(() {
        widget.word.userExamples = savedExamples;
      });
    }
  }

  void _addExample() {
    setState(() {
      widget.word.userExamples.add('');
    });
    _saveText();
  }

  void _removeExample(int index) {
    setState(() {
      widget.word.userExamples.removeAt(index);
    });
    _saveText();
  }

  void _toggleTranslation() {
    setState(() {
      isTranslationVisible = !isTranslationVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exampleText = widget.word.example;
    final wordText = widget.word.word;
    final exampleSpans = buildExampleSpans(
      exampleText,
      wordText,
    );

    final folderNotifier = ref.watch(folderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Card(
          color: const Color(0xFF426CD8),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 36),
                  Center(
                    child: Text(
                      widget.word.word,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RichText(
                      text: TextSpan(children: exampleSpans),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  for (int i = 0; i < widget.word.userExamples.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text: widget.word.userExamples[i],
                              ),
                              onChanged: (value) {
                                widget.word.userExamples[i] = value;
                                _saveText();
                              },
                              decoration: const InputDecoration(
                                hintText: 'Your example',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              style: const TextStyle(color: Colors.white),
                              minLines: 1,
                              maxLines: null,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (value) {
                                widget.word.userExamples[i] = value;
                                _saveText();
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () => _removeExample(i),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addExample,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Add Example'),
                  ),
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _toggleTranslation,
                        child: Text(
                          isTranslationVisible ? widget.word.translation : 'ua',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(15),
                        hint: const Text(
                          "Folder",
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
                          // Виконати необхідні дії після вибору папки
                        },
                        dropdownColor: const Color(0xFF426CD8),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
