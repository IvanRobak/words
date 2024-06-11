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
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.grid_view,
                  color: columns == 2
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey,
                ),
                onPressed: () {
                  onColumnsChanged(2);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.view_module,
                  color: columns == 3
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey,
                ),
                onPressed: () {
                  onColumnsChanged(3);
                },
              ),
            ],
          ),
          const SizedBox(width: 50),
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
