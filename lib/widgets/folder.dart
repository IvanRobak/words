import 'package:flutter/material.dart';
import '../models/folder.dart';

class FolderWidget extends StatefulWidget {
  final Folder folder;
  final Function(String) onNameChanged;

  const FolderWidget(
      {super.key, required this.folder, required this.onNameChanged});

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  void _showAddFolderDialog() {
    TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Нова папка'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(hintText: 'Введіть назву папки'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Скасувати'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Додати'),
              onPressed: () {
                print(
                    'Додати натиснуто'); // Додаємо відлагоджувальне повідомлення
                if (folderNameController.text.isNotEmpty) {
                  widget.onNameChanged(folderNameController.text);
                  Navigator.of(context).pop();
                  print(
                      'Назва папки: ${folderNameController.text}'); // Додаємо відлагоджувальне повідомлення
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Папка натиснута'); // Додаємо відлагоджувальне повідомлення
        if (widget.folder.name.isEmpty) {
          _showAddFolderDialog();
        } else {
          // Додайте перехід до екрану папки зі словами
          print('Перехід до папки: ${widget.folder.name}');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF426CD8),
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
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}
