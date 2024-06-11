import 'package:flutter/material.dart';
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
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Your Folders'),
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(hintText: 'Enter folder name'),
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
                  folderNotifier.addFolder(folderNameController.text);
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
