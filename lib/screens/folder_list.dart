import 'package:flutter/material.dart';
import '../models/folder.dart';

class FolderListScreen extends StatelessWidget {
  FolderListScreen({super.key});
  final List<Folder> folders = [
    Folder(name: 'Папка 1', words: []),
    Folder(name: 'Папка 2', words: []),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мої папки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Додайте логіку для створення нової папки
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return ListTile(
            title: Text(folder.name),
            onTap: () {
              // Додайте перехід до екрану папки зі словами
            },
          );
        },
      ),
    );
  }
}
