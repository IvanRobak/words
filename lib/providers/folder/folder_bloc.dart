import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:words/models/folder.dart';
import 'package:words/models/word.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:words/providers/folder/folder_event.dart';
import 'package:words/providers/folder/folder_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  List<Folder> _folders = [];
  final List<Folder> _defaultFolders = [
    Folder(name: 'Exam', words: [], color: Colors.indigo),
    Folder(name: 'Home', words: [], color: Colors.green),
    Folder(name: 'Basic', words: [], color: Colors.red),
  ];

  FolderBloc() : super(FolderInitial()) {
    on<LoadFoldersEvent>(_onLoadFolders);
    on<AddFolderEvent>(_onAddFolder);
    on<UpdateFolderNameEvent>(_onUpdateFolderName);
    on<UpdateFolderColorEvent>(_onUpdateFolderColor);
    on<DeleteFolderEvent>(_onDeleteFolder);
    on<AddWordToFolderEvent>(_onAddWordToFolder);
    on<RemoveWordFromFolderEvent>(_onRemoveWordFromFolder);
    on<RemoveWordFromAllFoldersEvent>(_onRemoveWordFromAllFolders);
  }

  Future<void> _onLoadFolders(
      LoadFoldersEvent event, Emitter<FolderState> emit) async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    List<String>? folderList = prefs.getStringList('folders');

    if (user == null || folderList == null || folderList.isEmpty) {
      _folders = List.from(_defaultFolders);
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

    emit(FoldersLoaded(_folders));
  }

  Future<void> _onAddFolder(
      AddFolderEvent event, Emitter<FolderState> emit) async {
    _folders.add(Folder(name: event.name, words: [], color: event.color));
    await _saveFolders();
    emit(FoldersLoaded(_folders));
  }

  Future<void> _onUpdateFolderName(
      UpdateFolderNameEvent event, Emitter<FolderState> emit) async {
    _folders[event.index] = Folder(
        name: event.name,
        words: _folders[event.index].words,
        color: _folders[event.index].color);
    await _saveFolders();
    emit(FoldersLoaded(_folders));
  }

  Future<void> _onUpdateFolderColor(
      UpdateFolderColorEvent event, Emitter<FolderState> emit) async {
    _folders[event.index] = Folder(
        name: _folders[event.index].name,
        words: _folders[event.index].words,
        color: event.color);
    await _saveFolders();
    emit(FoldersLoaded(_folders));
  }

  Future<void> _onDeleteFolder(
      DeleteFolderEvent event, Emitter<FolderState> emit) async {
    _folders.removeAt(event.index);
    await _saveFolders();
    emit(FoldersLoaded(_folders));
  }

  Future<void> _onAddWordToFolder(
      AddWordToFolderEvent event, Emitter<FolderState> emit) async {
    for (var folder in _folders) {
      if (folder.words.contains(event.word)) {
        folder.removeWord(event.word);
      }
    }

    for (var folder in _folders) {
      if (folder.name == event.folderName) {
        folder.addWord(event.word);
        _saveFolders();
        emit(FoldersLoaded(_folders));
        break;
      }
    }
  }

  Future<void> _onRemoveWordFromFolder(
      RemoveWordFromFolderEvent event, Emitter<FolderState> emit) async {
    for (var folder in _folders) {
      if (folder.name == event.folderName) {
        folder.removeWord(event.word);
        _saveFolders();
        emit(FoldersLoaded(_folders));
        break;
      }
    }
  }

  Future<void> _onRemoveWordFromAllFolders(
      RemoveWordFromAllFoldersEvent event, Emitter<FolderState> emit) async {
    for (var folder in _folders) {
      folder.removeWord(event.word);
    }
    _saveFolders();
    emit(FoldersLoaded(_folders));
  }

  Future<void> _saveFolders() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
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
}
