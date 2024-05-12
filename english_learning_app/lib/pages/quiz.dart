import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'all_constants.dart';
import 'ques_ans_file.dart';
import 'reusable_card.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickalert/quickalert.dart';


class QuizPage extends StatefulWidget {

  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<String> choices = [];


var questions = [];
  late int index;
  int trying = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;

  final _quizBox = Hive.box('appBox');

  void fetchData() {
    questions = [
      {
        "question": "What is Undo shortcut in computer?",
        "options": ["ctl+y", "ctl+z", "ctl+s", "ctl+p"],
        "answer": 1
      },
      {
        "question": "What is Redo shortcut in computer?",
        "options": ["ctl+y", "ctl+z", "ctl+s", "ctl+p"],
        "answer": 0
      },
      {
        "question": "which is not a program language?",
        "options": ["python", "dart", "html", "typescript"],
        "answer": 2
      },
      {
        "question": "flutter's programming language?",
        "options": ["python", "dart", "swift", "java"],
        "answer": 1
      },
      {
        "question": "backend python framework?",
        "options": ["flask", "fast api", "django", "all"],
        "answer": 3
      }
    ];
  }

  @override
  void initState() {
    super.initState();
    _quizBox.put('chance', 3);
    fetchData();
    index = Random().nextInt(questions.length);
  }

  void validate(choice) {
    if (choice == questions[index]["answer"]) {
      setState(() {
        correctAnswers++;
        trying++;
      });
    } else {
      setState(() {
        incorrectAnswers++;
        trying++;
        _quizBox.put('chance', _quizBox.get('chance') - 1);
      });
    }

    if (trying == questions.length || _quizBox.get('chance') == 0) {
      Navigator.pushNamed(context, '/result', arguments: {
        "correctAnswers": correctAnswers,
        "incorrectAnswers": incorrectAnswers,
        "totalAnswers": questions.length
      });
    }
    index = Random().nextInt(questions.length);
  }
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // const SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     GestureDetector(
              //         onTap: () {
              //           Navigator.pushNamed(context, '/home');
              //         },
              //         child: const Icon(
              //           Icons.keyboard_backspace_rounded,
              //           color: Colors.red,
              //         )),
              //     GestureDetector(
              //       child: const Icon(Icons.help_outlined, color: Colors.red),
              //       onTap: () {
              //         QuickAlert.show(
              //           context: context,
              //           type: QuickAlertType.info,
              //           text: 'answer ${questions.length} computer questions.',
              //           confirmBtnColor: Colors.red,
              //         );
              //       },
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 620,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/quiz.jpg',
                          width: 300,
                          height: 300,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        questions[index]["question"],
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height:25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                validate(0);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(mainColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)))),
                              child: Text(questions[index]["options"][0], style: TextStyle(color: Colors.white)),
                            )),
                        SizedBox(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  validate(1);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(mainColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)))),
                                child: Text(questions[index]["options"][1], style: TextStyle(color: Colors.white))))
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                validate(2);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(mainColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)))),
                              child: Text(questions[index]["options"][2], style: TextStyle(color: Colors.white)),
                            )),
                        SizedBox(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  validate(3);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(mainColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)))),
                                child: Text(questions[index]["options"][3], style: TextStyle(color: Colors.white))))
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        _quizBox.get("chance").toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainColor),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // }
      // else {
      //   return const Center(
      //     child: CircularProgressIndicator(),
    );
  }
}

//complete basic interface
//complete basic funtion (add score), create test list
//decorate
