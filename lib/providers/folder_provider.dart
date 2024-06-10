import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/folder.dart';
import 'package:words/models/word.dart';

class FolderNotifier extends ChangeNotifier {
  // final List<Folder> _folders = [Folder(name: '', words: [])];
  final List<Folder> _folders = [];

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

  void addWordToFolder(String folderName, Word word) {
    for (var folder in _folders) {
      if (folder.name == folderName) {
        word.selectedFolder = folderName;
        folder.addWord(word);
        notifyListeners();
        break;
      }
    }
  }

  void removeWordFromFolder(String folderName, Word word) {
    for (var folder in _folders) {
      if (folder.name == folderName) {
        folder.removeWord(word);
        notifyListeners();
        break;
      }
    }
  }
}

final folderProvider = ChangeNotifierProvider((ref) => FolderNotifier());
