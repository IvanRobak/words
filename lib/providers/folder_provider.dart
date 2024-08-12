import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words/models/folder.dart';
import 'dart:convert';

import 'package:words/models/word.dart';

class FolderNotifier extends ChangeNotifier {
  final List<Folder> _folders = [
    Folder(name: 'Exam', words: [], color: Colors.indigo),
    Folder(name: 'Home', words: [], color: Colors.green),
    Folder(name: 'Basic', words: [], color: Colors.red),
  ];

  FolderNotifier() {
    _loadFoldersFromPrefs();
  }

  List<Folder> get folders => _folders;

  void addFolder(String name, Color color) {
    _folders.add(Folder(name: name, words: [], color: color));
    _saveFoldersToPrefs();
    notifyListeners();
  }

  void updateFolderName(int index, String name) {
    _folders[index] = Folder(
        name: name, words: folders[index].words, color: folders[index].color);
    _saveFoldersToPrefs();
    notifyListeners();
  }

  void updateFolderColor(int index, Color color) {
    _folders[index] = Folder(
        name: folders[index].name, words: folders[index].words, color: color);
    _saveFoldersToPrefs();
    notifyListeners();
  }

  void deleteFolder(int index) {
    _folders.removeAt(index);
    _saveFoldersToPrefs();
    notifyListeners();
  }

  void addWordToFolder(String folderName, Word word) {
    for (var folder in _folders) {
      if (folder.words.contains(word)) {
        folder.removeWord(word);
      }
    }

    for (var folder in _folders) {
      if (folder.name == folderName) {
        folder.addWord(word);
        _saveFoldersToPrefs();
        notifyListeners();
        break;
      }
    }
  }

  void removeWordFromFolder(String folderName, Word word) {
    for (var folder in _folders) {
      if (folder.name == folderName) {
        folder.removeWord(word);
        _saveFoldersToPrefs();
        notifyListeners();
        break;
      }
    }
  }

  void removeWordFromAllFolders(Word word) {
    for (var folder in _folders) {
      folder.removeWord(word);
    }
    _saveFoldersToPrefs();
    notifyListeners();
  }

  Future<void> _saveFoldersToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> folderList = _folders.map((folder) {
      return jsonEncode({
        'name': folder.name,
        'color': folder.color.value,
        'words': folder.words.map((word) => word.toJson()).toList(),
      });
    }).toList();
    await prefs.setStringList('folders', folderList);
  }

  Future<void> _loadFoldersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? folderList = prefs.getStringList('folders');

    if (folderList == null || folderList.isEmpty) {
      await _saveFoldersToPrefs();
    } else {
      _folders.clear();
      _folders.addAll(folderList.map((folderStr) {
        final Map<String, dynamic> folderMap = jsonDecode(folderStr);
        return Folder(
          name: folderMap['name'],
          color: Color(folderMap['color']),
          words: (folderMap['words'] as List<dynamic>)
              .map((wordMap) => Word.fromJson(wordMap))
              .toList(),
        );
      }).toList());
    }
    notifyListeners();
  }
}

final folderProvider = ChangeNotifierProvider((ref) => FolderNotifier());
