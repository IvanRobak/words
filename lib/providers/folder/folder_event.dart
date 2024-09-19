import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:words/models/word.dart';

abstract class FolderEvent extends Equatable {
  const FolderEvent();

  @override
  List<Object?> get props => [];
}

class LoadFoldersEvent extends FolderEvent {}

class AddFolderEvent extends FolderEvent {
  final String name;
  final Color color;
  const AddFolderEvent(this.name, this.color);
}

class UpdateFolderNameEvent extends FolderEvent {
  final int index;
  final String name;
  const UpdateFolderNameEvent(this.index, this.name);
}

class UpdateFolderColorEvent extends FolderEvent {
  final int index;
  final Color color;
  const UpdateFolderColorEvent(this.index, this.color);
}

class DeleteFolderEvent extends FolderEvent {
  final int index;
  const DeleteFolderEvent(this.index);
}

class AddWordToFolderEvent extends FolderEvent {
  final String folderName;
  final Word word;
  const AddWordToFolderEvent(this.folderName, this.word);
}

class RemoveWordFromFolderEvent extends FolderEvent {
  final String folderName;
  final Word word;
  const RemoveWordFromFolderEvent(this.folderName, this.word);
}

class RemoveWordFromAllFoldersEvent extends FolderEvent {
  final Word word;
  const RemoveWordFromAllFoldersEvent(this.word);
}

// Інші події...