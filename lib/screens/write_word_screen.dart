import 'package:flutter/material.dart';
import 'package:words/models/word.dart';
import 'package:words/widgets/write_word_game_card.dart';

class WriteWordScreen extends StatefulWidget {
  final Word word;

  const WriteWordScreen({super.key, required this.word});
  @override
  WriteWordScreenState createState() => WriteWordScreenState();
}

class WriteWordScreenState extends State<WriteWordScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _feedback;
  bool _showExample = false;

  void _toggleExample() {
    setState(() {
      _showExample = !_showExample;
    });
  }

  void _checkAnswer() {
    if (_controller.text.trim().toLowerCase() ==
        widget.word.word.toLowerCase()) {
      setState(() {
        _feedback = 'Correct!';
      });
    } else {
      setState(() {
        _feedback = 'Try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Write the Word',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WriteWordGameCard(
          word: widget.word,
          imageUrl: widget.word.imageUrl,
          showExample: _showExample,
          onToggleExample: _toggleExample,
          controller: _controller,
          onSubmit: _checkAnswer,
          feedback: _feedback,
        ),
      ),
    );
  }
}
