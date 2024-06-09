import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/word_provider.dart';
import 'package:words/services/word_loader.dart';
import 'package:words/widgets/word_button.dart'; // Ensure this provider provides the list of words

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  // String _searchQuery = '';

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
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search words...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary // Set the border color to black for the enabled state
                      ),
                ),
              ),
              onChanged: (query) {
                ref.read(wordFilterProvider.notifier).filterWords(query);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 3,
                ),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  return WordButton(
                    word: word,
                    columns: 3,
                    words: words,
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
