import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:english_learning_app/controllers/StatusLearningController.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/models/StatusLearning.dart';
import 'package:english_learning_app/pages/learn_flash_card/reusable_card.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class FlashCardPage extends StatefulWidget {
  int topicId;

  FlashCardPage({required this.topicId, super.key});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  final UserAuthController _userAuthController = new UserAuthController();
  final TopicController _topicController = new TopicController();
  final StatusLearningController _statusLearningController = new StatusLearningController();


  bool _displayTxt = false;
  String _tutorialLeft = "Vuốt sang trái để đánh dấu ĐANG HỌC";
  String _tutorialRight = "Vuốt sang phải để đánh dấu ĐÃ BIẾT";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _startDelayedDisplay();
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
                    child: Text("0", style: TextStyle(color: Colors.orange, fontSize: 25),),
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
                    child: Text("0", style: TextStyle(color: Colors.green, fontSize: 25),),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 550,
            child: CardSwiper(
              cardBuilder: (context, index, x, y) {
                return 
                FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: ReusableCard(
                        text: 'Con ga'
                        ),
                    back: ReusableCard(
                        text: 'Chicken'),
                  );
              }, 
              cardsCount: 8,
              // backCardOffset: Offset(0,0),
              onSwipe: (prevoius, current, direction) {
                if (direction == CardSwiperDirection.right) {
                  print("Take Right");
                }
                else if (direction == CardSwiperDirection.left) {
                  print("Take left");
                }
          
                return true;
              },
              
            ),
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
                        MaterialPageRoute(builder: (context) => FlashCardPage(topicId: widget.topicId))
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
                        MaterialPageRoute(builder: (context) => FlashCardPage(topicId: widget.topicId,))
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