import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:words/screens/folder_content.dart';
import '../models/folder.dart';

class FolderWidget extends StatefulWidget {
  final Folder folder;
  final Function(String) onNameChanged;
  final Function(Color) onColorChanged;
  final VoidCallback onDelete;

  const FolderWidget({
    super.key,
    required this.folder,
    required this.onNameChanged,
    required this.onColorChanged,
    required this.onDelete,
  });

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  void _showRenameFolderDialog() {
    TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Перейменувати папку',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          content: TextField(
            controller: folderNameController,
            decoration:
                const InputDecoration(hintText: 'Введіть нову назву папки'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Скасувати'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Перейменувати'),
              onPressed: () {
                if (folderNameController.text.isNotEmpty) {
                  widget.onNameChanged(folderNameController.text);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Назва папки не може бути порожньою',
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

  void _showColorPickerDialog() {
    ColorSwatch? tempMainColor = widget.folder.color as ColorSwatch?;
    Color? tempShadeColor = widget.folder.color;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Виберіть колір папки',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          content: SingleChildScrollView(
            child: MaterialColorPicker(
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
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Скасувати'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Зберегти'),
              onPressed: () {
                widget.onColorChanged(tempMainColor!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(
                  'Перейменувати',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameFolderDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: Text(
                  'Змінити колір',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showColorPickerDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: Text(
                  'Видалити',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Are you sure to delete?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              widget.onDelete();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.folder.name.isEmpty) {
              _showRenameFolderDialog();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FolderContentScreen(folder: widget.folder),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.folder.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: widget.folder.name.isEmpty
                  ? const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 40,
                    )
                  : Text(
                      widget.folder.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showOptionsMenu(context),
          ),
        ),
      ],
    );
  }
}
