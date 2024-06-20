import 'package:flutter/material.dart';

class BottomSection extends StatelessWidget {
  final bool isTranslationVisible;
  final String? translation;
  final String? selectedFolder;
  final List<String> folders;
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        DropdownButton<String>(
          hint: const Text(
            "Folder",
            style: TextStyle(color: Colors.white),
          ),
          value: selectedFolder,
          items: [
            const DropdownMenuItem<String>(
              value: 'None',
              child: Text('None'),
            ),
            ...folders.map((folder) => DropdownMenuItem<String>(
                  value: folder,
                  child: Text(folder),
                )),
          ],
          onChanged: onFolderChanged,
          dropdownColor: Theme.of(context).colorScheme.primary,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
