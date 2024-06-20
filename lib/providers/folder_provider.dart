import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words/models/folder.dart';
import 'package:words/models/word.dart';

class FolderNotifier extends ChangeNotifier {
  final List<Folder> _folders = [];

  List<Folder> get folders => _folders;

  void addFolder(String name, Color color) {
    _folders.add(Folder(name: name, words: [], color: color));
    notifyListeners();
  }

  void updateFolderName(int index, String name) {
    _folders[index] = Folder(
        name: name, words: folders[index].words, color: folders[index].color);
    notifyListeners();
  }

  void updateFolderColor(int index, Color color) {
    _folders[index] = Folder(
        name: folders[index].name, words: folders[index].words, color: color);
    notifyListeners();
  }

  void deleteFolder(int index) {
    _folders.removeAt(index);
    notifyListeners();
  }

  void addWordToFolder(String folderName, Word word) {
    // Спочатку видаляємо слово з будь-якої існуючої папки
    for (var folder in _folders) {
      if (folder.words.contains(word)) {
        folder.removeWord(word);
      }
    }

    // Додаємо слово до нової папки
    for (var folder in _folders) {
      if (folder.name == folderName) {
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

  void removeWordFromAllFolders(Word word) {
    for (var folder in _folders) {
      folder.removeWord(word);
    }
    notifyListeners();
  }
}

final folderProvider = ChangeNotifierProvider((ref) => FolderNotifier());
