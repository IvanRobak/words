import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/folder_provider.dart';
import 'package:words/widgets/folder.dart';

class FolderListScreen extends ConsumerWidget {
  const FolderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folderNotifier = ref.watch(folderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Folders',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context)
              .colorScheme
              .onSecondary, // Задаємо колір для значків
        ),
      ),
      body: folderNotifier.folders.isEmpty
          ? const Center(
              child: Text(
                'No folders added yet.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: folderNotifier.folders.length,
              itemBuilder: (context, index) {
                final folder = folderNotifier.folders[index];
                return FolderWidget(
                  folder: folder,
                  onNameChanged: (name) {
                    folderNotifier.updateFolderName(index, name);
                  },
                  onColorChanged: (color) {
                    folderNotifier.updateFolderColor(index, color);
                  },
                  onDelete: () {
                    folderNotifier.deleteFolder(index);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFolderDialog(context, folderNotifier);
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showAddFolderDialog(
      BuildContext context, FolderNotifier folderNotifier) {
    final TextEditingController folderNameController = TextEditingController();
    Color folderColor = Colors.blue; // Default color

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add New Folder',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: folderNameController,
                decoration:
                    const InputDecoration(hintText: 'Enter folder name'),
              ),
              const SizedBox(height: 20),
              ColorPicker(
                pickerColor: folderColor,
                onColorChanged: (color) {
                  folderColor = color;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (folderNameController.text.isNotEmpty) {
                  folderNotifier.addFolder(
                      folderNameController.text, folderColor);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Folder name cannot be empty'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
