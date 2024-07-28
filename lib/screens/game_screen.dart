import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:words/screens/guess_word_screen.dart';
import 'package:words/screens/guess_image_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Select Game Mode',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250.w,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GuessWordScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  shadowColor: Colors.black,
                  elevation: 10,
                ),
                child: Text(
                  'Guess the Word',
                  style: TextStyle(
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: 250.w,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GuessImageScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  shadowColor: Colors.black,
                  elevation: 10,
                ),
                child: Text(
                  'Guess the Image',
                  style: TextStyle(
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
