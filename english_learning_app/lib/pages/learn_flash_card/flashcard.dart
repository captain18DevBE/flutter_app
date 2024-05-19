import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:english_learning_app/controllers/CardsController.dart';
import 'package:english_learning_app/controllers/StatusLearningController.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/models/Cards.dart';
import 'package:english_learning_app/models/StatusLearning.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/pages/learn_flash_card/flash_card_total_test.dart';
import 'package:english_learning_app/pages/learn_flash_card/reusable_card.dart';
import 'package:english_learning_app/pages/learn_typing/typing_totals.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class FlashCardPage extends StatefulWidget {
  int topicId;
  int statusLearningId;
  FlashCardPage({ required this.statusLearningId, required this.topicId, super.key});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  final UserAuthController _userAuthController = new UserAuthController();
  final TopicController _topicController = new TopicController();
  final StatusLearningController _statusLearningController = new StatusLearningController();
  final CardsController _cardsController = new CardsController();

  late StatusLearning _statusLearning;
  late Topic _topic;
  late List<Cards> _cards;

  late List<Cards> _unMemoriedCards;
  late List<Cards> _memoried;

  late int _amountUnMemoriedCard;
  late int _amountMemoricard;

  Cards finishLearn = new Cards(id: 9999, topicId: 9999, term: 'Finished', createByUserEmail: '9999', mean: "Đã hoàn thành");

  bool _displayTxt = false;
  String _tutorialLeft = "Vuốt sang trái để đánh dấu ĐANG HỌC";
  String _tutorialRight = "Vuốt sang phải để đánh dấu ĐÃ BIẾT";

  bool _showWidgetSwiper = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _startDelayedDisplay();
    fetchStatusLearning();
    fetchTopic();
    fetchListCards();
    getListUnMemoried();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showWidgetSwiper = true;
      });
    });
    // _showWidgetLate2S();
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
            onPressed: () { Navigator.pop(context); },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
        }),
        title: Text("1/2", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
        actions: [
          Icon(Icons.settings, size: 30,)
        ],
      ),

      body: Column(
        children: [
          Container(
            height: 100,
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                    color: Colors.orange, // Màu của viền
                    width: 2, // Độ rộng của viền
                  ),
                  ),
                  child: Center(
                    child: Text(_showWidgetSwiper ? _statusLearning.cardMomorized.length.toString() : "0", style: TextStyle(color: Colors.orange, fontSize: 25),),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                    color: Colors.green, // Màu của viền
                    width: 2, // Độ rộng của viền
                  ),
                  ),
                  child: Center(
                    child: Text(_showWidgetSwiper ? _statusLearning.memorized.length.toString() : "0", style: TextStyle(color: Colors.green, fontSize: 25),),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 550,
            child: _showWidgetSwiper ?
            CardSwiper(
              cardBuilder: (context, index, x, y) {
                return 
                FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: ReusableCard(
                        text: (_amountUnMemoriedCard < 1) ?  finishLearn.term : _unMemoriedCards[index].term
                        ),
                    back: ReusableCard(
                        text: (_amountUnMemoriedCard < 1) ? finishLearn.mean : _unMemoriedCards[index].mean
                        ),
                  );
              }, 
              cardsCount: _amountUnMemoriedCard,
              onSwipe: (prevoius, current, direction) {
                if (direction == CardSwiperDirection.right) {
                  final currentIndex = current;
                  print("Current index:" + currentIndex.toString());
                  if (currentIndex == _amountUnMemoriedCard-1) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FlashCardTotalTest(statusLearningId: widget.statusLearningId, topicId: widget.topicId,)));
                    //Navigator.pop(context);
                  }

                  setState(() {
                    int cardId = _unMemoriedCards[currentIndex!].id;
                    _statusLearning.cardMomorized.remove(cardId);
                    _statusLearning.memorized.add(cardId);

                    _statusLearningController.updateStatusLearning(_statusLearning);
                  });
                  print(_unMemoriedCards[currentIndex!].mean);
                }
                else if (direction == CardSwiperDirection.left) {
                  print("Take left");
                }
          
                return true;
              },
              
            ) : Text("abc")
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  child: Container(
                    child: Icon(Icons.undo, color: Colors.grey, size: 35,)
                  ),
                  onTap: () {
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => FlashCardPage(statusLearningId: 2, topicId: widget.topicId))
                      );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(_displayTxt ? _tutorialLeft : _tutorialRight, textAlign: TextAlign.center,),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    child: Icon(Icons.play_arrow_rounded, color: Colors.grey, size: 35,)
                  ),
                  onTap: () {
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => FlashCardPage(statusLearningId: 2, topicId: widget.topicId,))
                      );
                  },
                ),
              ),
          

            ]
            
          )
        ]
      ),
    );
  }

  void _startDelayedDisplay() {
  Timer.periodic(Duration(seconds: 2), (timer) {
    setState(() {
      _displayTxt = !_displayTxt;
    });
  });


}

}