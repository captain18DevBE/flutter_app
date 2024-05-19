import 'package:english_learning_app/controllers/CardsController.dart';
import 'package:english_learning_app/controllers/StatusLearningController.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/models/Cards.dart';
import 'package:english_learning_app/models/StatusLearning.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/pages/learn_multiple_choise/multiple_test.dart';
import 'package:english_learning_app/pages/learn_typing/typing_test.dart';
import 'package:english_learning_app/pages/menu_topic/action_topics.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:english_learning_app/pages/learn_flash_card/flashcard.dart';
import 'package:english_learning_app/pages/learn_flash_card/reusable_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Learning extends StatefulWidget {
  int topicId;
  int statusLearningId;
  Learning({required this.statusLearningId, required this.topicId, super.key});

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  final UserAuthController _userAuthController = new UserAuthController();
  final TopicController _topicController = new TopicController();
  final CardsController _cardsController = new CardsController();
  final PageController _pageController = new PageController();
  final StatusLearningController _statusLearningController = new StatusLearningController();
  

  late User _user;
  late Topic _topic;
  late List<Cards> _cards;
  late int _activePage = 2;
  late StatusLearning _statusLearning;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    fetchTopic(widget.topicId);
    fetchListCards(widget.topicId);
    fetchStatusLearning();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      print("Have problem loading user ${error}");
    }
  }

  Future<void> fetchTopic(int topicId) async {
    try {
      var topic = await _topicController.getTopicById(widget.topicId);
      setState(() {
        _topic = topic;
      });
    } catch (error) {
      print('Failed to fetch topic: $error');
    }
  }

  Future<void> fetchListCards(int topicId) async {
    try {
      List<Cards> cards = await _cardsController.readCardsByTopicId(topicId);
      setState(() {
        _cards = cards;
        _isLoading = false; // Set loading to false when data is fetched
      });
    } catch (error) {
      print('Failed to fetch list cards: $error');
      setState(() {
        _isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => ActionTopic(topicId: _topic.id)));
            },
          ),
        ],
        title: Text(
          _isLoading ? 'Loading...' : _topic.title,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade100,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 450,
                      height: 300,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _cards.length,
                        itemBuilder: (context, index) {
                          final cardData = _cards[index];
                          return Stack(
                            children: [
                              FlipCard(
                                direction: FlipDirection.VERTICAL,
                                front: ReusableCard(
                                    text: cardData.term
                                    ),
                                back: ReusableCard(
                                    text: cardData.mean
                                    ),
                                
                                ),

                                Positioned(
                                  bottom: 50,
                                  right: 50,
                                  child: GestureDetector(
                                    child: Container(
                                      child: Icon(Icons.pages_rounded, color: mainColor,)
                                    ),
                                    onTap: () {
                                        Navigator.push(context, 
                                          MaterialPageRoute(builder: (context) => FlashCardPage(topicId: widget.topicId, statusLearningId: widget.statusLearningId,))
                                        );
                                    },
                                  ),
                                ),
                              
                            ],);
                        },
                      ),
                    ),
                    Positioned(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(
                            5,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: InkWell(
                                onTap: () {
                                  _pageController.animateToPage(
                                    index,
                                    duration: Duration(microseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 3,
                                  backgroundColor: index == _activePage ? mainColor : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            child: Text(
                              "Title: " + _topic.title,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: mainColor),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: mainColor, // Border color
                              width: 2, // Border width
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.save, color: mainColor),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Row(children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(_user.photoURL ?? "https://drive.google.com/file/d/1S_t4qHw4dgLMmJHEfcFcPkXDX2fpwYMF/view?usp=sharing"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(_user.email ?? "emailuser@gmail.com"),
                        ),
                        Container(
                          width: 40,
                        ),
                        Text("Số lượng thẻ: " + _cards.length.toString())
                      ],),
                    ),

                  

                  
                    ]),
                  
              ),
        
              
        
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(20, 10, 0, 5),
                child: Text("Tutorials Study set"),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                
                child: Column(
                  children: [
                  GestureDetector(
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(colors: <Color>[
                    Color(0xFF42A5F5),
                    Color.fromARGB(255, 117, 193, 255),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(_user.photoURL ??
                                "https://drive.google.com/file/d/1S_t4qHw4dgLMmJHEfcFcPkXDX2fpwYMF/view?usp=sharing"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(_user.email ?? "emailuser@gmail.com"),
                          ),
                          Container(
                            width: 40,
                          ),
                          Text("Số lượng thẻ: " + _cards.length.toString())
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(20, 10, 0, 5),
                      child: Text("Mô tả học phần"),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF42A5F5),
                                    Color.fromARGB(255, 117, 193, 255),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                  ),
                                  Icon(Icons.crop_landscape_rounded, color: Colors.white),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    "Thẻ ghi nhớ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FlashCardPage(topicId: widget.topicId)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF42A5F5),
                                    Color.fromARGB(255, 117, 193, 255),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                  ),
                                  Icon(Icons.book_outlined, color: Colors.white),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    "Học",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MultipleTest()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF42A5F5),
                                    Color.fromARGB(255, 117, 193, 255),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                  ),
                                  Icon(Icons.text_snippet, color: Colors.white),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    "Kiểm tra",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TypingTest()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 5, 20, 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Thuật ngữ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: _cards.length,
                        itemBuilder: ((context, index) {
                          return detailCards(index);
                        }),
                      ),
                    ),
                    Text("Flash Card", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                  ],
                )
              ),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FlashCardPage(topicId: widget.topicId, statusLearningId: widget.statusLearningId,)));
                
              },
            ),
                      ],),
                  ),
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                
                child: Column(
                  children: [
                  GestureDetector(
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(colors: <Color>[
                    Color(0xFF42A5F5),
                    Color.fromARGB(255, 117, 193, 255),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(Icons.book_outlined, color: Colors.white),
                    Container(
                      width: 10,
                    ),
                    Text("Learn", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                  ],
                )
              ),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MultipleTest(topicId: widget.topicId, statusLearningId: widget.statusLearningId,)));
                
              },
            ),
                      ],),
                  ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              
              child: Column(
                children: [
                GestureDetector(
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: <Color>[
                      Color(0xFF42A5F5),
                      Color.fromARGB(255, 117, 193, 255),
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Icon(Icons.text_snippet, color: Colors.white),
                      Container(
                        width: 10,
                      ),
                      Text("Test", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TypingTest()));
                },
            ),

            ],),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(25, 5, 20, 0),
              alignment: Alignment.centerLeft,
              child: Text("Vocabulary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),

            Container(
              height: 200,
              width: double.infinity,
              child: ListView.builder(
                itemCount: _cards.length,
                itemBuilder: ((context, index) {
                  
                return detailCards(index);
                
                
                })
              ),
            ),
    );
  }

  Widget detailCards(int index) {
    String team = _cards[index].term;
    String mean = _cards[index].mean;
    return Container(
      margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Maintain rounded corners
        border: Border.all(
          color: Colors.grey, // Set border color to black
          width: 1, // Set border width to 2 pixels (optional)
        ),
      ),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: Text(
                    team,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  flutterTts.speak(team);
                },
                child: Icon(
                  Icons.volume_up,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.star,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 5),
            alignment: Alignment.centerLeft,
            child: Text(
              mean,
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),
    );
  }
}
