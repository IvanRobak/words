import 'package:flutter/material.dart';
import 'package:words/widgets/folder.dart';
import '../models/folder.dart'; // Імпортуємо новий віджет

class FolderListScreen extends StatefulWidget {
  const FolderListScreen({super.key});

  @override
  State<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  final List<Folder> folders = [
    Folder(name: '', words: []), // Початковий синій квадрат з плюсиком
  ];

  void _addFolder() {
    setState(() {
      folders.add(Folder(name: '', words: []));
      print('Додано нову папку'); // Додаємо відлагоджувальне повідомлення
    });
  }

  void _updateFolderName(int index, String name) {
    setState(() {
      // Переконаємося, що ми правильно оновлюємо об'єкт Folder
      folders[index] = Folder(name: name, words: folders[index].words);
      print(
          'Назва папки змінена на: $name'); // Додаємо відлагоджувальне повідомлення
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Folders'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Кількість колонок у сітці
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return FolderWidget(
            folder: folder,
            onNameChanged: (name) {
              _updateFolderName(index, name);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFolder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
