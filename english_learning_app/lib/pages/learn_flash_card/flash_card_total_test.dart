import 'dart:async';

import 'package:english_learning_app/controllers/CardsController.dart';
import 'package:english_learning_app/controllers/StatusLearningController.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/models/Cards.dart';
import 'package:english_learning_app/models/StatusLearning.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/pages/learn_typing/typing_test.dart';
import 'package:english_learning_app/pages/menu_topic/action_topics.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FlashCardTotalTest extends StatefulWidget {
  int topicId;
  int statusLearningId;

  FlashCardTotalTest({required this.statusLearningId, required this.topicId, super.key});

  @override
  State<FlashCardTotalTest> createState() => _FlashCardTotalTestState();
}

class _FlashCardTotalTestState extends State<FlashCardTotalTest> {

  final UserAuthController _userAuthController = new UserAuthController();
  final TopicController _topicController = new TopicController();
  final StatusLearningController _statusLearningController = new StatusLearningController();
  final CardsController _cardsController = new CardsController();

  late StatusLearning _statusLearning;
  late Topic _topic;
  late List<Cards> _cards;

  late List<Cards> _unMemoriedCards;
  late List<Cards> _memoried;
  
  bool _showWidgetSwiper = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchStatusLearning();
    fetchTopic();
    fetchListCards();
    getListUnMemoried();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showWidgetSwiper = true;
      });
    });
  }


Future<void> getListUnMemoried() async {
    
    await Future.delayed(const Duration(seconds: 1));
    List<Cards> unMemorieds = [];
    List<Cards> memorieds = [];

    for (Cards card in _cards) {
      if ((_statusLearning.cardMomorized.contains(card.id))) {
        unMemorieds.add(card);
      } else {
        if (!(_statusLearning.memorized.contains(card.id))) {
          memorieds.add(card);
        }
      }
    }

    setState(() {
       _unMemoriedCards = unMemorieds;
       _memoried = memorieds;
    });
  }

  Future<void> fetchListCards() async {
    try {
      List<Cards> cards = await _cardsController.readCardsByTopicId(widget.topicId);
      setState(() {
        _cards = cards;
        print("card: " + cards.length.toString());
      });
      
    } catch (error) {
      print('Failed to fetch list cards: $error');
    }
  }

  Future<void> fetchTopic() async {
    try {
      var topic = (await _topicController.getTopicById(widget.topicId)) as Topic;
      setState(() {
        _topic = topic;
      });
      print(topic.title);
    } catch (error) {
      print('Failed to fetch topic: $error');
    }
  }

  Future<void> fetchStatusLearning() async {
    StatusLearning tmp = await _statusLearningController.readStatusLearningById(widget.statusLearningId);
    setState(() {
      _statusLearning = tmp;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.close, size: 30,),
            onPressed: () {
                Navigator.pop(context);              
              },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
        }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => ActionTopic(widget.topicId)));
            }
          ), 
        ],
        title: Text("1/10", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),

      body: Container(
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        color: Color.fromARGB(255, 226, 226, 226),
        child: Column(
          children: [
            Container(
            child: 
            LinearPercentIndicator(

              animation: true,
              animationDuration: 1000,
              lineHeight: 8,
              percent: 0.5,

              progressColor: mainColor,
              backgroundColor: Colors.grey,
              
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(20, 8, 0, 20),
            alignment: Alignment.centerLeft,

            child: Column(
              children: [
                Container(
                  height: 25,
                ),
                Text("Bạn đang tiến bộ!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                Container(
                  height: 10,
                ),
                Text("Kết quả của bạn:", style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic),),
                Container(
                  height: 25,
                ),
                Row(
                  children: [
                    CircularPercentIndicator(
                      animation: true,
                      animationDuration: 100,
        
                      radius: 45,
                      lineWidth: 10,
                      percent: _unMemoriedCards.length/_cards.length,
                      progressColor: mainColor,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("40%", style: TextStyle(color: mainColor),),

                    ),

                    Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(40, 0, 60, 10),
                                child: Text("Đúng : ", style: TextStyle(color: Colors.blue, fontSize: 20),),
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                ),
                                child: Center(
                                  child: Text("0", style: TextStyle(color: Colors.blue, fontSize: 18),),
                              ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(40, 0, 60, 10),
                                child: Text("Sai    : ", style: TextStyle(color: Colors.red, fontSize: 20),),
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                  color: Colors.red, // Màu của viền
                                  width: 2, // Độ rộng của viền
                                ),
                                ),
                                child: Center(
                                  child: Text("0", style: TextStyle(color: Colors.red, fontSize: 18),),
                              ),
                              ),
                            ],
                          ),
                        ),

                        

                      ],
                    )
                  ]
                ),

                GestureDetector(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(60, 80, 60, 0),
                            height: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.green
                              
                            ),
                            child: Center(
                              child: 
                                Text("Làm bài kiểm tra mới", textAlign:  TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)

                            )
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TypingTest()));
                          },
                        ),

                GestureDetector(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              border: Border.all(
                                width: 2,
                                color: Colors.grey
                              )
                            ),
                            child: Center(
                              child: 
                                Text("Ôn luyện bằng chế độ học", textAlign:  TextAlign.center,style: TextStyle(color:mainColor, fontSize: 18.0, fontWeight: FontWeight.bold, ),)

                            )
                          ),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => FlashCardPage()));
                          },
                        ),
              ],
            ),
          ),
          
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            alignment: Alignment.centerLeft,
            child: Column(

              children: [
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: Text("Đáp án của bạn"),
                ),

                Container(
                  height: 120,
                  width: double.infinity,
                  
                  color: Colors.white,
                ),
                Container(
                  width: double.infinity,
                  height: 30,
                  color: Colors.blue,

                  child: Row(
                    children: [
                      Icon(Icons.close, color: Colors.white,),
                      Text("Đúng", style: TextStyle(color: Colors.white),)
                    ],
                  ),
                )
              ],
            ),
          )

        ],),
      ),
    );

  
  }

  
}