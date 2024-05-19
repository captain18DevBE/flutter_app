
import 'package:english_learning_app/controllers/CardsController.dart';
import 'package:english_learning_app/controllers/StatisticController.dart';
import 'package:english_learning_app/controllers/StatusLearningController.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/models/Cards.dart';
import 'package:english_learning_app/models/Statistic.dart';
import 'package:english_learning_app/models/StatusLearning.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/pages/learn_flash_card/flashcard.dart';
import 'package:english_learning_app/pages/learn_typing/ranking.dart';
import 'package:english_learning_app/pages/learn_typing/typing_test.dart';
import 'package:english_learning_app/pages/menu_topic/action_topics.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TypingTotalTest extends StatefulWidget {
  int topicId;
  int statusLearningId;
  int amountUnMemoriedCard;
  int amountMemoricard;
  int statisticId;
  final double point;

  TypingTotalTest({required this.statisticId, required this.topicId, required this.statusLearningId, required this.amountMemoricard, required this.amountUnMemoriedCard , required this.point,super.key});

  @override
  State<TypingTotalTest> createState() => _TypingTotalTestState();
}

class _TypingTotalTestState extends State<TypingTotalTest> {
  
  final UserAuthController _userAuthController = new UserAuthController();
  final TopicController _topicController = new TopicController();
  final CardsController _cardsController = new CardsController();
  final PageController _pageController = new PageController();
  final StatusLearningController _statusLearningController = new StatusLearningController();
  final StatisticController _statisticController = new StatisticController();

  late User _user;
  late Topic _topic;
  late List<Cards> _cards;
  late StatusLearning _statusLearning;

  late List<Cards> _unMemoriedCards;
  late List<Cards> _memoried;

  bool _showWidget = false;
  Statistic? _statistic;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchCurrentUser();
    fetchTopic(widget.topicId);
    fetchListCards(widget.topicId);
    fetchStatusLearning();
    getListUnMemoried();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showWidget = true;
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

    //unMemorieds.add(finishLearn);
    setState(() {
       _unMemoriedCards = unMemorieds;
       _memoried = memorieds;
    });
  }

  Future<void> fetchStatusLearning() async {
    StatusLearning tmp = await _statusLearningController.readStatusLearningById(widget.statusLearningId);

    setState(() {
      _statusLearning = tmp;
    });
  }

  Future<void> fetchCurrentUser() async {
    try {
      User? current = await _userAuthController.getCurrentUser();
      setState(() {
        if (current != null) {
          _user = current;
        }
      });
    } catch (error) {
      print("Have problem load user ${error}");
    }
  }

  Future<void> fetchTopic(int topicId) async {
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

  Future<void> fetchListCards(int topicId) async {
    try {
      List<Cards> cards = await _cardsController.readCardsByTopicId(topicId);
      setState(() {
        _cards = cards;
      });

    } catch (error) {
      print('Failed to fetch list cards: $error');
    }

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
              //Navigator.push(context, MaterialPageRoute(builder:(context) => ActionTopic()));
            }
          ), 
        ],
        title: Text(_showWidget ? (widget.amountMemoricard.toString() + "/" + widget.amountUnMemoriedCard.toString()) : "1/10", style: TextStyle(color: Colors.white),),
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
                Text("You're making progress!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                Container(
                  height: 10,
                ),
                Text("Your total test:", style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic),),
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
                      percent: widget.point,
                      progressColor: mainColor,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text((widget.point * 100).toString() + "%", style: TextStyle(color: mainColor),),

                    ),

                    Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(40, 0, 60, 10),
                                child: Text("True   : ", style: TextStyle(color: Colors.blue, fontSize: 20),),
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
                                  child: Text(_showWidget ? widget.amountMemoricard.toString() : "0", style: TextStyle(color: Colors.blue, fontSize: 18),),
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
                                child: Text( "Failed: ", style: TextStyle(color: Colors.red, fontSize: 20),),
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
                                  child: Text(_showWidget ? (widget.amountUnMemoriedCard - widget.amountMemoricard).toString() : "0", style: TextStyle(color: Colors.red, fontSize: 18),),
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
                                Text("New Test", textAlign:  TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)

                            )
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TypingTest(topicId: widget.topicId, statusLearningId: widget.statusLearningId,)));
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
                                Text("View Ranking", textAlign:  TextAlign.center,style: TextStyle(color:mainColor, fontSize: 18.0, fontWeight: FontWeight.bold, ),)

                            )
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: 
                            (context) => Ranking(
                              topicId: widget.topicId, 
                              statusLearningId: widget.statusLearningId, 
                              amountMemoricard: widget.amountMemoricard, 
                              amountUnMemoriedCard: widget.amountUnMemoriedCard, 
                              statisticId: widget.statisticId, 
                              point: widget.point,
                            )));
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