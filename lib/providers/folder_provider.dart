import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words/models/folder.dart';
import 'dart:convert';

import 'package:words/models/word.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FolderNotifier extends ChangeNotifier {
  final List<Folder> _defaultFolders = [
    Folder(name: 'Exam', words: [], color: Colors.indigo),
    Folder(name: 'Home', words: [], color: Colors.green),
    Folder(name: 'Basic', words: [], color: Colors.red),
  ];

  List<Folder> _folders = [];

  FolderNotifier() {
    loadFolders();
  }

  List<Folder> get folders => _folders;

  void addFolder(String name, Color color) {
    _folders.add(Folder(name: name, words: [], color: color));
    _saveFolders();
    notifyListeners();
  }

  void updateFolderName(int index, String name) {
    _folders[index] = Folder(
        name: name, words: _folders[index].words, color: _folders[index].color);
    _saveFolders();
    notifyListeners();
  }

  void updateFolderColor(int index, Color color) {
    _folders[index] = Folder(
        name: _folders[index].name, words: _folders[index].words, color: color);
    _saveFolders();
    notifyListeners();
  }

  void deleteFolder(int index) {
    _folders.removeAt(index);
    _saveFolders();
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
        _saveFolders();
        notifyListeners();
        break;
      }
    }
  }

  void removeWordFromFolder(String folderName, Word word) {
    for (var folder in _folders) {
      if (folder.name == folderName) {
        folder.removeWord(word);
        _saveFolders();
        notifyListeners();
        break;
      }
    }
  }

  void removeWordFromAllFolders(Word word) {
    for (var folder in _folders) {
      folder.removeWord(word);
    }
    _saveFolders();
    notifyListeners();
  }

  Future<void> _saveFolders() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      // Save folders in SharedPreferences (you can expand to Firestore if needed)
      List<String> folderList = _folders.map((folder) {
        return jsonEncode({
          'name': folder.name,
          'color': folder.color.value,
          'words': folder.words.map((word) => word.toJson()).toList(),
        });
      }).toList();
      await prefs.setStringList('folders', folderList);
    }
  }

  Future<void> loadFolders() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (user == null) {
      // If the user is not logged in, load default folders
      _folders = List.from(_defaultFolders);
    } else {
      // Load folders from SharedPreferences
      List<String>? folderList = prefs.getStringList('folders');

      if (folderList == null || folderList.isEmpty) {
        _folders = List.from(_defaultFolders);
        await _saveFolders(); // Save default folders to SharedPreferences
      } else {
        _folders = folderList.map((folderStr) {
          final Map<String, dynamic> folderMap = jsonDecode(folderStr);
          return Folder(
            name: folderMap['name'],
            color: Color(folderMap['color']),
            words: (folderMap['words'] as List<dynamic>)
                .map((wordMap) => Word.fromJson(wordMap))
                .toList(),
          );
        }).toList();
      }
    }

    notifyListeners();
  }
}

final folderProvider = ChangeNotifierProvider((ref) => FolderNotifier());
