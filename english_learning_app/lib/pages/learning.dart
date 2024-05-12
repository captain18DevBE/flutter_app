import 'package:english_learning_app/pages/action_topics.dart';
import 'package:english_learning_app/pages/all_constants.dart';
import 'package:english_learning_app/pages/flashcard.dart';
import 'package:english_learning_app/pages/reusable_card.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class Learning extends StatefulWidget {
  const Learning({super.key});

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {

  final PageController _pageController = new PageController();

  late int _activePage = 2;

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
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
              Navigator.push(context, MaterialPageRoute(builder:(context) => ActionTopic()));
            }
          ), 
        ],
        title: Text("Leaning", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),

      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(
          children: [
            SizedBox(
                  width: 450,
                  height: 300,
                  child: 
                  PageView.builder(
                    controller: _pageController,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return FlipCard(
                          direction: FlipDirection.VERTICAL,
                          front: ReusableCard(
                              text: 'Con ga'
                              ),
                          back: ReusableCard(
                              text: 'Chicken'),
                          
                        );
                    }
                    )
              ),
            GestureDetector(
              child: Container(
                child: Icon(Icons.pages_rounded, color: Colors.black,)
              ),
              onTap: () {
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => const FlashCardPage())
                  );
              },
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
                            _pageController.animateToPage(index, duration: Duration(microseconds: 300), curve: Curves.ease);
                          },
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: index == _activePage ? mainColor : Colors.grey,
                          
                          ),
                        ),
                        
                      )
                    ),
                ),
                
              ),
                
            ),
          ],

        ),
        ),
    );
  }
}