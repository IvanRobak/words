import 'package:flutter/material.dart';
import '../models/word.dart';

class WordExamplesList extends StatefulWidget {
  final Word word;
  final Function(int, String) onUpdate;
  final Function(int) onRemove;
  final Function() onAddExample;

  const WordExamplesList({
    super.key,
    required this.word,
    required this.onUpdate,
    required this.onRemove,
    required this.onAddExample,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WordExamplesListState createState() => _WordExamplesListState();
}

class _WordExamplesListState extends State<WordExamplesList> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers = widget.word.userExamples
        .map((example) => TextEditingController(text: example))
        .toList();
  }

  @override
  void didUpdateWidget(covariant WordExamplesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.userExamples.length != widget.word.userExamples.length) {
      _initializeControllers();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildExampleField(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 2,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controllers[index],
              onChanged: (value) {
                widget.onUpdate(index, value);
              },
              decoration: const InputDecoration(
                hintText: 'Your example',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
              minLines: 1,
              maxLines: null,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                widget.onUpdate(index, value);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Color.fromARGB(40, 255, 255, 255),
            ),
            onPressed: () {
              widget.onRemove(index);
              setState(() {
                _controllers.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.word.userExamples.length; i++)
          _buildExampleField(i),
        ElevatedButton(
          onPressed: () {
            widget.onAddExample();
            setState(() {
              _controllers.add(TextEditingController());
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
          child: const Text('Add Example'),
        ),
      ],
    );
  }
}
