import 'package:flutter/material.dart';
import 'package:words/screens/folder_content.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
          title: const Text('Перейменувати папку'),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Назва папки не може бути порожньою'),
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

  void _showColorPickerDialog() {
    Color pickerColor = widget.folder.color;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Виберіть колір папки'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                setState(() {
                  pickerColor = color;
                });
              },
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
                widget.onColorChanged(pickerColor);
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
                title: const Text('Перейменувати'),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameFolderDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Змінити колір'),
                onTap: () {
                  Navigator.pop(context);
                  _showColorPickerDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Видалити'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onDelete();
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
                      color: Colors.white,
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
