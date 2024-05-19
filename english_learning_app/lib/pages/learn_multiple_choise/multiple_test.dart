
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
import 'package:percent_indicator/linear_percent_indicator.dart';

class MultipleTest extends StatefulWidget {
  int topicId;
  int statusLearningId;
  MultipleTest({required this.topicId, required this.statusLearningId, super.key});

  @override
  State<MultipleTest> createState() => _MultipleTestState();
}


class _MultipleTestState extends State<MultipleTest> {

  final UserAuthController _userAuthController = new UserAuthController();
  final TopicController _topicController = new TopicController();
  final CardsController _cardsController = new CardsController();
  final PageController _pageController = new PageController();
  final StatusLearningController _statusLearningController = new StatusLearningController();
  final StatisticController _statisticController = new StatisticController();

  late User _user;
  late Topic _topic;
  late List<Cards> _cards;
  late int _activePage = 2;
  late StatusLearning _statusLearning;

  late List<Cards> _unMemoriedCards;
  late List<Cards> _memoried;

  late int _amountUnMemoriedCard;
  late int _amountMemoricard;

  late List<String> _lstAnswer;

  int _questionSelected= 0;
  int _countAnswerSuccess = 0;
  late List<String> _fourAnswer;

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
        _fourAnswer = randomFourAnswer(_lstAnswer);
        _statistic = _getStatistic(_user.email!, widget.topicId) as Statistic;

      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showWidget = true;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
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

      _amountUnMemoriedCard = _unMemoriedCards.length;
      _amountMemoricard = _memoried.length;
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
        title: Text("Multiple Choise", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.close),
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

      ),

      body: Container(
        // color: Color.fromARGB(255, 226, 226, 226),
        child: Column(
          children: [
            Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 0),

            // width: double.infinity,
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
              margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
              alignment: Alignment.centerLeft,
              height: 200,
              width: double.infinity,
              child: Text("Term: " + _unMemoriedCards[_questionSelected].term, style: TextStyle(fontSize: 20),),
            ),

            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                height: 80,
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
                    Text(_showWidget ? _fourAnswer[0] : "Answer 1", textAlign:  TextAlign.center,style: TextStyle(color:Colors.black, fontSize: 18.0, fontWeight: FontWeight.normal, ),)

                )
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => FlashCardPage()));
                showAlertDialog(context, _unMemoriedCards[_questionSelected].mean, _fourAnswer[0]);

              },
            ),
                      
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                height: 80,
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
                    Text(_showWidget ? _fourAnswer[1] : "Answer 1", textAlign:  TextAlign.center,style: TextStyle(color:Colors.black, fontSize: 18.0, fontWeight: FontWeight.normal, ),)

                )
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {}));
                showAlertDialog(context, _unMemoriedCards[_questionSelected].mean, _fourAnswer[1]);

              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                height: 80,
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
                    Text(_showWidget ? _fourAnswer[2] : "Answer 1", textAlign:  TextAlign.center,style: TextStyle(color:Colors.black, fontSize: 18.0, fontWeight: FontWeight.normal, ),)

                )
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {}));
                showAlertDialog(context, _unMemoriedCards[_questionSelected].mean, _fourAnswer[2]);

              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                height: 80,
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
                    Text(_showWidget ? _fourAnswer[3] : "Answer 1", textAlign:  TextAlign.center,style: TextStyle(color:Colors.black, fontSize: 18.0, fontWeight: FontWeight.normal, ),)

                )
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {}));
                showAlertDialog(context, _unMemoriedCards[_questionSelected].mean, _fourAnswer[3]);
              },
            ),
          ],
        ),
      ),

    );
  }

  showAlertDialog(BuildContext context, String answer, String wrongAnswer) {
    
    setState(() {
      if (answer == wrongAnswer) {
        setState(() {
          _countAnswerSuccess += 1;
        });
      }
      if (_questionSelected >= _unMemoriedCards.length-1) {
        loadTotalTestPage();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => TypingTotalTest( point: 0.5, topicId: widget.topicId, statusLearningId: widget.statusLearningId, amountMemoricard: _countAnswerSuccess, amountUnMemoriedCard: _amountUnMemoriedCard,)));
      }
      if (_questionSelected < _unMemoriedCards.length && _questionSelected <= _unMemoriedCards.length-1) {
        _fourAnswer = randomFourAnswer(_lstAnswer);
        _questionSelected += 1;
      }
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {

        final alertWrong = AlertDialog(
          backgroundColor: Colors.red,
          title: Text('Wrong answer', style: TextStyle(color: Colors.white),),
          content: Text('Wrong answer!', style: TextStyle(color: Colors.white),),
        );
        
        final alertSuccess = AlertDialog(
          backgroundColor: Colors.green,
          title: Text('Success!', style: TextStyle(color: Colors.white),),
          content: Text('Success!', style: TextStyle(color: Colors.white),),
        );

        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        if (answer == wrongAnswer) {
          return alertSuccess;
        }
        return alertWrong;
      },
    );
  }

  List<String> randomFourAnswer(List<String> lstAnwer) {
    var tmp = <String>[];
    lstAnwer.shuffle();

    if (lstAnwer.length >= 4) {
      tmp = lstAnwer.sublist(0, 3);
      tmp.add(_cards[_questionSelected].mean);
      return tmp;
    } else {
      tmp =  lstAnwer.sublist(0, 2);
      tmp.add('Wrong Anser 1');
      tmp.add(_cards[_questionSelected].mean);
      return tmp;
    }
  }

  void loadTotalTestPage() async {
    if (! (await _checkExistStatistic(_user.email!, widget.topicId))) {
      addStatistic(_user.email!, widget.topicId, _countAnswerSuccess/_cards.length);
    } else {
      if (_statistic != null) {
        setState(() {
          _statistic!.numOfStudy = _statistic!.numOfStudy + 1;
        });
        updateStatistic(_statistic!);
      }
    }
  }

  Future<bool> _checkExistStatistic(String create_by, int topicId) async {
    var tmpStatus = await _statisticController.checkExist(create_by, topicId);
    return tmpStatus;
  }

  Future<void> addStatistic(String createBy, int topicId, double percenRate) async {
    Statistic statistic = new Statistic(id: 999, topicId: topicId, createBy: createBy, percenRate: percenRate, numOfStudy: 1);
    await _statisticController.addStatistic(statistic);
  }

  Future<void> updateStatistic(Statistic data) async {
    await _statisticController.updateStatistic(data);
  }

  Future<Statistic> _getStatistic(String email, int topicId) async {
    List<Statistic> lst = await _statisticController.readStatisticByEmailAndTopicId(email, topicId);
    Statistic result = lst.first;

    return result;
  }
}