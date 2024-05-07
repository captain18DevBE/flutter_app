import 'package:flutter/material.dart';

class FlashCardPage extends StatefulWidget {
  const FlashCardPage({super.key});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  bool showEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            setState(() {
              showEnglish = !showEnglish;
            });
          },
          child: Text(
            showEnglish ? 'ENGLISH WORD' : 'VIETNAMESE WORD',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

//Add nav bar to change between flashcard, quiz, type
//Add list of words and swipe function to change word
//Add decoration