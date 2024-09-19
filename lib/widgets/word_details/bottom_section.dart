import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:words/providers/folder/folder_bloc.dart';
import 'package:words/providers/folder/folder_state.dart';

class BottomSection extends StatelessWidget {
  final bool isTranslationVisible;
  final String? translation;
  final String? selectedFolder;
  final Function(String?) onFolderChanged;
  final VoidCallback toggleTranslation;
  final String selectedLanguage;

  const BottomSection({
    super.key,
    required this.isTranslationVisible,
    this.translation,
    this.selectedFolder,
    required this.onFolderChanged,
    required this.toggleTranslation,
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderBloc, FolderState>(
      builder: (context, state) {
        if (state is FoldersLoaded) {
          final folders = state.folders;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: toggleTranslation,
                child: Text(
                  isTranslationVisible
                      ? (translation ?? 'Translation not available')
                      : selectedLanguage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
              DropdownButton<String>(
                hint: Text(
                  "Folder",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                value: selectedFolder,
                items: [
                  const DropdownMenuItem<String>(
                    value: 'None',
                    child: Text('None'),
                  ),
                  ...folders.map(
                    (folder) => DropdownMenuItem<String>(
                      value: folder.name,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            color: folder.color,
                          ),
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 80),
                            child: Text(
                              folder.name.length > 12
                                  ? '${folder.name.substring(0, 12)}...'
                                  : folder.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: onFolderChanged,
                dropdownColor: Theme.of(context).colorScheme.surface,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ],
          );
        } else if (state is FolderInitial) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('Failed to load folders.'));
        }
      },
    );
  }
}
