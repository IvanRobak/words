import 'package:flutter/material.dart';
import 'package:words/models/folder.dart';

class BottomSection extends StatelessWidget {
  final bool isTranslationVisible;
  final String? translation;
  final String? selectedFolder;
  final List<Folder> folders;
  final Function(String?) onFolderChanged;
  final VoidCallback toggleTranslation;

  const BottomSection({
    super.key,
    required this.isTranslationVisible,
    this.translation,
    this.selectedFolder,
    required this.folders,
    required this.onFolderChanged,
    required this.toggleTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: toggleTranslation,
          child: Text(
            isTranslationVisible
                ? (translation ?? 'Translation not available')
                : 'ua',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 16,
            ),
          ),
        ),
        DropdownButton<String>(
          hint: Text(
            "Folder",
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onChanged: onFolderChanged,
          dropdownColor: Theme.of(context).colorScheme.primary,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
