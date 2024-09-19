import 'package:equatable/equatable.dart';
import 'package:words/models/folder.dart';

abstract class FolderState extends Equatable {
  const FolderState();

  @override
  List<Object?> get props => [];
}

// Початковий стан, коли папки ще не завантажені
class FolderInitial extends FolderState {
  @override
  List<Object?> get props =>
      []; // Необхідно, навіть якщо тут немає властивостей
}

// Стан після завантаження папок
class FoldersLoaded extends FolderState {
  final List<Folder> folders;

  const FoldersLoaded(this.folders);

  @override
  List<Object?> get props => [folders]; // Порівнюємо папки
}
