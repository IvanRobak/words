import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/providers/folder_provider.dart';
import 'package:words/widgets/folder.dart';

class FolderListScreen extends ConsumerStatefulWidget {
  const FolderListScreen({super.key});

  @override
  FolderListScreenState createState() => FolderListScreenState();
}

class FolderListScreenState extends ConsumerState<FolderListScreen> {
  @override
  Widget build(BuildContext context) {
    final folderNotifier = ref.watch(folderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Folders',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: GridView.builder(
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
    ColorSwatch? tempMainColor = Colors.blue; // Default color
    Color? tempShadeColor = Colors.blue[800];

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
              MaterialColorPicker(
                selectedColor: tempShadeColor,
                onColorChange: (color) {
                  setState(() {
                    tempShadeColor = color;
                  });
                },
                onMainColorChange: (color) {
                  setState(() {
                    tempMainColor = color;
                  });
                },
                allowShades: false,
                shrinkWrap: true,
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
                      folderNameController.text, tempMainColor!);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Folder name cannot be empty',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
