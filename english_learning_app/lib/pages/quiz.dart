import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {

  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<String> choices = [];

  @override
  void initState() {
    super.initState();
    choices.addAll([...generateOtherChoices()]); //create test list first
    choices.shuffle();
  }

  List<String> generateOtherChoices() {
    //generate choices for the word
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ENGLISH WORD'),
          SizedBox(height: 16),
          ...choices.map((choice) => QuizChoice(text: choice)).toList(),
        ],
      ),
    );
  }
}

class QuizChoice extends StatelessWidget {
  final String text;

  const QuizChoice({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        //correct -> green, uncorrect -> red, show correct answer
      },
      child: Text(text),
    );
  }
}

//complete basic interface
//complete basic funtion (add score), create test list
//decorate
