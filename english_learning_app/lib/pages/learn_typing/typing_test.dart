
import 'package:english_learning_app/controllers/CardsController.dart';
import 'package:english_learning_app/controllers/StatisticController.dart';
import 'package:english_learning_app/controllers/StatusLearningController.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/models/Cards.dart';
import 'package:english_learning_app/models/Statistic.dart';
import 'package:english_learning_app/models/StatusLearning.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/pages/learn_typing/typing_totals.dart';
import 'package:english_learning_app/pages/menu_topic/action_topics.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TypingTest extends StatefulWidget {
  int topicId;
  int statusLearningId;
  TypingTest({required this.topicId, required this.statusLearningId, super.key});

  @override
  State<TypingTest> createState() => _TypingTestState();
}

class _TypingTestState extends State<TypingTest> {

  final UserAuthController _userAuthController = new UserAuthController();
  final TopicController _topicController = new TopicController();
  final StatusLearningController _statusLearningController = new StatusLearningController();
  final CardsController _cardsController = new CardsController();
  final StatisticController _statisticController = new StatisticController();

  final TextEditingController _txtAnswerController = TextEditingController();

  late User _user;
  late Topic _topic;
  late List<Cards> _cards;
  late StatusLearning _statusLearning;

  late int _statisticId;

  late List<Cards> _unMemoriedCards;
  late List<Cards> _memoried;

  late List<String> _lstAnswer;
  int _countAnswerSuccess = 0;
  int _countAnswerWrong = 0;
  int _questionSelected= 0;
  


  double _point = 0.0;

  bool _showWidget = false;
  Statistic? _statistic;

  @override
  void dispose() {
    // TODO: implement dispose
    _txtAnswerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchCurrentUser();
    fetchTopic(widget.topicId);
    fetchListCards(widget.topicId);
    fetchStatusLearning();
    getListUnMemoried();
    getNextStatisticId();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _statistic = _getStatistic(_user.email!, widget.topicId) as Statistic;

      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showWidget = true;
      });
    });
  }

  Future<void> getNextStatisticId() async {
    int result = await _statisticController.amountStatistic() + 1;
    setState(() {
      _statisticId =  result;
    });
  }
  
  Future<Statistic> _getStatistic(String email, int topicId) async {
    List<Statistic> lst = await _statisticController.readStatisticByEmailAndTopicId(email, topicId);
    Statistic result = lst.first;

    return result;
  }

  Future<void> fetchStatusLearning() async {
    StatusLearning tmp = await _statusLearningController.readStatusLearningById(widget.statusLearningId);

    setState(() {
      _statusLearning = tmp;
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

      List<String> tmpLstAnswer = [];

      for (Cards card in cards) {
        tmpLstAnswer.add(card.mean);
      }

      setState(() {
        _lstAnswer = tmpLstAnswer;
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
        title: Text("1/10", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),

      body: Container(
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        
        child: Column(children: [
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
            margin: EdgeInsets.fromLTRB(25, 60, 25, 10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: Text("Mean:", style: TextStyle(fontSize: 18),),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 40),
                  child: Text(_showWidget ? _cards[_questionSelected].mean : "Loading...", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _txtAnswerController,
                        decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter term this vocabulary',
                        ),
                      ),
                    ),
                    
                    IconButton(
                      onPressed: checkAnswer, 
                      icon: Icon(Icons.arrow_circle_up_rounded),
                    
                    )
                ],
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
                      Text("Finish", textAlign:  TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)

                  )
                ),
                onTap: () {
                  addStatistic(_user.email!, widget.topicId, _point);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: 
                    (context) => TypingTotalTest(
                      point: _point, 
                      topicId: widget.topicId, 
                      statusLearningId: widget.statusLearningId, 
                      amountMemoricard: _countAnswerSuccess, 
                      amountUnMemoriedCard: _cards.length, 
                      statisticId: _statisticId,
                    )));
                },
            ),

              ],
            ),
          )
        ],),
      ),
    );

    
  }

void checkAnswer() async {

  if(_questionSelected >= _cards.length - 1) {
    await addStatistic(_user.email!, widget.topicId, _point);
    Navigator.pop(context);
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => TypingTotalTest(
        topicId: widget.topicId, 
        statusLearningId: widget.statusLearningId, 
        amountMemoricard: _countAnswerSuccess, 
        amountUnMemoriedCard: (_cards.length - _countAnswerSuccess), 
        point: _point, 
        statisticId: _statisticId,
      )));
  }

  String answer = _txtAnswerController.text.toLowerCase();
  String term = _cards[_questionSelected].term.toLowerCase();

  setState(() {
    _questionSelected += 1;
    _countAnswerSuccess += answer == term ? 1 : 0;
    _countAnswerWrong += answer == term ? 0 : 1;

    _point = (_countAnswerSuccess/_cards.length);
  });

  _txtAnswerController.text = "";

  print(answer);
  print(term);
  print(_countAnswerSuccess);
  print(_countAnswerWrong);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: answer == term ? Colors.green : Colors.red,
        title: Text(
          answer == term ? 'Correct!' : 'Incorrect',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          answer == term ? 'Your answer matches the term.' : 'The correct term is: $term',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );


  }

  Future<void> addStatistic(String createBy, int topicId, double percenRate) async {
    Statistic statistic = new Statistic(id: 999, topicId: topicId, createBy: createBy, percenRate: percenRate, numOfStudy: 1);
    await _statisticController.addStatistic(statistic);
  }

}

