import 'package:flutter/material.dart';
import 'package:words/models/folder.dart';
import 'package:words/widgets/folder_button.dart';

class FolderContentScreen extends StatelessWidget {
  final Folder folder;

  const FolderContentScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    int columns = 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          folder.name,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3,
                ),
                itemCount: folder.words.length,
                itemBuilder: (context, index) {
                  final word = folder.words[index];
                  return FolderButton(
                    word: word,
                    columns: columns,
                    words: folder.words,
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
