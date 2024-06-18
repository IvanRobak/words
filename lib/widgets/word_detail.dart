import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words/services/firebase_image_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/word.dart';
import '../providers/favorite_provider.dart';
import '../providers/folder_provider.dart';
import '../utils/text_utils.dart';
import '../services/translation_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WordDetail extends ConsumerStatefulWidget {
  final Word word;

  const WordDetail({super.key, required this.word});

  @override
  _WordDetailState createState() => _WordDetailState();
}

class _WordDetailState extends ConsumerState<WordDetail> {
  final TextEditingController _textController = TextEditingController();
  bool isTranslationVisible = false;
  String? selectedFolder;
  bool isLoading = true;
  bool isFavorite = false;
  String? imageUrl;

  late TranslationService translationService;
  late FirebaseImageService firebaseImageService;
  final FlutterTts _flutterTts = FlutterTts(); // Initialize the TTS

  static const apiKey = '29a4a816eb0b4645b3ed319fbfde82e5';
  static const endpoint = 'https://api.cognitive.microsofttranslator.com/';
  static const location = 'australiaeast';

  @override
  void initState() {
    super.initState();
    translationService = TranslationService(apiKey, endpoint, location);
    firebaseImageService = FirebaseImageService();
    _loadSavedFolder();
    checkIfFavorite();
    _translateWord();
    _fetchImage();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    _flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg"); // Handle TTS errors
    });
  }

  Future<void> _fetchImage() async {
    try {
      final url =
          await firebaseImageService.fetchImageUrl(widget.word.imageUrl);
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      // Handle error if needed
    }
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

  void checkIfFavorite() {
    final favoriteWords = ref.read(favoriteProvider);
    setState(() {
      isFavorite = favoriteWords.any((w) => w.id == widget.word.id);
    });
  }

  Future<void> _translateWord() async {
    try {
      final translation =
          await translationService.translate(widget.word.word, 'en', 'uk');
      setState(() {
        widget.word.translation = translation;
      });
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _flutterTts.stop(); // Stop the TTS
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
      folderProviderNotifier.removeWordFromAllFolders(widget.word);
      setState(() {
        selectedFolder = 'None';
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selectedFolder_${widget.word.id}');
    } else {
      folderProviderNotifier.addWordToFolder(folderName, widget.word);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedFolder_${widget.word.id}', folderName);
      setState(() {
        selectedFolder = folderName;
      });
    }
  }

  void _showNoFoldersMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No folders available. Create a folder first.'),
      ),
    );
  }

  void _speakWord() async {
    try {
      await _flutterTts.speak(widget.word.word);
    } catch (e) {
      print("Error speaking word: $e"); // Handle speech error
    }
  }

  @override
  Widget build(BuildContext context) {
    final folderNotifier = ref.watch(folderProvider);
    final folders = folderNotifier.folders;

    final exampleText = widget.word.example;
    final wordText = widget.word.word;
    final exampleSpans = buildExampleSpans(exampleText, wordText);

    if (selectedFolder != null &&
        selectedFolder != 'None' &&
        !folders.any((folder) => folder.name == selectedFolder)) {
      selectedFolder = null;
    }

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
                    if (imageUrl != null)
                      Center(
                        child: imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 179,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl!,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey,
                                      height: 179,
                                      width: double.infinity,
                                      child: const Center(
                                        child: Text(
                                          'Image not available',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: Colors.grey,
                                  height: 179,
                                  width: double.infinity,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                      ),
                    const SizedBox(height: 100),
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _toggleTranslation,
                          child: Text(
                            isTranslationVisible
                                ? (widget.word.translation ??
                                    'Translation not available')
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
                              child: Text('None'),
                            ),
                            ...folders.map((folder) => DropdownMenuItem<String>(
                                  value: folder.name,
                                  child: Text(folder.name),
                                ))
                          ],
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
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.volume_up,
                          color: Colors.white,
                        ),
                        onPressed: _speakWord, // Call _speakWord when pressed
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          if (isFavorite) {
                            ref
                                .read(favoriteProvider.notifier)
                                .removeWord(widget.word);
                            setState(() {
                              isFavorite = false;
                            });
                          } else {
                            ref
                                .read(favoriteProvider.notifier)
                                .addWord(widget.word);
                            setState(() {
                              isFavorite = true;
                            });
                          }
                        },
                      ),
                    ],
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
