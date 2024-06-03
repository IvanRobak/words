import 'package:flutter/material.dart';
import 'package:words/models/word.dart';

class WordDetailScreen extends StatefulWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_handleTyping);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleTyping() {
    setState(() {
      _isTyping = _textController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Card(
          color: const Color(0xFF426CD8),
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 36),
                  Center(
                    child: Text(
                      widget.word.word,
                      style: const TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      widget.word.description,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'My ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          TextSpan(
                            text: widget.word.word,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 165, 38, 29),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: ' is painting.',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (!_isTyping)
                          const Icon(Icons.add, color: Colors.white),
                        if (!_isTyping) const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: const InputDecoration(
                              hintText: 'Add your own example',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'ua',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: const Text('Hobby'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
