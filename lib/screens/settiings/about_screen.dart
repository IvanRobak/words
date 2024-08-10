import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Text(
              'Welcome to our app! This app is designed to help you learn English words using flashcards.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 50),
            Text(
              'Key Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- Learn the most important English words',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Sort words into custom folders',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Test your knowledge with quizzes',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 50),
            Text(
              'Contact Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: 'This app is developed by ',
                style: TextStyle(fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Ivan Robak',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '. We strive to make it as useful and user-friendly as possible.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'If you have any questions or suggestions, please contact us at ivan.robak@gmail.com.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Text(
              'Thank you for using our app!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
