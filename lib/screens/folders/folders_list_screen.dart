import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:words/providers/folder/folder_bloc.dart';
import 'package:words/providers/folder/folder_event.dart';
import 'package:words/providers/folder/folder_state.dart';
import 'package:words/widgets/folder.dart';
import 'package:words/utils/color_palette.dart'; // Імпортуйте ваш файл з кольорами

class FolderListScreen extends StatefulWidget {
  const FolderListScreen({super.key});

  @override
  FolderListScreenState createState() => FolderListScreenState();
}

class FolderListScreenState extends State<FolderListScreen> {
  void _showAddFolderDialog(BuildContext context) {
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
                colors: customColors,
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
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Add',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              onPressed: () {
                if (folderNameController.text.isNotEmpty) {
                  context.read<FolderBloc>().add(AddFolderEvent(
                      folderNameController.text, tempMainColor!));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Folders',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
      ),
      body: BlocBuilder<FolderBloc, FolderState>(
        builder: (context, state) {
          if (state is FoldersLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: state.folders.length,
              itemBuilder: (context, index) {
                final folder = state.folders[index];
                return FolderWidget(
                  folder: folder,
                  onNameChanged: (name) {
                    context
                        .read<FolderBloc>()
                        .add(UpdateFolderNameEvent(index, name));
                  },
                  onColorChanged: (color) {
                    context
                        .read<FolderBloc>()
                        .add(UpdateFolderColorEvent(index, color));
                  },
                  onDelete: () {
                    context.read<FolderBloc>().add(DeleteFolderEvent(index));
                  },
                );
              },
            );
          } else if (state is FolderInitial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Failed to load folders.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFolderDialog(context);
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
