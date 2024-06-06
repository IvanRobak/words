import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/folder.dart';

class FolderNotifier extends ChangeNotifier {
  final List<Folder> _folders = [Folder(name: '', words: [])];

  List<Folder> get folders => _folders;

  void addFolder() {
    _folders.add(Folder(name: '', words: []));
    notifyListeners();
  }

  void updateFolderName(int index, String name) {
    _folders[index] = Folder(name: name, words: folders[index].words);
    notifyListeners();
  }

  void deleteFolder(int index) {
    _folders.removeAt(index);
    notifyListeners();
  }
}

final folderProvider = ChangeNotifierProvider((ref) => FolderNotifier());
