// filter_bar.dart
import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final int columns;
  final List<int> columnOptions;
  final TextEditingController searchController;
  final Function(int?) onColumnsChanged;
  final Function(String) onSearchChanged;

  const FilterBar({
    super.key,
    required this.columns,
    required this.columnOptions,
    required this.searchController,
    required this.onColumnsChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<int>(
            value: columns,
            items: columnOptions.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              );
            }).toList(),
            onChanged: onColumnsChanged,
          ),
          const SizedBox(width: 120),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(5),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary), // Колір підкреслення коли не в фокусі
                  ),
                ),
                onChanged: onSearchChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
