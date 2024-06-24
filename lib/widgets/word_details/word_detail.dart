import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words/models/word.dart';
import 'package:words/providers/favorite_provider.dart';
import 'package:words/providers/folder_provider.dart';
import 'package:words/services/firebase_image_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:words/services/translation_service.dart';
import 'package:words/utils/text_utils.dart';
import 'package:words/widgets/word_details/bottom_section.dart';
import 'package:words/widgets/word_details/example_section.dart';
import 'package:words/widgets/word_details/icon_buttons.dart';
import 'package:words/widgets/word_details/image_section.dart';

class WordDetail extends ConsumerStatefulWidget {
  final Word word;
  final VoidCallback onKnowPressed;
  final VoidCallback onLearnPressed;

  const WordDetail(
      {super.key,
      required this.word,
      required this.onKnowPressed,
      required this.onLearnPressed // Додано цей параметр
      });

  @override
  // ignore: library_private_types_in_public_api
  _WordDetailState createState() => _WordDetailState();
}

class _WordDetailState extends ConsumerState<WordDetail> {
  final TextEditingController _textController = TextEditingController();
  bool isTranslationVisible = false;
  String? selectedFolder;
  bool isLoading = true;
  bool isFavorite = false;
  String? imageUrl;
  bool isLearn = false;
  bool isKnown = false;

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
      // print("TTS Error: $msg"); // Handle TTS errors
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
      // print("Error speaking word: $e"); // Handle speech error
    }
  }

  void _learnWord() {
    setState(() {
      isLearn = true;
      isKnown = false;
    });
    widget.onLearnPressed();
  }

  void _knowWord() {
    setState(() {
      isKnown = true;
      isLearn = false;
    });
    widget.onKnowPressed(); // Викликаємо зворотний виклик
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
      padding: const EdgeInsets.only(top: 20, bottom: 50),
      child: Card(
        color: Colors.grey,
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
                    Center(
                      child: Text(
                        widget.word.word,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ),
                    ImageSection(imageUrl: imageUrl),
                    const SizedBox(height: 20),
                    IconButtons(
                      isFavorite: isFavorite,
                      onSpeakPressed: _speakWord,
                      onFavoritePressed: () {
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
                      wordId: widget.word.id,
                    ),
                    const SizedBox(height: 20),
                    ExampleSection(exampleSpans: exampleSpans),
                    const SizedBox(height: 20),
                    BottomSection(
                      isTranslationVisible: isTranslationVisible,
                      translation: widget.word.translation,
                      selectedFolder: selectedFolder,
                      folders: folders,
                      onFolderChanged: (value) {
                        if (folders.isEmpty) {
                          _showNoFoldersMessage();
                        } else {
                          setState(() {
                            selectedFolder = value;
                            _addWordToFolder(value);
                          });
                        }
                      },
                      toggleTranslation: _toggleTranslation,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isLearn ? Colors.purple : Colors.white,
                              foregroundColor: isLearn
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30)),
                          onPressed: _learnWord,
                          child: const Text('Learn'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isKnown
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              foregroundColor: isKnown
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30)),
                          onPressed: _knowWord,
                          child: const Text('I know'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
