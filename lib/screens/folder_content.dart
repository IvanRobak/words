import 'package:flutter/material.dart';
import 'package:words/widgets/word_detail.dart';
import '../models/folder.dart';

class FolderContentScreen extends StatelessWidget {
  final Folder folder;

  const FolderContentScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: folder.words.isEmpty
          ? Center(
              child: Text('Вміст папки: ${folder.name}\nПапка пуста'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: folder.words.length,
              itemBuilder: (context, index) {
                final word = folder.words[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(word.word),
                    subtitle: Text(word.description),
                    onTap: () {
                      // Перехід на деталі слова
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordDetail(word: word),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
